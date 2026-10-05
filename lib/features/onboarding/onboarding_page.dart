import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/database/providers/repository_providers.dart';
import '../../core/utils/decimal_parser.dart';

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

  final List<Map<String, String>> _goals = const [
    {'type': 'strength', 'name': 'Ganar fuerza'},
    {'type': 'hypertrophy', 'name': 'Ganar masa muscular'},
    {'type': 'fat_loss', 'name': 'Perder grasa'},
    {'type': 'general_fitness', 'name': 'Mejorar condición física'},
  ];

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
      });

      if (!mounted) {
        return;
      }

      context.go('/');
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

  String _fitnessLevelDescription() {
    switch (_fitnessLevel) {
      case 'beginner':
        return 'Nunca has entrenado de forma constante o llevas poco tiempo aprendiendo.';
      case 'intermediate':
        return 'Ya has entrenado durante un tiempo y conoces los ejercicios básicos, aunque todavía estás aprendiendo y mejorando.';
      case 'advanced':
        return 'Llevas bastante tiempo entrenando y conoces bien los ejercicios, la técnica y la forma de estructurar tus entrenamientos.';
      default:
        return '';
    }
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
              child: LinearProgressIndicator(value: (_step + 1) / 3),
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
        const Text(
          'Cuéntanos un poco sobre ti',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Usaremos estos datos para adaptar tu experiencia de entrenamiento.',
        ),
        const SizedBox(height: 32),
        const Text(
          'Fecha de nacimiento',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
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
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Peso actual',
            suffixText: 'kg',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¿Cómo es tu experiencia entrenando?',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Cuéntanos un poco sobre tu experiencia para adaptar mejor tus rutinas.',
        ),
        const SizedBox(height: 32),
        DropdownButtonFormField<String>(
          initialValue: _fitnessLevel,
          decoration: const InputDecoration(
            labelText: 'Tu experiencia entrenando',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'beginner', child: Text('Estoy empezando')),
            DropdownMenuItem(
              value: 'intermediate',
              child: Text('Tengo algo de experiencia'),
            ),
            DropdownMenuItem(
              value: 'advanced',
              child: Text('Tengo mucha experiencia'),
            ),
          ],
          onChanged: (value) {
            if (value == null) {
              return;
            }

            setState(() {
              _fitnessLevel = value;
            });
          },
        ),
        const SizedBox(height: 8),
        Text(
          _fitnessLevelDescription(),
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          initialValue: _trainingLocation,
          decoration: const InputDecoration(
            labelText: 'Lugar de entrenamiento',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'gym', child: Text('Gimnasio')),
            DropdownMenuItem(value: 'home', child: Text('Casa')),
            DropdownMenuItem(value: 'both', child: Text('Casa y gimnasio')),
          ],
          onChanged: (value) {
            if (value == null) {
              return;
            }

            setState(() {
              _trainingLocation = value;
            });
          },
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<int>(
          initialValue: _weeklyFrequency,
          decoration: const InputDecoration(
            labelText: 'Días por semana',
            border: OutlineInputBorder(),
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
            border: OutlineInputBorder(),
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
          const Text(
            '¿Cuál es tu objetivo principal?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Podrás cambiar y ampliar tus objetivos más adelante.'),
          const SizedBox(height: 32),
          ..._goals.map((goal) {
            final type = goal['type']!;
            final name = goal['name']!;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: RadioListTile<String>(value: type, title: Text(name)),
              ),
            );
          }),
        ],
      ),
    );
  }
}
