import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/providers/repository_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/decimal_parser.dart';
import '../../core/widgets/app_components.dart';
import '../../core/widgets/equipment_selector.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  DateTime? _birthDate;

  int _step = 0;

  String _fitnessLevel = 'beginner';
  String _trainingLocation = 'gym';
  int _weeklyFrequency = 3;
  int _availableMinutes = 45;

  String _goalType = 'strength';
  String _goalName = 'Ganar fuerza';

  bool _isSaving = false;

  List<EquipmentData> _homeEquipmentOptions = [];
  Set<String> _homeEquipment = {};

  final List<Map<String, String>> _goals = const [
    {'type': 'strength', 'name': 'Ganar fuerza'},
    {'type': 'hypertrophy', 'name': 'Ganar masa muscular'},
    {'type': 'fat_loss', 'name': 'Perder grasa'},
    {'type': 'general_fitness', 'name': 'Mejorar condición física'},
  ];

  static const List<_Choice> _levelOptions = [
    _Choice(
      value: 'beginner',
      icon: Icons.emoji_nature_outlined,
      title: 'Estoy empezando',
      subtitle: 'Llevas poco tiempo o nunca has entrenado de forma constante.',
    ),
    _Choice(
      value: 'intermediate',
      icon: Icons.trending_up,
      title: 'Tengo algo de experiencia',
      subtitle: 'Conoces los ejercicios básicos y sigues mejorando.',
    ),
    _Choice(
      value: 'advanced',
      icon: Icons.local_fire_department_outlined,
      title: 'Tengo mucha experiencia',
      subtitle: 'Dominas la técnica y sabes estructurar tus entrenamientos.',
    ),
  ];

  static const List<_Choice> _locationOptions = [
    _Choice(
      value: 'gym',
      icon: Icons.fitness_center,
      title: 'Gimnasio',
      subtitle: 'Máquinas, barras y mancuernas.',
    ),
    _Choice(
      value: 'home',
      icon: Icons.home_outlined,
      title: 'Casa',
      subtitle: 'Con tu equipo o con tu peso corporal.',
    ),
    _Choice(
      value: 'both',
      icon: Icons.swap_horiz,
      title: 'Casa y gimnasio',
      subtitle: 'Alternas según el día.',
    ),
  ];

  static const Map<String, String> _goalDescriptions = {
    'strength': 'Series pesadas, pocas repeticiones y descansos largos.',
    'hypertrophy': 'Volumen moderado y 8-12 repeticiones por serie.',
    'fat_loss': 'Más repeticiones y descansos cortos para mantener el ritmo.',
    'general_fitness': 'Rutinas equilibradas para todo el cuerpo.',
  };

  @override
  void initState() {
    super.initState();
    _loadHomeEquipmentOptions();
  }

  Future<void> _loadHomeEquipmentOptions() async {
    try {
      final options = await ref
          .read(equipmentRepositoryProvider)
          .getHomeOptions();

      if (!mounted) {
        return;
      }

      setState(() {
        _homeEquipmentOptions = options;
      });
    } catch (_) {
      // Si no se pueden cargar, el resto del onboarding sigue funcionando
      // y simplemente no se ofrece elegir el equipo.
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();

    final initialDate =
        _birthDate ?? DateTime(now.year - 25, now.month, now.day);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      _birthDate = selectedDate;
    });
  }

  void _nextStep() {
    if (_step == 0 && !_validatePersonalData()) {
      return;
    }

    if (_step < 2) {
      setState(() {
        _step++;
      });

      return;
    }

    _saveOnboarding();
  }

  void _previousStep() {
    if (_step == 0) {
      return;
    }

    setState(() {
      _step--;
    });
  }

  bool _validatePersonalData() {
    if (_birthDate == null) {
      _showMessage('Selecciona tu fecha de nacimiento.');

      return false;
    }

    final height = parseDecimal(_heightController.text);

    if (height == null || height < 100 || height > 250) {
      _showMessage('Introduce una estatura válida entre 100 y 250 cm.');

      return false;
    }

    final weight = parseDecimal(_weightController.text);

    if (weight == null || weight < 20 || weight > 300) {
      _showMessage('Introduce un peso válido entre 20 y 300 kg.');

      return false;
    }

    return true;
  }

  Future<void> _saveOnboarding() async {
    if (!_validatePersonalData() || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Ya validados en _validatePersonalData(), por eso no pueden ser null.
      final height = parseDecimal(_heightController.text)!;

      final weight = parseDecimal(_weightController.text)!;

      final database = ref.read(databaseProvider);

      final userRepository = ref.read(userRepositoryProvider);

      final goalRepository = ref.read(goalRepositoryProvider);

      final userEquipmentRepository = ref.read(
        userEquipmentRepositoryProvider,
      );

      final existingUser = await userRepository.getUser();

      if (existingUser != null) {
        if (!mounted) {
          return;
        }

        context.go('/');
        return;
      }

      await database.transaction(() async {
        final userId = await database
            .into(database.users)
            .insert(
              UsersCompanion.insert(
                birthDate: _birthDate!,
                heightCm: height,
                currentWeightKg: weight,
                fitnessLevel: _fitnessLevel,
                trainingLocation: _trainingLocation,
                weeklyFrequency: _weeklyFrequency,
                availableMinutes: _availableMinutes,
              ),
            );

        await goalRepository.save(
          userId: userId,
          type: _goalType,
          name: _goalName,
          targetValue: 0,
          unit: 'none',
          startDate: DateTime.now(),
          targetDate: null,
          status: 'active',
        );

        // Con gimnasio se asume que hay de todo, así que no se guarda nada.
        if (_trainingLocation != 'gym') {
          await userEquipmentRepository.replaceAll(userId, _homeEquipment);
        }
      });

      if (!mounted) {
        return;
      }

      // Primer uso: se ofrece una rutina lista para empezar.
      context.go('/suggested-routine');
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage('No se pudo guardar tu información: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configura tu perfil')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
              child: _StepBar(current: _step, total: 3),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: _buildStep(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSaving ? null : _previousStep,
                        child: const Text('Atrás'),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isSaving ? null : _nextStep,
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_step == 2 ? 'Comenzar' : 'Continuar'),
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

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _buildPersonalDataStep();
      case 1:
        return _buildTrainingStep();
      default:
        return _buildGoalStep();
    }
  }

  Widget _buildPersonalDataStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          step: 1,
          title: 'Cuéntanos un poco sobre ti',
          subtitle:
              'Usaremos estos datos para adaptar tu experiencia de '
              'entrenamiento.',
        ),
        const _FieldLabel('Fecha de nacimiento'),
        OutlinedButton.icon(
          onPressed: _selectBirthDate,
          icon: const Icon(Icons.calendar_today_outlined),
          label: Text(
            _birthDate == null
                ? 'Seleccionar fecha'
                : '${_birthDate!.day.toString().padLeft(2, '0')}/'
                      '${_birthDate!.month.toString().padLeft(2, '0')}/'
                      '${_birthDate!.year}',
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _heightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Estatura',
            suffixText: 'cm',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Peso actual',
            suffixText: 'kg',
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          step: 2,
          title: '¿Cómo es tu experiencia entrenando?',
          subtitle:
              'Cuéntanos un poco sobre tu experiencia para adaptar mejor '
              'tus rutinas.',
        ),
        const _FieldLabel('Tu experiencia entrenando'),
        for (final option in _levelOptions)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppOptionTile(
              icon: option.icon,
              title: option.title,
              subtitle: option.subtitle,
              selected: _fitnessLevel == option.value,
              onTap: () => setState(() => _fitnessLevel = option.value),
            ),
          ),
        const SizedBox(height: 10),
        const _FieldLabel('Lugar de entrenamiento'),
        for (final option in _locationOptions)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppOptionTile(
              icon: option.icon,
              title: option.title,
              subtitle: option.subtitle,
              selected: _trainingLocation == option.value,
              onTap: () => setState(() => _trainingLocation = option.value),
            ),
          ),
        if (_trainingLocation != 'gym' &&
            _homeEquipmentOptions.isNotEmpty) ...[
          const SizedBox(height: 20),
          const _FieldLabel('¿Qué equipo tienes en casa?'),
          const SizedBox(height: 4),
          Text(
            'Si no tienes ninguno, déjalo vacío: usaremos ejercicios con tu peso corporal.',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          EquipmentSelector(
            options: _homeEquipmentOptions,
            selectedCodes: _homeEquipment,
            enabled: !_isSaving,
            onChanged: (codes) {
              setState(() {
                _homeEquipment = codes;
              });
            },
          ),
        ],
        const SizedBox(height: 20),
        DropdownButtonFormField<int>(
          initialValue: _weeklyFrequency,
          decoration: const InputDecoration(
            labelText: 'Días por semana',
          ),
          items: List.generate(7, (index) {
            final days = index + 1;

            return DropdownMenuItem(
              value: days,
              child: Text('$days ${days == 1 ? 'día' : 'días'}'),
            );
          }),
          onChanged: (value) {
            if (value == null) {
              return;
            }

            setState(() {
              _weeklyFrequency = value;
            });
          },
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<int>(
          initialValue: _availableMinutes,
          decoration: const InputDecoration(
            labelText: 'Tiempo disponible por sesión',
          ),
          items: const [
            DropdownMenuItem(value: 20, child: Text('20 minutos')),
            DropdownMenuItem(value: 30, child: Text('30 minutos')),
            DropdownMenuItem(value: 45, child: Text('45 minutos')),
            DropdownMenuItem(value: 60, child: Text('60 minutos')),
            DropdownMenuItem(value: 75, child: Text('75 minutos')),
            DropdownMenuItem(value: 90, child: Text('90 minutos')),
            DropdownMenuItem(value: 120, child: Text('120 minutos')),
          ],
          onChanged: (value) {
            if (value == null) {
              return;
            }

            setState(() {
              _availableMinutes = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildGoalStep() {
    return RadioGroup<String>(
      groupValue: _goalType,
      onChanged: (value) {
        if (value == null) {
          return;
        }

        final selectedGoal = _goals.firstWhere((goal) => goal['type'] == value);

        setState(() {
          _goalType = value;
          _goalName = selectedGoal['name']!;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepHeader(
            step: 3,
            title: '¿Cuál es tu objetivo principal?',
            subtitle: 'Podrás cambiar y ampliar tus objetivos más adelante.',
          ),
          ..._goals.map((goal) {
            final type = goal['type']!;
            final name = goal['name']!;

            final selected = _goalType == type;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: selected
                      ? const BorderSide(color: AppTheme.lime, width: 1.5)
                      : BorderSide.none,
                ),
                child: RadioListTile<String>(
                  value: type,
                  title: Text(
                    name,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 24),
                  ),
                  subtitle: Text(_goalDescriptions[type] ?? ''),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Barra de pasos segmentada: un tramo por paso del asistente.
class _StepBar extends StatelessWidget {
  const _StepBar({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Paso ${current + 1} de $total',
      excludeSemantics: true,
      child: Row(
        children: [
          for (var index = 0; index < total; index++) ...[
            if (index > 0) const SizedBox(width: 6),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 6,
                decoration: BoxDecoration(
                  color: index <= current
                      ? scheme.primary
                      : scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Encabezado de cada paso: "PASO 1 DE 3", título grande y explicación.
class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.step,
    required this.title,
    required this.subtitle,
  });

  final int step;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PASO $step DE 3',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(title, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              height: 1.35,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Etiqueta sobre un grupo de opciones.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
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
}

/// Opción de una pregunta de elección única.
class _Choice {
  const _Choice({
    required this.value,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String value;
  final IconData icon;
  final String title;
  final String subtitle;
}
