import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/providers/repository_providers.dart';
import 'workout_session_controller.dart';

class TrainingPage extends ConsumerStatefulWidget {
  const TrainingPage({super.key});

  @override
  ConsumerState<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends ConsumerState<TrainingPage> {
  final _weightController = TextEditingController();
  final _repetitionsController = TextEditingController();

  bool _isPreparing = true;
  String? _preparationError;

  int? _userId;
  int? _workoutId;
  String _workoutName = '';

  List<WorkoutExercise> _plannedExercises = [];
  final Map<int, String> _exerciseNames = {};

  int _currentPlannedIndex = 0;
  int _nextSetIndex = 1;

  List<WorkoutSet> _registeredSets = [];

  bool _hasRegisteredAnySet = false;

  DateTime? _startedAt;

  @override
  void initState() {
    super.initState();
    _loadTrainingData();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repetitionsController.dispose();
    super.dispose();
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
        throw StateError(
          'No tienes una rutina activa. '
              'Ve a Rutinas y establece una rutina como activa.',
        );
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

      if (!mounted) {
        return;
      }

      setState(() {
        _userId = user.id;
        _workoutId = workout.id;
        _workoutName = workout.name;
        _plannedExercises = plannedExercises;
        _currentPlannedIndex = 0;
        _isPreparing = false;
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
    _currentPlannedIndex = 0;
    _nextSetIndex = 1;
    _hasRegisteredAnySet = false;
    _weightController.clear();
    _repetitionsController.clear();

    await _loadCurrentSets();
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

  Future<void> _registerSet() async {
    final weightText = _weightController.text.trim();
    final repetitionsText = _repetitionsController.text.trim();

    if (repetitionsText.isEmpty) {
      _showMessage('Introduce las repeticiones.');
      return;
    }

    final repetitions = int.tryParse(repetitionsText);

    if (repetitions == null || repetitions <= 0) {
      _showMessage('Las repeticiones deben ser un número válido.');
      return;
    }

    final weightKg =
    weightText.isEmpty ? null : double.tryParse(weightText);

    if (weightText.isNotEmpty &&
        (weightKg == null || weightKg < 0)) {
      _showMessage('El peso debe ser un número válido.');
      return;
    }

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

    await _loadCurrentSets();

    if (!mounted) {
      return;
    }

    _weightController.clear();
    _repetitionsController.clear();
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

    setState(() {
      _startedAt = null;
      _currentPlannedIndex = 0;
      _nextSetIndex = 1;
      _registeredSets = [];
      _hasRegisteredAnySet = false;
    });

    _weightController.clear();
    _repetitionsController.clear();

    _showMessage('Entrenamiento guardado correctamente.');
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

    setState(() {
      _startedAt = null;
      _currentPlannedIndex = 0;
      _nextSetIndex = 1;
      _registeredSets = [];
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

    final isTraining = state.isActive;

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
                        '${currentExercise.maxReps} repeticiones',
                  ),
                ],
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
                        '${currentExercise.maxReps} repeticiones · '
                        '${currentExercise.restSeconds}s descanso',
                  ),
                ],
                const SizedBox(height: 28),
                const Text(
                  'Registrar serie',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _weightController,
                  keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Peso (kg)',
                    hintText: 'Ej. 80',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _repetitionsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Repeticiones',
                    hintText: 'Ej. 10',
                    border: OutlineInputBorder(),
                  ),
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
                          set.weightKg == null
                              ? '${set.repetitions} repeticiones'
                              : '${set.weightKg} kg · '
                              '${set.repetitions} repeticiones',
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