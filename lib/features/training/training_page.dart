import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/exercise_guides.dart';
import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/providers/repository_providers.dart';
import '../../core/database/set_repository.dart';
import '../../core/router/active_tab_provider.dart';
import '../../core/services/progression_advisor.dart';
import '../../core/services/set_input_rules.dart';
import '../../core/services/timed_exercises.dart';
import '../../core/services/training_guidance.dart';
import '../../core/widgets/exercise_guide_view.dart';
import 'workout_session_controller.dart';
import 'package:go_router/go_router.dart';

class TrainingPage extends ConsumerStatefulWidget {
  const TrainingPage({super.key});

  @override
  ConsumerState<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends ConsumerState<TrainingPage> {
  // Saltos de los botones rápidos [-] / [+].
  static const double _weightStepKg = 2.5;
  static const int _repetitionsStep = 1;

  final _weightController = TextEditingController();
  final _repetitionsController = TextEditingController();

  bool _isPreparing = true;
  bool _showNoActiveWorkout = false;
  String? _preparationError;

  int? _userId;
  int? _workoutId;
  String _workoutName = '';
  String _workoutGoal = '';
  String _workoutLevel = '';

  // Series registradas en la sesión actual (solo en memoria): sirven para el
  // resumen que se muestra al terminar.
  final List<LoggedSet> _sessionLog = [];

  List<WorkoutExercise> _plannedExercises = [];
  final Map<int, String> _exerciseNames = {};

  // Ejercicios que no necesitan equipo (se hacen con el peso corporal).
  Set<int> _noEquipmentIds = {};

  int _currentPlannedIndex = 0;
  int _nextSetIndex = 1;

  List<WorkoutSet> _registeredSets = [];

  // Memoria: lo que hizo el usuario la última vez con el ejercicio actual.
  LastPerformance? _lastPerformance;
  ProgressionSuggestion? _suggestion;

  bool _hasRegisteredAnySet = false;

  DateTime? _startedAt;

  // Temporizador de descanso. Se guarda la hora de fin (y no un contador de
  // ticks) para que el tiempo restante sea correcto aunque la app haya
  // estado en segundo plano.
  Timer? _restTimer;
  DateTime? _restEndsAt;
  int? _restRemainingSeconds;

  late final ValueNotifier<int> _activeTab;

  @override
  void initState() {
    super.initState();

    _activeTab = ref.read(activeTabProvider);
    _activeTab.addListener(_onActiveTabChanged);

    _loadTrainingData();
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    _activeTab.removeListener(_onActiveTabChanged);
    _weightController.dispose();
    _repetitionsController.dispose();
    super.dispose();
  }

  /// Limpia el estado del descanso sin llamar a `setState`.
  /// Quien la use debe hacerlo dentro de un `setState` o antes de uno.
  void _clearRest() {
    _restTimer?.cancel();
    _restTimer = null;
    _restEndsAt = null;
    _restRemainingSeconds = null;
  }

  void _startRest(int seconds) {
    if (!mounted) {
      return;
    }

    if (seconds <= 0) {
      setState(_clearRest);
      return;
    }

    setState(() {
      _clearRest();
      _restEndsAt = DateTime.now().add(Duration(seconds: seconds));
      _restRemainingSeconds = seconds;
    });

    _restTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateRest(),
    );
  }

  void _updateRest() {
    final endsAt = _restEndsAt;

    if (!mounted || endsAt == null) {
      _restTimer?.cancel();
      return;
    }

    final remainingMilliseconds =
        endsAt.difference(DateTime.now()).inMilliseconds;

    if (remainingMilliseconds <= 0) {
      _finishRest();
      return;
    }

    setState(() {
      _restRemainingSeconds = (remainingMilliseconds / 1000).ceil();
    });
  }

  void _finishRest() {
    setState(_clearRest);

    HapticFeedback.heavyImpact();
    _showMessage('Descanso terminado.');
  }

