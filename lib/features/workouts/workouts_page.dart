import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/providers/repository_providers.dart';
import '../../core/services/timed_exercises.dart';
import '../../core/services/workout_grouping.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/number_format.dart';
import '../../core/utils/workout_labels.dart';
import '../../core/widgets/app_components.dart';
import '../exercises/exercises_page.dart';

class WorkoutsPage extends ConsumerStatefulWidget {
  const WorkoutsPage({super.key});

  @override
  ConsumerState<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends ConsumerState<WorkoutsPage> {
  bool _isLoading = true;
  String? _errorMessage;

  List<Workout> _workouts = [];
  final Map<int, int> _exerciseCounts = {};

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    try {
      final userRepository = ref.read(userRepositoryProvider);
      final workoutRepository = ref.read(workoutRepositoryProvider);
      final workoutExerciseRepository = ref.read(
        workoutExerciseRepositoryProvider,
      );

      final user = await userRepository.getUser();

      if (user == null) {
        throw StateError(
          'No hay un usuario configurado para administrar rutinas.',
        );
      }

      final workouts = await workoutRepository.getAllForUser(user.id);

      _exerciseCounts.clear();

      for (final workout in workouts) {
        final exercises = await workoutExerciseRepository.getForWorkout(
          workout.id,
        );

        _exerciseCounts[workout.id] = exercises.length;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _workouts = workouts;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _openSuggestedRoutine() async {
    final created = await context.push<bool>('/suggested-routine');

    if (created == true && mounted) {
      await _loadWorkouts();
    }
  }

  Future<void> _openEditor([Workout? workout]) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => WorkoutEditorPage(workout: workout)),
    );

    if (result == true) {
      await _loadWorkouts();
    }
  }

  Future<void> _setActive(Workout workout) async {
    try {
      final repository = ref.read(workoutRepositoryProvider);

      await repository.setActive(workout.id);

      await _loadWorkouts();

      if (!mounted) {
        return;
      }

      _showMessage('La rutina "${workout.name}" ahora está activa.');
    } catch (error) {
      _showMessage(error.toString());
    }
  }

