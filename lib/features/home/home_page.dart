import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/database/history_repository.dart';
import '../../core/database/providers/repository_providers.dart';
import '../../core/router/active_tab_provider.dart';
import '../../core/services/timed_exercises.dart';
import '../../core/utils/date_format.dart';
import '../../core/utils/workout_labels.dart';
import '../../core/widgets/app_components.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _isLoading = true;
  String? _errorMessage;

  Goal? _activeGoal;
  Workout? _activeWorkout;

  // Ejercicios de la rutina activa y tamaño de su plan (para "Hoy toca").
  List<_TodayExercise> _todayExercises = [];
  int? _planSize;

  int _sessionCount = 0;
  int _streak = 0;

  // Ejercicios que se muestran en la tarjeta principal.
  static const int _previewLines = 4;

  late final ValueNotifier<int> _activeTab;

  @override
  void initState() {
    super.initState();

    _activeTab = ref.read(activeTabProvider);
    _activeTab.addListener(_onActiveTabChanged);

    _loadHomeData();
  }

  @override
  void dispose() {
    _activeTab.removeListener(_onActiveTabChanged);
    super.dispose();
  }

  Future<void> _openSuggestedRoutine() async {
    final created = await context.push<bool>('/suggested-routine');

    if (created == true && mounted) {
      await _loadHomeData();
    }
  }

  void _onActiveTabChanged() {
    if (_activeTab.value == MainTab.home) {
      _loadHomeData();
    }
  }

  Future<void> _loadHomeData() async {
    try {
      final userRepository = ref.read(userRepositoryProvider);

      final goalRepository = ref.read(goalRepositoryProvider);

      final workoutRepository = ref.read(workoutRepositoryProvider);

      final historyRepository = ref.read(historyRepositoryProvider);

      final user = await userRepository.getUser();

      if (user == null) {
        throw StateError('No hay un usuario configurado.');
      }

      final goals = await goalRepository.getAll();

      final userGoals = goals
          .where((goal) => goal.userId == user.id && goal.status == 'active')
          .toList();

      final history = await historyRepository.getCompletedForUser(user.id);

      final activeWorkout = await workoutRepository.getActiveForUser(user.id);

      final todayExercises = <_TodayExercise>[];
      int? planSize;

      if (activeWorkout != null) {
        final planned = await ref
            .read(workoutExerciseRepositoryProvider)
            .getForWorkout(activeWorkout.id);

        final names = {
          for (final exercise
              in await ref.read(exerciseRepositoryProvider).getAll())
            exercise.id: exercise.name,
        };

        for (final item in planned) {
          todayExercises.add(
            _TodayExercise(
              name: names[item.exerciseId] ?? 'Ejercicio',
              detail: formatSetsReps(
                sets: item.sets,
                minReps: item.minReps,
                maxReps: item.maxReps,
                timed: isTimedExercise(names[item.exerciseId] ?? ''),
              ),
            ),
          );
        }

        final planKey = activeWorkout.planKey;

        if (planKey != null) {
          planSize = (await workoutRepository.getPlanWorkouts(
            userId: user.id,
            planKey: planKey,
          ))
              .length;
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _activeGoal = userGoals.isEmpty ? null : userGoals.first;
        _activeWorkout = activeWorkout;
        _todayExercises = todayExercises;
        _planSize = planSize;
        _sessionCount = history.length;
        _streak = _calculateStreak(history);
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

  int _calculateStreak(List<TrainingHistoryItem> history) {
    if (history.isEmpty) {
      return 0;
    }

    final completedDays = <DateTime>{};

    for (final item in history) {
      final date = item.session.startedAt;

      completedDays.add(DateTime(date.year, date.month, date.day));
    }

    if (completedDays.isEmpty) {
      return 0;
    }

    var currentDay = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (!completedDays.contains(currentDay)) {
      currentDay = currentDay.subtract(const Duration(days: 1));
    }

    var streak = 0;

    while (completedDays.contains(currentDay)) {
      streak++;

      currentDay = currentDay.subtract(const Duration(days: 1));
    }

    return streak;
  }

  String _goalLabel(String type) {
    switch (type) {
      case 'strength':
        return 'Ganar fuerza';
      case 'hypertrophy':
        return 'Ganar masa muscular';
      case 'fat_loss':
        return 'Perder grasa';
      case 'general_fitness':
        return 'Mejorar condición física';
      default:
        return type;
    }
  }

  String _goalDescription(String type) {
    switch (type) {
      case 'strength':
        return 'Series más pesadas, pocas repeticiones y descansos largos.';
      case 'hypertrophy':
        return 'Volumen moderado, 8-12 repeticiones y cerca del fallo técnico.';
      case 'fat_loss':
        return 'Series con más repeticiones y descansos cortos para mantener '
            'el ritmo.';
      case 'general_fitness':
        return 'Rutinas equilibradas para todo el cuerpo y buena técnica.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Inicio')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 64),
                const SizedBox(height: 20),
                const Text(
                  'No pudimos cargar tu información',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(_errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _loadHomeData,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final activeGoal = _activeGoal;
    final activeWorkout = _activeWorkout;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _loadHomeData,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Text(
                formatLongDate(DateTime.now()),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text('Tu entrenamiento', style: textTheme.headlineLarge),
              const SizedBox(height: 20),

              if (activeWorkout == null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: AppEmptyState(
                      icon: Icons.fitness_center,
                      title: 'Aún no tienes rutina',
                      message:
                          'Crea una rutina sugerida según tu perfil o '
                          'revisa tus rutinas para elegir una.',
                      actions: [
                        FilledButton(
                          onPressed: _openSuggestedRoutine,
                          child: const Text('Crear rutina sugerida'),
                        ),
                        OutlinedButton(
                          onPressed: () => context.go('/workouts'),
                          child: const Text('Ver mis rutinas'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                AppHeroCard(
                  eyebrow: todayLabel(
                    planPosition: activeWorkout.planKey == null
                        ? null
                        : activeWorkout.planPosition,
                    planSize: _planSize,
                  ),
                  title: activeWorkout.name,
                  chips: [
                    if (_todayExercises.isNotEmpty)
                      (
                        Icons.format_list_numbered,
                        '${_todayExercises.length} ejercicios',
                      ),
                    (
                      Icons.schedule,
                      '${activeWorkout.estimatedDurationMinutes} min',
                    ),
                  ],
                  lines: [
                    for (final item in _todayExercises.take(_previewLines))
                      AppHeroLine(name: item.name, detail: item.detail),
                  ],
                  moreLabel: _todayExercises.length > _previewLines
                      ? '+${_todayExercises.length - _previewLines} más'
                      : null,
                  actionLabel: 'Comenzar entrenamiento',
                  onAction: () => context.go('/training'),
                ),

              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppStatCard(
                      icon: Icons.local_fire_department_outlined,
                      value: '$_streak',
                      unit: _streak == 1 ? 'día' : 'días',
                      label: 'Racha actual',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppStatCard(
                      icon: Icons.fitness_center_outlined,
                      value: '$_sessionCount',
                      label: _sessionCount == 1
                          ? 'Sesión completada'
                          : 'Sesiones completadas',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppIconBadge(icon: Icons.flag_outlined),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tu objetivo',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              activeGoal == null
                                  ? 'Sin objetivo activo'
                                  : _goalLabel(activeGoal.type),
                              style: textTheme.titleLarge,
                            ),
                            if (activeGoal != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                _goalDescription(activeGoal.type),
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.35,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayExercise {
  const _TodayExercise({required this.name, required this.detail});

  final String name;

  /// Series y repeticiones, p. ej. "3×8-12".
  final String detail;
}