  void _skipRest() {
    setState(_clearRest);
  }

  /// Convierte texto a número aceptando coma o punto como separador decimal
  /// (el teclado numérico en español puede insertar coma).
  double? _parseDecimal(String text) {
    return double.tryParse(text.trim().replaceAll(',', '.'));
  }

  /// Suma o resta [delta] kg al valor escrito. Si el resultado es 0 o menos,
  /// el campo se vacía, porque el peso es opcional (peso corporal).
  void _adjustWeight(double delta) {
    final current = _parseDecimal(_weightController.text) ?? 0;
    final next = current + delta;

    if (next <= 0) {
      _weightController.clear();
      return;
    }

    _setFieldText(_weightController, _formatWeight(next));
  }

  /// Salto de los botones [-] / [+] del campo de repeticiones: 1 repetición o,
  /// en ejercicios por tiempo, 5 segundos.
  int get _repetitionsStepNow =>
      _currentIsTimed ? TimedExercises.stepSeconds : _repetitionsStep;

  /// Suma o resta [delta] pasos de repeticiones. Nunca baja de 1.
  void _adjustRepetitions(int delta) {
    final current =
        int.tryParse(_repetitionsController.text.trim()) ?? 0;
    final next = current + delta * _repetitionsStepNow;

    if (next < 1) {
      return;
    }

    _setFieldText(_repetitionsController, next.toString());
  }

  void _setFieldText(TextEditingController controller, String text) {
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  /// 80.0 -> "80", 82.5 -> "82.5".
  String _formatWeight(double value) {
    final rounded = (value * 100).round() / 100;

    return rounded == rounded.roundToDouble()
        ? rounded.toStringAsFixed(0)
        : rounded.toString();
  }

  Future<void> _openSuggestedRoutine() async {
    final created = await context.push<bool>('/suggested-routine');

    if (created == true && mounted) {
      await _loadTrainingData();
    }
  }

  void _onActiveTabChanged() {
    if (_activeTab.value != MainTab.training) {
      return;
    }

    // Si hay un entrenamiento en curso no se recarga nada: se perdería el
    // ejercicio actual y las series que se ven en pantalla.
    if (ref.read(workoutSessionControllerProvider).isActive) {
      return;
    }

    _loadTrainingData();
  }

  Future<void> _loadTrainingData() async {
    try {
      final userRepository = ref.read(userRepositoryProvider);
      final workoutRepository = ref.read(
        workoutRepositoryProvider,
      );
      final workoutExerciseRepository = ref.read(
        workoutExerciseRepositoryProvider,
      );
      final database = ref.read(databaseProvider);

      final user = await userRepository.getUser();

      if (user == null) {
        throw StateError(
          'No hay un usuario configurado. '
              'Primero debes configurar tu perfil.',
        );
      }

      final workout = await workoutRepository.getActiveForUser(
        user.id,
      );

      if (workout == null) {
        if (!mounted) {
          return;
        }

        setState(() {
          _showNoActiveWorkout = true;
          _preparationError = null;
          _isPreparing = false;
        });

        return;
      }

      final plannedExercises =
      await workoutExerciseRepository.getForWorkout(
        workout.id,
      );

      if (plannedExercises.isEmpty) {
        throw StateError(
          'La rutina activa no tiene ejercicios configurados. '
              'Agrega al menos un ejercicio desde Rutinas.',
        );
      }

      final exercises =
      await database.select(database.exercises).get();

      _exerciseNames.clear();

      for (final exercise in exercises) {
        _exerciseNames[exercise.id] = exercise.name;
      }

      // Si falla, se tratan todos como ejercicios con peso: la pantalla
      // funciona igual.
      var noEquipmentIds = <int>{};

      try {
        final requirements = await ref
            .read(exerciseRepositoryProvider)
            .getRequiredEquipmentCodes();

        noEquipmentIds = {
          for (final exercise in exercises)
            if (!requirements.containsKey(exercise.id)) exercise.id,
        };
      } catch (_) {
        noEquipmentIds = <int>{};
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _userId = user.id;
        _workoutId = workout.id;
        _workoutName = workout.name;
        _workoutGoal = workout.goal;
        _workoutLevel = workout.difficulty;
        _plannedExercises = plannedExercises;
        _noEquipmentIds = noEquipmentIds;
        _currentPlannedIndex = 0;
        _isPreparing = false;
        _showNoActiveWorkout = false;
        _preparationError = null;
        _hasRegisteredAnySet = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _preparationError = error.toString();
        _isPreparing = false;
      });
    }
  }