  Future<void> _deleteWorkout(Workout workout) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar rutina'),
          content: Text(
            '¿Quieres eliminar "${workout.name}"?\n\n'
            'La rutina se eliminará, pero los entrenamientos históricos '
            'relacionados podrán conservarse.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      final repository = ref.read(workoutRepositoryProvider);

      final wasActive = workout.isActive;

      await repository.delete(workout.id);

      if (wasActive) {
        final remaining = await repository.getAllForUser(workout.userId);

        if (remaining.isNotEmpty) {
          await repository.setActive(remaining.first.id);
        }
      }

      await _loadWorkouts();

      if (!mounted) {
        return;
      }

      _showMessage('Rutina eliminada.');
    } catch (error) {
      _showMessage(error.toString());
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _goalLabel(String goal) {
    switch (goal) {
      case 'strength':
        return 'Fuerza';
      case 'hypertrophy':
        return 'Hipertrofia';
      case 'fat_loss':
        return 'Pérdida de grasa';
      case 'general_fitness':
        return 'Condición física';
      default:
        return goal;
    }
  }

  String _difficultyLabel(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return 'Principiante';
      case 'intermediate':
        return 'Intermedio';
      case 'advanced':
        return 'Avanzado';
      default:
        return difficulty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva rutina'),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final scheme = Theme.of(context).colorScheme;
    final count = _workouts.length;

    final subtitle = _isLoading || _errorMessage != null
        ? 'Tus planes de entrenamiento'
        : count == 0
        ? 'Empieza creando una'
        : pluralize(count, 'rutina guardada', 'rutinas guardadas');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rutinas',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Rutina sugerida',
            onPressed: _openSuggestedRoutine,
            icon: const Icon(Icons.auto_awesome_outlined),
          ),
          const SizedBox(width: 4),
          IconButton.filledTonal(
            tooltip: 'Biblioteca de ejercicios',
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ExercisesPage()));
            },
            icon: const Icon(Icons.menu_book_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_errorMessage!, textAlign: TextAlign.center),
        ),
      );
    }

    if (_workouts.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: AppEmptyState(
                icon: Icons.fitness_center,
                title: 'Todavía no tienes rutinas',
                message:
                    'Crea tu primera rutina y configura los ejercicios '
                    'que quieras realizar.',
                actions: [
                  FilledButton.icon(
                    onPressed: _openSuggestedRoutine,
                    icon: const Icon(Icons.auto_awesome_outlined),
                    label: const Text('Crear rutina sugerida'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _openEditor(),
                    icon: const Icon(Icons.add),
                    label: const Text('Crear rutina manualmente'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final groups = groupWorkouts(_workouts);
    final hasPlans = groups.any((group) => group.isPlan);

    final items = <Widget>[];

    for (final group in groups) {
      if (group.isPlan || hasPlans) {
        items.add(_buildGroupHeader(group));
      }

      for (final workout in group.workouts) {
        items.add(_buildWorkoutCard(workout, group));
      }
    }

    return RefreshIndicator(
      onRefresh: _loadWorkouts,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: items,
      ),
    );
  }

  Widget _buildGroupHeader(WorkoutGroup group) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 16, 2, 12),
      child: Row(
        children: [
          Icon(
            group.isPlan
                ? Icons.event_repeat_outlined
                : Icons.fitness_center_outlined,
            size: 20,
            color: scheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              group.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(Workout workout, WorkoutGroup group) {
    final scheme = Theme.of(context).colorScheme;
    final exerciseCount = _exerciseCounts[workout.id] ?? 0;
    final inPlan = group.isPlan;
    final dayNumber = inPlan ? workout.planPosition : null;

    final badge = !workout.isActive ? null : (inPlan ? 'HOY TOCA' : 'ACTIVA');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        shape: workout.isActive
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: AppTheme.lime, width: 1.5),
              )
            : null,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openEditor(workout),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (dayNumber != null) ...[
                      _DayBadge(day: dayNumber, highlighted: workout.isActive),
                      const SizedBox(width: 14),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (badge != null) ...[
                            AppPill(label: badge),
                            const SizedBox(height: 8),
                          ],
                          Text(
                            group.displayName(workout),
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontSize: 26),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_goalLabel(workout.goal)} · '
                            '${_difficultyLabel(workout.difficulty)}',
                            style: TextStyle(
                              fontSize: 15,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _openEditor(workout);
                            break;
                          case 'active':
                            _setActive(workout);
                            break;
                          case 'delete':
                            _deleteWorkout(workout);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Editar'),
                        ),
                        if (!workout.isActive)
                          PopupMenuItem(
                            value: 'active',
                            child: Text(
                              inPlan
                                  ? 'Que toque este día'
                                  : 'Establecer como activa',
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Eliminar'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppMetaChip(
                        icon: Icons.fitness_center,
                        label: pluralize(
                          exerciseCount,
                          'ejercicio',
                          'ejercicios',
                        ),
                      ),
                      if (!inPlan)
                        AppMetaChip(
                          icon: Icons.repeat,
                          label: '${workout.daysPerWeek} días/semana',
                        ),
                      AppMetaChip(
                        icon: Icons.schedule,
                        label: '${workout.estimatedDurationMinutes} min',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Número de día de un plan, en un cuadrado redondeado.
class _DayBadge extends StatelessWidget {
  const _DayBadge({required this.day, required this.highlighted});

  final int day;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Día $day',
      excludeSemantics: true,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: highlighted ? AppTheme.lime : scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DÍA',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                height: 1,
                color: highlighted ? AppTheme.onLime : scheme.onSurfaceVariant,
              ),
            ),
            Text(
              '$day',
              style: TextStyle(
                fontFamily: AppTheme.displayFont,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1.05,
                color: highlighted ? AppTheme.onLime : scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutEditorPage extends ConsumerStatefulWidget {
  const WorkoutEditorPage({super.key, this.workout});

  final Workout? workout;

  @override
  ConsumerState<WorkoutEditorPage> createState() => _WorkoutEditorPageState();
}

class _WorkoutEditorPageState extends ConsumerState<WorkoutEditorPage> {
  final _nameController = TextEditingController();
  final _daysController = TextEditingController();
  final _durationController = TextEditingController();

  String _goal = 'strength';
  String _difficulty = 'beginner';

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  int? _userId;
  Workout? _currentWorkout;
  List<WorkoutExercise> _exercises = [];

  @override
  void initState() {
    super.initState();

    if (widget.workout != null) {
      _nameController.text = widget.workout!.name;
      _goal = widget.workout!.goal;
      _difficulty = widget.workout!.difficulty;
      _daysController.text = widget.workout!.daysPerWeek.toString();
      _durationController.text = widget.workout!.estimatedDurationMinutes
          .toString();
    } else {
      _daysController.text = '3';
      _durationController.text = '45';
    }

    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _daysController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final userRepository = ref.read(userRepositoryProvider);
      final workoutRepository = ref.read(workoutRepositoryProvider);
      final workoutExerciseRepository = ref.read(
        workoutExerciseRepositoryProvider,
      );
      final database = ref.read(databaseProvider);

      final user = await userRepository.getUser();

      if (user == null) {
        throw StateError('No hay un usuario configurado.');
      }

      _userId = user.id;

      final exercises = await database.select(database.exercises).get();

      _exerciseNamesCache
        ..clear()
        ..addEntries(
          exercises.map((exercise) => MapEntry(exercise.id, exercise.name)),
        );

      if (widget.workout != null) {
        final workout = await workoutRepository.getById(widget.workout!.id);

        if (workout == null) {
          throw StateError('La rutina ya no existe.');
        }

        _currentWorkout = workout;

        _exercises = await workoutExerciseRepository.getForWorkout(workout.id);
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _saveWorkout() async {
    final userId = _userId;

    if (userId == null) {
      return;
    }

    final name = _nameController.text.trim();
    final daysPerWeek = int.tryParse(_daysController.text.trim());
    final duration = int.tryParse(_durationController.text.trim());

    if (name.isEmpty) {
      _showMessage('Introduce un nombre para la rutina.');
      return;
    }

    if (daysPerWeek == null || daysPerWeek < 1 || daysPerWeek > 7) {
      _showMessage('Los días por semana deben estar entre 1 y 7.');
      return;
    }

    if (duration == null || duration < 10 || duration > 240) {
      _showMessage('La duración debe estar entre 10 y 240 minutos.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final workoutRepository = ref.read(workoutRepositoryProvider);

      if (_currentWorkout == null) {
        final workoutId = await workoutRepository.save(
          userId: userId,
          name: name,
          goal: _goal,
          difficulty: _difficulty,
          daysPerWeek: daysPerWeek,
          estimatedDurationMinutes: duration,
        );

        final activeWorkout = await workoutRepository.getActiveForUser(userId);

        if (activeWorkout == null) {
          await workoutRepository.setActive(workoutId);
        }

        _currentWorkout = await workoutRepository.getById(workoutId);
      } else {
        final updatedWorkout = _currentWorkout!.copyWith(
          name: name,
          goal: _goal,
          difficulty: _difficulty,
          daysPerWeek: daysPerWeek,
          estimatedDurationMinutes: duration,
        );

        await workoutRepository.update(updatedWorkout);

        _currentWorkout = updatedWorkout;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      _showMessage('Rutina guardada correctamente.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      _showMessage(error.toString());
    }
  }

  Future<void> _setActive() async {
    final workout = _currentWorkout;

    if (workout == null) {
      return;
    }

    try {
      final repository = ref.read(workoutRepositoryProvider);

      await repository.setActive(workout.id);

      final updated = await repository.getById(workout.id);

      if (!mounted) {
        return;
      }

      setState(() {
        _currentWorkout = updated;
      });

      _showMessage('Rutina establecida como activa.');
    } catch (error) {
      _showMessage(error.toString());
    }
  }

  Future<void> _addExercise() async {
    final workout = _currentWorkout;

    if (workout == null) {
      _showMessage('Primero debes guardar la rutina.');
      return;
    }

    final database = ref.read(databaseProvider);
    final repository = ref.read(workoutExerciseRepositoryProvider);

    final allExercises = await database.select(database.exercises).get();

    final usedExerciseIds = _exercises.map((item) => item.exerciseId).toSet();

    final availableExercises = allExercises
        .where((exercise) => !usedExerciseIds.contains(exercise.id))
        .toList();

    if (availableExercises.isEmpty) {
      _showMessage('No hay ejercicios disponibles para agregar.');
      return;
    }

    if (!mounted) {
      return;
    }

    final draft = await showDialog<_ExerciseDraft>(
      context: context,
      builder: (_) => _ExerciseConfigDialog(
        title: 'Agregar ejercicio',
        exercises: availableExercises,
      ),
    );

    if (draft == null) {
      return;
    }

    try {
      await repository.save(
        workoutId: workout.id,
        exerciseId: draft.exerciseId,
        orderIndex: _exercises.length + 1,
        sets: draft.sets,
        minReps: draft.minReps,
        maxReps: draft.maxReps,
        restSeconds: draft.restSeconds,
        setType: draft.setType,
      );

      await _reloadExercises();

      if (!mounted) {
        return;
      }

      _showMessage('Ejercicio agregado.');
    } catch (error) {
      _showMessage(error.toString());
    }
  }

  Future<void> _editExercise(WorkoutExercise workoutExercise) async {
    final database = ref.read(databaseProvider);
    final repository = ref.read(workoutExerciseRepositoryProvider);

    final allExercises = await database.select(database.exercises).get();

    final usedByOtherExercise = _exercises
        .where((item) => item.id != workoutExercise.id)
        .map((item) => item.exerciseId)
        .toSet();

    final availableExercises = allExercises
        .where(
          (exercise) =>
              exercise.id == workoutExercise.exerciseId ||
              !usedByOtherExercise.contains(exercise.id),
        )
        .toList();

    final currentExerciseId = workoutExercise.exerciseId;

    if (!mounted) {
      return;
    }

    final draft = await showDialog<_ExerciseDraft>(
      context: context,
      builder: (_) => _ExerciseConfigDialog(
        title: 'Editar ejercicio',
        exercises: availableExercises,
        initialExerciseId: currentExerciseId,
        initialSets: workoutExercise.sets,
        initialMinReps: workoutExercise.minReps,
        initialMaxReps: workoutExercise.maxReps,
        initialRestSeconds: workoutExercise.restSeconds,
        initialSetType: workoutExercise.setType,
      ),
    );

    if (draft == null) {
      return;
    }

    final duplicate = _exercises.any(
      (item) =>
          item.id != workoutExercise.id && item.exerciseId == draft.exerciseId,
    );

    if (duplicate) {
      _showMessage('Ese ejercicio ya pertenece a la rutina.');
      return;
    }

    try {
      final updated = workoutExercise.copyWith(
        exerciseId: draft.exerciseId,
        sets: draft.sets,
        minReps: draft.minReps,
        maxReps: draft.maxReps,
        restSeconds: draft.restSeconds,
        setType: draft.setType,
      );

      await repository.update(updated);

      await _reloadExercises();

      if (!mounted) {
        return;
      }

      _showMessage('Ejercicio actualizado.');
    } catch (error) {
      _showMessage(error.toString());
    }
  }

  Future<void> _deleteExercise(WorkoutExercise workoutExercise) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar ejercicio'),
          content: const Text('¿Quieres quitar este ejercicio de la rutina?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      final repository = ref.read(workoutExerciseRepositoryProvider);

      await repository.delete(workoutExercise.id);

      await _reloadExercises();

      _showMessage('Ejercicio eliminado.');
    } catch (error) {
      _showMessage(error.toString());
    }
  }

  Future<void> _reloadExercises() async {
    final workout = _currentWorkout;

    if (workout == null) {
      return;
    }

    final repository = ref.read(workoutExerciseRepositoryProvider);

    var exercises = await repository.getForWorkout(workout.id);

    for (var i = 0; i < exercises.length; i++) {
      final expectedOrder = i + 1;

      if (exercises[i].orderIndex != expectedOrder) {
        await repository.update(
          exercises[i].copyWith(orderIndex: expectedOrder),
        );
      }
    }

    exercises = await repository.getForWorkout(workout.id);

    if (!mounted) {
      return;
    }

    setState(() {
      _exercises = exercises;
    });
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _goalLabel(String goal) {
    switch (goal) {
      case 'strength':
        return 'Fuerza';
      case 'hypertrophy':
        return 'Hipertrofia';
      case 'fat_loss':
        return 'Pérdida de grasa';
      case 'general_fitness':
        return 'Condición física';
      default:
        return goal;
    }
  }

  String _difficultyLabel(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return 'Principiante';
      case 'intermediate':
        return 'Intermedio';
      case 'advanced':
        return 'Avanzado';
      default:
        return difficulty;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rutina')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_errorMessage!, textAlign: TextAlign.center),
          ),
        ),
      );
    }

    final workout = _currentWorkout;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        Navigator.of(context).pop(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(workout == null ? 'Nueva rutina' : 'Editar rutina'),
          actions: [
            if (workout != null)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'active') {
                    _setActive();
                  }
                },
                itemBuilder: (context) => [
                  if (!workout.isActive)
                    const PopupMenuItem(
                      value: 'active',
                      child: Text('Establecer como activa'),
                    ),
                ],
              ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  workout == null ? 'Crear rutina' : workout.name,
                  style: textTheme.headlineLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  workout == null
                      ? 'Configura la estructura básica de tu rutina.'
                      : 'Modifica los datos y los ejercicios de la rutina.',
                  style: TextStyle(
                    fontSize: 16,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la rutina',
                    hintText: 'Ej. Fuerza tren superior',
                  ),
                ),
                const SizedBox(height: 20),
                _fieldLabel('Objetivo'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final option in _goalOptions.entries)
                      ChoiceChip(
                        label: Text(option.value),
                        selected: _goal == option.key,
                        onSelected: (_) => setState(() => _goal = option.key),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                _fieldLabel('Nivel'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final option in _difficultyOptions.entries)
                      ChoiceChip(
                        label: Text(option.value),
                        selected: _difficulty == option.key,
                        onSelected: (_) =>
                            setState(() => _difficulty = option.key),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _daysController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Días por semana',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Duración (min)',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _isSaving ? null : _saveWorkout,
                  child: _isSaving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : Text(
                          workout == null ? 'Crear rutina' : 'Guardar cambios',
                        ),
                ),
                if (workout != null) ...[
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Ejercicios', style: textTheme.titleLarge),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: _addExercise,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 44),
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (_exercises.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: AppEmptyState(
                          icon: Icons.fitness_center,
                          title: 'Sin ejercicios todavía',
                          message:
                              'Agrega ejercicios para poder utilizar '
                              'la rutina durante un entrenamiento.',
                          actions: [
                            FilledButton.icon(
                              onPressed: _addExercise,
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar ejercicio'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._exercises.asMap().entries.map((entry) {
                      final index = entry.key;
                      final exercise = entry.value;
                      final name = _exerciseName(exercise.exerciseId);
                      final timed = isTimedExercise(name);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: scheme.primaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontFamily: AppTheme.displayFont,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: scheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${formatSetsReps(sets: exercise.sets, minReps: exercise.minReps, maxReps: exercise.maxReps, timed: timed)}'
                                      ' · ${exercise.restSeconds} s descanso',
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                tooltip: 'Editar',
                                onPressed: () => _editExercise(exercise),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                tooltip: 'Eliminar',
                                onPressed: () => _deleteExercise(exercise),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 16),
                  if (!workout.isActive)
                    OutlinedButton.icon(
                      onPressed: _setActive,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Establecer como rutina activa'),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: scheme.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Esta es la rutina activa.',
                              style: TextStyle(
                                color: scheme.onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    '${_goalLabel(workout.goal)} · '
                    '${_difficultyLabel(workout.difficulty)} · '
                    '${workout.daysPerWeek} días/semana · '
                    '${workout.estimatedDurationMinutes} min',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  static const Map<String, String> _goalOptions = {
    'strength': 'Fuerza',
    'hypertrophy': 'Hipertrofia',
    'fat_loss': 'Pérdida de grasa',
    'general_fitness': 'Condición física',
  };

  static const Map<String, String> _difficultyOptions = {
    'beginner': 'Principiante',
    'intermediate': 'Intermedio',
    'advanced': 'Avanzado',
  };

  String _exerciseName(int exerciseId) {
    return _exerciseNamesCache[exerciseId] ?? 'Ejercicio #$exerciseId';
  }

  final Map<int, String> _exerciseNamesCache = {};
}

class _ExerciseDraft {
  const _ExerciseDraft({
    required this.exerciseId,
    required this.sets,
    required this.minReps,
    required this.maxReps,
    required this.restSeconds,
    required this.setType,
  });

  final int exerciseId;
  final int sets;
  final int minReps;
  final int maxReps;
  final int restSeconds;
  final String setType;
}

class _ExerciseConfigDialog extends StatefulWidget {
  const _ExerciseConfigDialog({
    required this.title,
    required this.exercises,
    this.initialExerciseId,
    this.initialSets = 3,
    this.initialMinReps = 8,
    this.initialMaxReps = 10,
    this.initialRestSeconds = 120,
    this.initialSetType = 'normal',
  });

  final String title;
  final List<Exercise> exercises;

  final int? initialExerciseId;
  final int initialSets;
  final int initialMinReps;
  final int initialMaxReps;
  final int initialRestSeconds;
  final String initialSetType;

  @override
  State<_ExerciseConfigDialog> createState() => _ExerciseConfigDialogState();
}

class _ExerciseConfigDialogState extends State<_ExerciseConfigDialog> {
  late int _exerciseId;

  late final TextEditingController _setsController;
  late final TextEditingController _minRepsController;
  late final TextEditingController _maxRepsController;
  late final TextEditingController _restController;

  late String _setType;

  @override
  void initState() {
    super.initState();

    _exerciseId = widget.initialExerciseId ?? widget.exercises.first.id;

    _setsController = TextEditingController(
      text: widget.initialSets.toString(),
    );

    _minRepsController = TextEditingController(
      text: widget.initialMinReps.toString(),
    );

    _maxRepsController = TextEditingController(
      text: widget.initialMaxReps.toString(),
    );

    _restController = TextEditingController(
      text: widget.initialRestSeconds.toString(),
    );

    _setType = widget.initialSetType;
  }

  @override
  void dispose() {
    _setsController.dispose();
    _minRepsController.dispose();
    _maxRepsController.dispose();
    _restController.dispose();
    super.dispose();
  }

  void _submit() {
    final sets = int.tryParse(_setsController.text.trim());
    final minReps = int.tryParse(_minRepsController.text.trim());
    final maxReps = int.tryParse(_maxRepsController.text.trim());
    final rest = int.tryParse(_restController.text.trim());

    if (sets == null || sets < 1 || sets > 20) {
      _showError('Las series deben estar entre 1 y 20.');
      return;
    }

    if (minReps == null || minReps < 1) {
      _showError('Las repeticiones mínimas deben ser mayores que 0.');
      return;
    }

    if (maxReps == null || maxReps < minReps) {
      _showError(
        'Las repeticiones máximas deben ser iguales o '
        'mayores que las mínimas.',
      );
      return;
    }

    if (rest == null || rest < 0 || rest > 900) {
      _showError('El descanso debe estar entre 0 y 900 segundos.');
      return;
    }

    Navigator.of(context).pop(
      _ExerciseDraft(
        exerciseId: _exerciseId,
        sets: sets,
        minReps: minReps,
        maxReps: maxReps,
        restSeconds: rest,
        setType: _setType,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              isExpanded: true,
              initialValue: _exerciseId,
              decoration: const InputDecoration(
                labelText: 'Ejercicio',
                ),
              items: widget.exercises
                  .map(
                    (exercise) => DropdownMenuItem<int>(
                      value: exercise.id,
                      child: Text(
                        exercise.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _exerciseId = value;
                });
              },
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final fieldWidth = (constraints.maxWidth - 10) / 2;

                return Wrap(
                  spacing: 10,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: _setsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Series',
                                    ),
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: _minRepsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Reps mín.',
                                    ),
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: _maxRepsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Reps máx.',
                                    ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _restController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Descanso (segundos)',
                ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _setType,
              decoration: const InputDecoration(
                labelText: 'Tipo de serie',
                ),
              items: const [
                DropdownMenuItem(value: 'normal', child: Text('Normal')),
                DropdownMenuItem(value: 'warmup', child: Text('Calentamiento')),
                DropdownMenuItem(value: 'dropset', child: Text('Drop set')),
                DropdownMenuItem(value: 'failure', child: Text('Al fallo')),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _setType = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Guardar')),
      ],
    );
  }
}
