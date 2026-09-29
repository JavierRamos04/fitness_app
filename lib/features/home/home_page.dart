import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/database/history_repository.dart';
import '../../core/database/providers/repository_providers.dart';
import '../../core/router/active_tab_provider.dart';

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

  int _sessionCount = 0;
  int _streak = 0;

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

      if (!mounted) {
        return;
      }

      setState(() {
        _activeGoal = userGoals.isEmpty ? null : userGoals.first;
        _activeWorkout = activeWorkout;
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

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: RefreshIndicator(
        onRefresh: _loadHomeData,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              'Tu entrenamiento',
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Todo listo para tu próxima sesión.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      activeWorkout == null
                          ? 'Entrenamiento del día'
                          : activeWorkout.name,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      activeWorkout == null
                          ? 'Todavía no tienes una rutina activa. '
                                'Crea una rutina para comenzar a entrenar.'
                          : '${activeWorkout.estimatedDurationMinutes} '
                                'minutos · ${activeWorkout.daysPerWeek} '
                                'días por semana.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          if (activeWorkout == null) {
                            context.go('/workouts');
                            return;
                          }

                          context.go('/training');
                        },
                        child: Text(
                          activeWorkout == null
                              ? 'Crear rutina'
                              : 'Comenzar entrenamiento',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department_outlined,
                    label: 'Racha',
                    value: '$_streak días',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.fitness_center_outlined,
                    label: 'Sesiones',
                    value: '$_sessionCount',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  foregroundColor: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer,
                  child: const Icon(Icons.flag_outlined),
                ),
                title: const Text(
                  'Tu objetivo',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  activeGoal == null
                      ? 'Todavía no tienes un objetivo activo.'
                      : _goalLabel(activeGoal.type),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