  Future<void> _startTraining() async {
    final userId = _userId;
    final workoutId = _workoutId;

    if (userId == null ||
        workoutId == null ||
        _plannedExercises.isEmpty) {
      return;
    }

    final controller = ref.read(
      workoutSessionControllerProvider.notifier,
    );

    final firstExercise = _plannedExercises.first;

    await controller.startSession(
      userId: userId,
      workoutId: workoutId,
      exerciseCount: _plannedExercises.length,
      firstExerciseId: firstExercise.exerciseId,
      startedAt: DateTime.now(),
    );

    final state = ref.read(
      workoutSessionControllerProvider,
    );

    if (state.errorMessage != null) {
      return;
    }

    _startedAt = DateTime.now();
    _sessionLog.clear();
    _clearRest();
    _currentPlannedIndex = 0;
    _nextSetIndex = 1;
    _hasRegisteredAnySet = false;
    _weightController.clear();
    _repetitionsController.clear();

    await _loadCurrentSets();
    await _loadMemory();
  }

  Future<void> _loadCurrentSets() async {
    final sessionExerciseId = ref
        .read(workoutSessionControllerProvider)
        .currentExerciseId;

    if (sessionExerciseId == null) {
      return;
    }

    final repository = ref.read(setRepositoryProvider);

    final sets = await repository.getForSessionExercise(
      sessionExerciseId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _registeredSets = sets;
      _nextSetIndex = sets.length + 1;
    });
  }

  /// Busca lo que hizo el usuario la última vez con el ejercicio actual,
  /// calcula la sugerencia de carga y precarga los campos de peso y
  /// repeticiones. Si falla, la pantalla funciona igual sin memoria.
  Future<void> _loadMemory() async {
    final userId = _userId;

    if (userId == null || _plannedExercises.isEmpty) {
      return;
    }

    final planned = _plannedExercises[_currentPlannedIndex];

    LastPerformance? last;

    try {
      last = await ref.read(setRepositoryProvider).getLastPerformance(
            userId: userId,
            exerciseId: planned.exerciseId,
          );
    } catch (_) {
      last = null;
    }

    if (!mounted) {
      return;
    }

    ProgressionSuggestion? suggestion;

    if (last != null) {
      suggestion = _currentIsTimed
          ? TimedExercises.suggest(
              lastSeconds: last.sets.map((set) => set.repetitions).toList(),
              minSeconds: planned.minReps,
              maxSeconds: planned.maxReps,
            )
          : ProgressionAdvisor.suggest(
              lastSets: last.sets
                  .map(
                    (set) => PerformedSet(
                      weightKg: set.weightKg,
                      repetitions: set.repetitions,
                    ),
                  )
                  .toList(),
              minReps: planned.minReps,
              maxReps: planned.maxReps,
            );
    }

    setState(() {
      _lastPerformance = last;
      _suggestion = suggestion;
    });

    _applySuggestionToFields();
  }

  /// Precarga peso y repeticiones con la sugerencia (o vacía los campos si
  /// no hay historial del ejercicio).
  void _applySuggestionToFields() {
    final suggestion = _suggestion;

    if (suggestion == null) {
      _weightController.clear();
      _repetitionsController.clear();
      return;
    }

    final weight = suggestion.weightKg;

    if (weight == null) {
      _weightController.clear();
    } else {
      _setFieldText(_weightController, _formatWeight(weight));
    }

    _setFieldText(
      _repetitionsController,
      suggestion.repetitions.toString(),
    );
  }

  String _formatLastDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _formatLastSet(WorkoutSet set) {
    if (_currentIsTimed) {
      return '${set.repetitions} s';
    }

    return set.weightKg == null
        ? '${set.repetitions} rep.'
        : '${_formatWeight(set.weightKg!)} kg × ${set.repetitions}';
  }

  /// Un punto clave de técnica del ejercicio actual, siempre a la vista.
  Widget _buildCueLine(String exerciseName) {
    final cues = guideForExercise(exerciseName)?.cues;

    if (cues == null || cues.isEmpty) {
      return const SizedBox.shrink();
    }

    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, size: 18, color: scheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Clave: ${cues.first}',
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  /// Consejos para leer antes de empezar la sesión.
  Widget _buildPreWorkoutCard() {
    final tips = TrainingGuidance.preWorkoutTips(
      goal: _workoutGoal,
      level: _workoutLevel,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Antes de empezar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            for (final tip in tips)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(Icons.check_circle_outline, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(tip)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  WorkoutExercise? get _currentPlanned {
    if (_plannedExercises.isEmpty ||
        _currentPlannedIndex >= _plannedExercises.length) {
      return null;
    }

    return _plannedExercises[_currentPlannedIndex];
  }

  bool get _currentIsTimed {
    final planned = _currentPlanned;

    return planned != null &&
        isTimedExercise(_exerciseNames[planned.exerciseId] ?? '');
  }

  String get _repsUnitWord => _currentIsTimed ? 'segundos' : 'repeticiones';

  bool get _currentIsNoEquipment {
    final planned = _currentPlanned;

    return planned != null && _noEquipmentIds.contains(planned.exerciseId);
  }

  Widget _buildMemoryCard() {
    final last = _lastPerformance;
    final suggestion = _suggestion;
    final scheme = Theme.of(context).colorScheme;

    if (last == null) {
      final planned = _currentPlanned;

      return Card(
        margin: const EdgeInsets.only(top: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            SetInputRules.firstTimeMessage(
              noEquipment: _currentIsNoEquipment,
              minReps: planned?.minReps ?? 8,
              maxReps: planned?.maxReps ?? 12,
              timed: _currentIsTimed,
            ),
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Última vez · ${_formatLastDate(last.sessionStartedAt)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(last.sets.map(_formatLastSet).join('  ·  ')),
            if (suggestion != null) ...[
              const SizedBox(height: 12),
              Text(
                suggestion.message,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: suggestion.increasesLoad
                      ? scheme.primary
                      : scheme.onSurface,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _registerSet() async {
    final timed = _currentIsTimed;

    // En ejercicios por tiempo no hay peso: se ignora lo que haya en el campo.
    final weightText = timed ? '' : _weightController.text.trim();
    final repetitionsText = _repetitionsController.text.trim();

    final inputError = SetInputRules.validate(
      repetitionsText: repetitionsText,
      weightText: weightText,
      timed: timed,
    );

    if (inputError != null) {
      _showMessage(inputError);
      return;
    }

    final repetitions = int.parse(repetitionsText);

    final weightKg =
    weightText.isEmpty ? null : _parseDecimal(weightText);

    final controller = ref.read(
      workoutSessionControllerProvider.notifier,
    );

    await controller.addSet(
      setIndex: _nextSetIndex,
      weightKg: weightKg,
      repetitions: repetitions,
      setType: 'normal',
    );

    final state = ref.read(
      workoutSessionControllerProvider,
    );

    if (state.errorMessage != null) {
      _showMessage(state.errorMessage!);
      return;
    }

    _hasRegisteredAnySet = true;

    final plannedNow = _currentPlanned;

    _sessionLog.add(
      LoggedSet(
        exerciseName: plannedNow == null
            ? 'Ejercicio'
            : (_exerciseNames[plannedNow.exerciseId] ?? 'Ejercicio'),
        repetitions: repetitions,
        weightKg: weightKg,
        isTimed: timed,
      ),
    );

    await _loadCurrentSets();

    if (!mounted) {
      return;
    }

    _applySuggestionToFields();

    if (_plannedExercises.isNotEmpty) {
      _startRest(_plannedExercises[_currentPlannedIndex].restSeconds);
    }
  }

  Future<void> _goToNextExercise() async {
    final nextIndex = _currentPlannedIndex + 1;

    if (nextIndex >= _plannedExercises.length) {
      _showMessage(
        'Este es el último ejercicio de la rutina.',
      );
      return;
    }

    final controller = ref.read(
      workoutSessionControllerProvider.notifier,
    );

    final nextExercise = _plannedExercises[nextIndex];

    await controller.addNextExercise(
      exerciseId: nextExercise.exerciseId,
      orderIndex: nextIndex + 1,
    );

    final state = ref.read(
      workoutSessionControllerProvider,
    );

    if (state.errorMessage != null) {
      _showMessage(state.errorMessage!);
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _currentPlannedIndex = nextIndex;
      _nextSetIndex = 1;
      _registeredSets = [];
    });

    _weightController.clear();
    _repetitionsController.clear();

    await _loadCurrentSets();
    await _loadMemory();
  }

  Future<void> _finishTraining() async {
    final startedAt = _startedAt;

    if (startedAt == null) {
      return;
    }

    if (!_hasRegisteredAnySet) {
      _showMessage(
        'Registra al menos una serie antes de finalizar '
            'el entrenamiento.',
      );
      return;
    }

    final durationSeconds =
        DateTime.now().difference(startedAt).inSeconds;

    final controller = ref.read(
      workoutSessionControllerProvider.notifier,
    );

    await controller.completeSession(
      completedAt: DateTime.now(),
      durationSeconds: durationSeconds,
    );

    final state = ref.read(
      workoutSessionControllerProvider,
    );

    if (state.errorMessage != null) {
      _showMessage(state.errorMessage!);
      return;
    }

    if (!mounted) {
      return;
    }

    final finishedWorkoutId = _workoutId;

    final summary = TrainingGuidance.summarize(
      sets: List<LoggedSet>.of(_sessionLog),
      duration: Duration(seconds: durationSeconds),
    );
    final plannedCount = _plannedExercises.length;

    _sessionLog.clear();

    setState(() {
      _clearRest();
      _startedAt = null;
      _currentPlannedIndex = 0;
      _nextSetIndex = 1;
      _registeredSets = [];
      _lastPerformance = null;
      _suggestion = null;
      _hasRegisteredAnySet = false;
    });

    _weightController.clear();
    _repetitionsController.clear();

    // Si la rutina pertenece a un plan semanal, pasa a tocar la siguiente.
    String? nextWorkoutName;

    if (finishedWorkoutId != null) {
      try {
        final next = await ref
            .read(workoutRepositoryProvider)
            .activateNextInPlan(finishedWorkoutId);

        if (next != null && next.id != finishedWorkoutId) {
          nextWorkoutName = next.name;
        }
      } catch (_) {
        nextWorkoutName = null;
      }
    }

    if (!mounted) {
      return;
    }

    if (nextWorkoutName != null) {
      await _loadTrainingData();
    }

    if (!mounted) {
      return;
    }

    await _showSummaryDialog(
      summary: summary,
      plannedExercises: plannedCount,
      nextWorkoutName: nextWorkoutName,
    );
  }

  Future<void> _showSummaryDialog({
    required SessionSummary summary,
    required int plannedExercises,
    required String? nextWorkoutName,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('¡Entrenamiento guardado!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final line in TrainingGuidance.summaryLines(summary))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      line,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                Text(
                  TrainingGuidance.closingMessage(
                    plannedExercises: plannedExercises,
                    doneExercises: summary.exerciseCount,
                  ),
                ),
                if (nextWorkoutName != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    'Próxima rutina: $nextWorkoutName.',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Listo'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelTraining() async {
    final controller = ref.read(
      workoutSessionControllerProvider.notifier,
    );

    await controller.cancelSession();

    final state = ref.read(
      workoutSessionControllerProvider,
    );

    if (state.errorMessage != null) {
      _showMessage(state.errorMessage!);
      return;
    }

    if (!mounted) {
      return;
    }

    _sessionLog.clear();

    setState(() {
      _clearRest();
      _startedAt = null;
      _currentPlannedIndex = 0;
      _nextSetIndex = 1;
      _registeredSets = [];
      _lastPerformance = null;
      _suggestion = null;
      _hasRegisteredAnySet = false;
    });

    _weightController.clear();
    _repetitionsController.clear();

    _showMessage('Entrenamiento cancelado.');
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      workoutSessionControllerProvider,
    );

    if (_isPreparing) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_preparationError != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Entrenamiento'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _preparationError!,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (_showNoActiveWorkout) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Entrenar'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.fitness_center_outlined,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Aún no tienes una rutina activa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Crea una rutina o activa una de tus rutinas '
                      'para comenzar a entrenar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _openSuggestedRoutine,
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: const Text('Crear rutina sugerida'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    context.go('/workouts');
                  },
                  icon: const Icon(Icons.fitness_center),
                  label: const Text('Ir a Rutinas'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isTraining = state.isActive;
    final restRemainingSeconds = _restRemainingSeconds;

    final currentExercise =
    _plannedExercises.isEmpty
        ? null
        : _plannedExercises[_currentPlannedIndex];

    final currentExerciseName = currentExercise == null
        ? ''
        : _exerciseNames[currentExercise.exerciseId] ??
        'Ejercicio';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTraining ? 'Entrenamiento' : _workoutName,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isTraining) ...[
                Text(
                  _workoutName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_plannedExercises.length} ejercicios',
                  style: const TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Primer ejercicio',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  currentExerciseName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (currentExercise != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${currentExercise.sets} series · '
                        '${currentExercise.minReps}-'
                        '${currentExercise.maxReps} $_repsUnitWord',
                  ),
                ],
                const SizedBox(height: 20),
                _buildPreWorkoutCard(),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed:
                  state.isLoading ? null : _startTraining,
                  child: const Text('Iniciar entrenamiento'),
                ),
              ] else ...[
                LinearProgressIndicator(
                  value: _plannedExercises.isEmpty
                      ? 0
                      : (_currentPlannedIndex + 1) /
                      _plannedExercises.length,
                ),
                const SizedBox(height: 18),
                Text(
                  'Ejercicio ${_currentPlannedIndex + 1} '
                      'de ${_plannedExercises.length}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentExerciseName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (currentExercise != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${currentExercise.sets} series · '
                        '${currentExercise.minReps}-'
                        '${currentExercise.maxReps} $_repsUnitWord · '
                        '${currentExercise.restSeconds}s descanso',
                  ),
                ],
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => showExerciseGuideSheet(
                      context,
                      name: currentExerciseName,
                    ),
                    icon: const Icon(Icons.menu_book_outlined),
                    label: const Text('Ver técnica'),
                  ),
                ),
                _buildCueLine(currentExerciseName),
                _buildMemoryCard(),
                if (restRemainingSeconds != null) ...[
                  const SizedBox(height: 20),
                  _RestTimerCard(
                    remainingSeconds: restRemainingSeconds,
                    onSkip: _skipRest,
                  ),
                ],
                const SizedBox(height: 28),
                Text(
                  SetInputRules.registerTitle(
                    nextSetIndex: _nextSetIndex,
                    plannedSets: currentExercise?.sets ?? 0,
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (!_currentIsTimed) ...[
                _QuickAdjustField(
                  controller: _weightController,
                  labelText: SetInputRules.weightLabel(
                    noEquipment: _currentIsNoEquipment,
                  ),
                  hintText: SetInputRules.weightHint(
                    noEquipment: _currentIsNoEquipment,
                  ),
                  keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decrementTooltip: 'Restar $_weightStepKg kg',
                  incrementTooltip: 'Sumar $_weightStepKg kg',
                  onDecrement: () => _adjustWeight(-_weightStepKg),
                  onIncrement: () => _adjustWeight(_weightStepKg),
                ),
                const SizedBox(height: 12),
                ],
                _QuickAdjustField(
                  controller: _repetitionsController,
                  labelText: SetInputRules.repetitionsLabel(
                    timed: _currentIsTimed,
                  ),
                  hintText: SetInputRules.repetitionsHint(
                    timed: _currentIsTimed,
                  ),
                  keyboardType: TextInputType.number,
                  decrementTooltip: _currentIsTimed
                      ? 'Restar ${TimedExercises.stepSeconds} segundos'
                      : 'Restar $_repetitionsStep repetición',
                  incrementTooltip: _currentIsTimed
                      ? 'Sumar ${TimedExercises.stepSeconds} segundos'
                      : 'Sumar $_repetitionsStep repetición',
                  onDecrement: () => _adjustRepetitions(-1),
                  onIncrement: () => _adjustRepetitions(1),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed:
                  state.isLoading ? null : _registerSet,
                  child: const Text('Registrar serie'),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Series registradas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (_registeredSets.isEmpty)
                  const Text(
                    'Todavía no has registrado series.',
                  )
                else
                  ..._registeredSets.map(
                        (set) => Card(
                      child: ListTile(
                        title: Text('Serie ${set.setIndex}'),
                        subtitle: Text(
                          SetInputRules.setText(
                            repetitions: set.repetitions,
                            weightKg: set.weightKg,
                            timed: _currentIsTimed,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: state.isLoading
                      ? null
                      : _goToNextExercise,
                  child: Text(
                    _currentPlannedIndex ==
                        _plannedExercises.length - 1
                        ? 'Último ejercicio'
                        : 'Siguiente ejercicio',
                  ),
                ),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed:
                  state.isLoading ? null : _finishTraining,
                  child: const Text('Finalizar entrenamiento'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed:
                  state.isLoading ? null : _cancelTraining,
                  child: const Text('Cancelar entrenamiento'),
                ),
              ],
              if (state.isLoading) ...[
                const SizedBox(height: 20),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
              if (state.errorMessage != null) ...[
                const SizedBox(height: 20),
                Text(
                  state.errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .error,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Tarjeta que muestra la cuenta atrás del descanso entre series.
class _RestTimerCard extends StatelessWidget {
  const _RestTimerCard({
    required this.remainingSeconds,
    required this.onSkip,
  });

  final int remainingSeconds;
  final VoidCallback onSkip;

  String get _formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      color: colors.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            Icon(
              Icons.timer_outlined,
              color: colors.onSecondaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Descanso',
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.onSecondaryContainer,
                    ),
                  ),
                  Text(
                    _formattedTime,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colors.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onSkip,
              child: const Text('Omitir'),
            ),
          ],
        ),
      ),
    );
  }
}


/// Campo numérico con botones [-] y [+] a los lados para ajustar el valor
/// sin abrir el teclado.
class _QuickAdjustField extends StatelessWidget {
  const _QuickAdjustField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.keyboardType,
    required this.decrementTooltip,
    required this.incrementTooltip,
    required this.onDecrement,
    required this.onIncrement,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final String decrementTooltip;
  final String incrementTooltip;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: onDecrement,
          tooltip: decrementTooltip,
          icon: const Icon(Icons.remove),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed: onIncrement,
          tooltip: incrementTooltip,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
