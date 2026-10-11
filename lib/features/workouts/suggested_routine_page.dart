import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/database/providers/repository_providers.dart';
import '../../core/services/routine_generator.dart';
import '../../core/services/routine_planner.dart';
import '../../core/utils/exercise_labels.dart';
import '../../core/widgets/exercise_guide_view.dart';

/// Muestra el plan semanal (una rutina por día de entrenamiento) generado
/// según el perfil del usuario y le deja usarlo, pedir otro o descartarlo.
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
  List<PlannedRoutine> _plan = [];
  int _selectedDay = 0;

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
        _plan = _buildPlan();
        _selectedDay = 0;
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

  List<PlannedRoutine> _buildPlan() {
    final user = _user!;

    return const RoutinePlanner().generate(
      profile: GeneratorProfile(
        level: user.fitnessLevel,
        goal: _goalType,
        minutes: user.availableMinutes,
        equipment: _trainAt == 'gym' ? _allEquipment : _homeEquipment,
      ),
      catalog: _catalog,
      daysPerWeek: user.weeklyFrequency,
      variant: _variant,
    );
  }

  void _regenerate() {
    setState(() {
      _variant++;
      _plan = _buildPlan();
      _selectedDay = 0;
    });
  }

  String _locationSuffix() {
    return ' · ${_trainAt == 'gym' ? 'Gimnasio' : 'Casa'}';
  }

  Future<void> _useRoutine() async {
    final user = _user;

    if (_plan.isEmpty || user == null || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ref
          .read(suggestedRoutineServiceProvider)
          .savePlanAndActivate(
            userId: user.id,
            goal: _goalType,
            difficulty: user.fitnessLevel,
            daysPerWeek: user.weeklyFrequency,
            plan: _plan,
            nameSuffix: _locationSuffix(),
          );

      if (!mounted) {
        return;
      }

      final message = _plan.length == 1
          ? 'Tu rutina está lista y activa.'
          : 'Tu plan de ${_plan.length} días está listo. '
                'Hoy toca: ${_plan.first.day.name}.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
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
        SnackBar(content: Text('No se pudo guardar el plan: $error')),
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
      appBar: AppBar(title: const Text('Plan sugerido')),
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

    if (user == null || _plan.isEmpty) {
      return const SizedBox.shrink();
    }

    final selected = _plan[_selectedDay.clamp(0, _plan.length - 1)];
    final routine = selected.routine;
    final longestMinutes = _plan
        .map((item) => item.routine.estimatedMinutes)
        .reduce((a, b) => a > b ? a : b);
    final equipmentTip = _plan
        .map((item) => item.routine.equipmentTip)
        .whereType<String>()
        .firstOrNull;

    final colors = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          _plan.length == 1
              ? 'Tu rutina'
              : 'Tu plan de ${_plan.length} días',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          '${_goalLabel(_goalType)} · ${difficultyLabel(user.fitnessLevel)} · '
          '${user.weeklyFrequency} días por semana',
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
                _plan = _buildPlan();
                _selectedDay = 0;
              });
            },
          ),
        ],
        if (_plan.length > 1) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var day = 0; day < _plan.length; day++)
                ChoiceChip(
                  label: Text('Día ${day + 1}'),
                  selected: day == _selectedDay,
                  onSelected: (_) {
                    setState(() {
                      _selectedDay = day;
                    });
                  },
                ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        Text(
          selected.day.name,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          '${routine.exercises.length} ejercicios · '
          '~${routine.estimatedMinutes} min',
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        for (var index = 0; index < routine.exercises.length; index++)
          _ExerciseCard(
            position: index + 1,
            name: routine.exercises[index].exercise.name,
            muscle: muscleLabel(routine.exercises[index].exercise.primaryMuscle),
            prescription:
                '${routine.exercises[index].sets} series · '
                '${_repsText(routine.exercises[index].minReps, routine.exercises[index].maxReps)} '
                'repeticiones',
            rest: 'Descanso: ${routine.exercises[index].restSeconds} s',
            onTechnique: () => showExerciseGuideSheet(
              context,
              name: routine.exercises[index].exercise.name,
            ),
          ),
        const SizedBox(height: 12),
        Text(
          'Antes de empezar',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        if (_plan.length > 1)
          const _NoteCard(
            icon: Icons.autorenew,
            text:
                'Al terminar un entrenamiento, la app activa sola el '
                'siguiente día del plan. En Inicio verás cuál toca hoy.',
          ),
        if (equipmentTip != null)
          _NoteCard(
            icon: Icons.lightbulb_outline,
            text: equipmentTip,
          ),
        if (longestMinutes > user.availableMinutes)
          _NoteCard(
            icon: Icons.schedule,
            text:
                'Algún día del plan dura hasta $longestMinutes min, más de '
                'los ${user.availableMinutes} que tienes disponibles. Puedes '
                'cambiar tus minutos disponibles en Perfil.',
          ),
        if (user.weeklyFrequency >= 6)
          const _NoteCard(
            icon: Icons.event_repeat,
            text:
                'Con 6 o 7 días por semana el plan se repite. Procura '
                'descansar al menos un día para recuperarte bien.',
          ),
        const _NoteCard(
          icon: Icons.local_fire_department_outlined,
          text:
              'Calienta unos 5 minutos con movilidad suave y una serie ligera '
              'del primer ejercicio. Ya está incluido en el tiempo estimado.',
        ),
      ],
    );
  }

  Widget? _buildActions() {
    if (_isLoading || _errorMessage != null || _plan.isEmpty) {
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
                label: Text(_plan.length == 1 ? 'Usar esta rutina' : 'Usar este plan'),
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
    required this.prescription,
    required this.rest,
    required this.onTechnique,
  });

  final int position;
  final String name;
  final String muscle;

  /// Series y repeticiones, p. ej. "3 series · 8–10 repeticiones".
  final String prescription;

  /// Descanso entre series, p. ej. "Descanso: 90 s".
  final String rest;

  /// Abre la guía de técnica del ejercicio.
  final VoidCallback onTechnique;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                  const SizedBox(height: 8),
                  Text(
                    prescription,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    rest,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextButton.icon(
                    onPressed: onTechnique,
                    icon: const Icon(Icons.menu_book_outlined, size: 18),
                    label: const Text('Ver técnica'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
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
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
