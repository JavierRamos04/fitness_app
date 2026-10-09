import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/database/providers/repository_providers.dart';
import '../../core/services/routine_generator.dart';
import '../../core/utils/exercise_labels.dart';

/// Muestra una rutina de cuerpo completo generada según el perfil del usuario
/// y le deja usarla, pedir otra o descartarla.
///
/// Devuelve `true` al cerrarse si se creó la rutina. Si se abrió sin una
/// pantalla anterior (por ejemplo, al terminar el onboarding), navega al
/// inicio en lugar de volver atrás.
class SuggestedRoutinePage extends ConsumerStatefulWidget {
  const SuggestedRoutinePage({super.key});

  @override
  ConsumerState<SuggestedRoutinePage> createState() =>
      _SuggestedRoutinePageState();
}

class _SuggestedRoutinePageState extends ConsumerState<SuggestedRoutinePage> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  User? _user;
  String _goalType = 'general_fitness';
  List<GeneratorExercise> _catalog = [];
  Set<String> _allEquipment = {};
  Set<String> _homeEquipment = {};

  /// `home` o `gym`: dónde se va a usar la rutina.
  String _trainAt = 'gym';
  int _variant = 0;
  SuggestedRoutine? _routine;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await ref.read(userRepositoryProvider).getUser();

      if (user == null) {
        throw StateError('Primero completa tu perfil para generar una rutina.');
      }

      final goals = await ref.read(goalRepositoryProvider).getAll();

      final activeGoals = goals
          .where((goal) => goal.userId == user.id && goal.status == 'active')
          .toList();

      final catalog = await ref
          .read(exerciseRepositoryProvider)
          .getGeneratorCatalog();

      final equipment = await ref.read(equipmentRepositoryProvider).getAll();

      final homeEquipment = await ref
          .read(userEquipmentRepositoryProvider)
          .getCodes(user.id);

      if (!mounted) {
        return;
      }

      setState(() {
        _user = user;
        _goalType = activeGoals.isEmpty
            ? 'general_fitness'
            : activeGoals.first.type;
        _catalog = catalog;
        _allEquipment = equipment.map((item) => item.code).toSet();
        _homeEquipment = homeEquipment;
        _trainAt = user.trainingLocation == 'gym' ? 'gym' : 'home';
        _variant = 0;
        _routine = _buildRoutine();
        _isLoading = false;
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

  SuggestedRoutine _buildRoutine() {
    final user = _user!;

    return const RoutineGenerator().generate(
      profile: GeneratorProfile(
        level: user.fitnessLevel,
        goal: _goalType,
        minutes: user.availableMinutes,
        equipment: _trainAt == 'gym' ? _allEquipment : _homeEquipment,
      ),
      catalog: _catalog,
      variant: _variant,
    );
  }

  void _regenerate() {
    setState(() {
      _variant++;
      _routine = _buildRoutine();
    });
  }

  String _routineName() {
    return 'Cuerpo completo · ${_trainAt == 'gym' ? 'Gimnasio' : 'Casa'}';
  }

  Future<void> _useRoutine() async {
    final routine = _routine;
    final user = _user;

    if (routine == null || user == null || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final name = _routineName();

      await ref
          .read(suggestedRoutineServiceProvider)
          .saveAndActivate(
            userId: user.id,
            name: name,
            goal: _goalType,
            difficulty: user.fitnessLevel,
            daysPerWeek: user.weeklyFrequency,
            routine: routine,
          );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La rutina "$name" está lista y activa.')),
      );

      _close(created: true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar la rutina: $error')),
      );
    }
  }

  void _close({required bool created}) {
    if (context.canPop()) {
      context.pop(created);
    } else {
      context.go('/');
    }
  }

  String _goalLabel(String goal) {
    switch (goal) {
      case 'strength':
        return 'Ganar fuerza';
      case 'hypertrophy':
        return 'Ganar masa muscular';
      case 'fat_loss':
        return 'Perder grasa';
      default:
        return 'Mejorar condición física';
    }
  }

  String _repsText(int minReps, int maxReps) {
    return minReps == maxReps ? '$minReps' : '$minReps–$maxReps';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rutina sugerida')),
      body: _buildBody(),
      bottomNavigationBar: _buildActions(),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton(onPressed: _load, child: const Text('Reintentar')),
            ],
          ),
        ),
      );
    }

    final user = _user;
    final routine = _routine;

    if (user == null || routine == null) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          'Cuerpo completo',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          '${_goalLabel(_goalType)} · ${difficultyLabel(user.fitnessLevel)} · '
          '${routine.exercises.length} ejercicios · '
          '~${routine.estimatedMinutes} min',
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
        if (user.trainingLocation == 'both') ...[
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'home',
                label: Text('Casa'),
                icon: Icon(Icons.home_outlined),
              ),
              ButtonSegment(
                value: 'gym',
                label: Text('Gimnasio'),
                icon: Icon(Icons.fitness_center),
              ),
            ],
            selected: {_trainAt},
            onSelectionChanged: (selection) {
              setState(() {
                _trainAt = selection.first;
                _variant = 0;
                _routine = _buildRoutine();
              });
            },
          ),
        ],
        const SizedBox(height: 16),
        for (var index = 0; index < routine.exercises.length; index++)
          _ExerciseCard(
            position: index + 1,
            name: routine.exercises[index].exercise.name,
            muscle: muscleLabel(routine.exercises[index].exercise.primaryMuscle),
            detail:
                '${routine.exercises[index].sets} series · '
                '${_repsText(routine.exercises[index].minReps, routine.exercises[index].maxReps)} '
                'repeticiones · '
                '${routine.exercises[index].restSeconds} s de descanso',
          ),
        const SizedBox(height: 8),
        if (routine.equipmentTip != null)
          _NoteCard(
            icon: Icons.lightbulb_outline,
            text: routine.equipmentTip!,
          ),
        if (routine.estimatedMinutes > user.availableMinutes)
          _NoteCard(
            icon: Icons.schedule,
            text:
                'Esta rutina dura unos ${routine.estimatedMinutes} min, más de '
                'los ${user.availableMinutes} que tienes disponibles. Puedes '
                'cambiar tus minutos disponibles en Perfil.',
          ),
        if (user.weeklyFrequency >= 5)
          const _NoteCard(
            icon: Icons.event_repeat,
            text:
                'Es una rutina de cuerpo completo: úsala 3 o 4 días por semana '
                'y descansa los demás para recuperarte bien.',
          ),
        const _NoteCard(
          icon: Icons.local_fire_department_outlined,
          text:
              'Calienta unos 5 minutos antes de empezar: movilidad suave y '
              'una serie ligera del primer ejercicio. Ya está incluido en el '
              'tiempo estimado.',
        ),
      ],
    );
  }

  Widget? _buildActions() {
    if (_isLoading || _errorMessage != null || _routine == null) {
      return null;
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _useRoutine,
                icon: const Icon(Icons.check),
                label: const Text('Usar esta rutina'),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : _regenerate,
                    child: const Text('Generar otra'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: _isSaving ? null : () => _close(created: false),
                    child: const Text('Ahora no'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.position,
    required this.name,
    required this.muscle,
    required this.detail,
  });

  final int position;
  final String name;
  final String muscle;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 16, child: Text('$position')),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    muscle,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(detail),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      color: colors.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colors.onSecondaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: colors.onSecondaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
