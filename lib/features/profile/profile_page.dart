import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/providers/repository_providers.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isEditing = false;
  String? _errorMessage;

  User? _user;
  Goal? _activeGoal;

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  DateTime? _editingBirthDate;
  String _editingFitnessLevel = 'beginner';
  String _editingTrainingLocation = 'gym';
  int _editingWeeklyFrequency = 3;
  int _editingAvailableMinutes = 45;
  String _editingGoalType = 'general_fitness';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final userRepository = ref.read(userRepositoryProvider);
      final goalRepository = ref.read(goalRepositoryProvider);

      final user = await userRepository.getUser();

      if (user == null) {
        throw StateError('No hay un usuario configurado.');
      }

      final goals = await goalRepository.getAll();

      final userGoals = goals
          .where((goal) => goal.userId == user.id && goal.status == 'active')
          .toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _user = user;
        _activeGoal = userGoals.isEmpty ? null : userGoals.first;
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

  void _startEditing() {
    final user = _user;

    if (user == null) {
      return;
    }

    final activeGoal = _activeGoal;

    setState(() {
      _isEditing = true;

      _editingBirthDate = user.birthDate;

      _heightController.text = user.heightCm.toStringAsFixed(1);

      _weightController.text = user.currentWeightKg.toStringAsFixed(1);

      _editingFitnessLevel = user.fitnessLevel;
      _editingTrainingLocation = user.trainingLocation;
      _editingWeeklyFrequency = user.weeklyFrequency;
      _editingAvailableMinutes = user.availableMinutes;
      _editingGoalType = activeGoal?.type ?? 'general_fitness';
    });
  }

  void _cancelEditing() {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isEditing = false;
    });
  }

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();

    final currentDate =
        _editingBirthDate ?? DateTime(now.year - 18, now.month, now.day);

    final initialDate = currentDate.isAfter(now) ? now : currentDate;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _editingBirthDate = selectedDate;
    });
  }

  Future<void> _saveProfile() async {
    final user = _user;

    if (user == null || _isSaving) {
      return;
    }

    final birthDate = _editingBirthDate;

    if (birthDate == null) {
      _showMessage('Selecciona tu fecha de nacimiento.');
      return;
    }

    final height = double.tryParse(
      _heightController.text.trim().replaceAll(',', '.'),
    );

    final weight = double.tryParse(
      _weightController.text.trim().replaceAll(',', '.'),
    );

    if (height == null || height < 50 || height > 250) {
      _showMessage('La estatura debe estar entre 50 y 250 cm.');
      return;
    }

    if (weight == null || weight < 20 || weight > 300) {
      _showMessage('El peso debe estar entre 20 y 300 kg.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final userRepository = ref.read(userRepositoryProvider);
      final goalRepository = ref.read(goalRepositoryProvider);
      final weightEntryRepository = ref.read(weightEntryRepositoryProvider);

      final updatedUser = user.copyWith(
        birthDate: birthDate,
        heightCm: height,
        currentWeightKg: weight,
        fitnessLevel: _editingFitnessLevel,
        trainingLocation: _editingTrainingLocation,
        weeklyFrequency: _editingWeeklyFrequency,
        availableMinutes: _editingAvailableMinutes,
      );

      await userRepository.updateUser(updatedUser);

      final activeGoal = _activeGoal;

      if (activeGoal != null) {
        final updatedGoal = activeGoal.copyWith(
          type: _editingGoalType,
          name: _goalName(_editingGoalType),
        );

        await goalRepository.updateGoal(updatedGoal);
      } else {
        await goalRepository.save(
          userId: user.id,
          type: _editingGoalType,
          name: _goalName(_editingGoalType),
          targetValue: 0,
          unit: 'none',
          startDate: DateTime.now(),
          targetDate: null,
          status: 'active',
        );
      }

      if (weight != user.currentWeightKg) {
        await weightEntryRepository.save(
          userId: user.id,
          recordedAt: DateTime.now(),
          weightKg: weight,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
        _isEditing = false;
      });

      await _loadProfile();

      if (!mounted) {
        return;
      }

      _showMessage('Perfil actualizado correctamente.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      _showMessage('No se pudo actualizar el perfil: $error');
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

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();

    var age = today.year - birthDate.year;

    final birthdayThisYear = DateTime(
      today.year,
      birthDate.month,
      birthDate.day,
    );

    if (today.isBefore(birthdayThisYear)) {
      age--;
    }

    return age;
  }

  String _fitnessLevelLabel(String level) {
    switch (level) {
      case 'beginner':
        return 'Estoy empezando';
      case 'intermediate':
        return 'Tengo algo de experiencia';
      case 'advanced':
        return 'Tengo mucha experiencia';
      default:
        return level;
    }
  }

  String _trainingLocationLabel(String location) {
    switch (location) {
      case 'gym':
        return 'Gimnasio';
      case 'home':
        return 'Casa';
      case 'both':
        return 'Casa y gimnasio';
      default:
        return location;
    }
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

  String _goalName(String type) {
    return _goalLabel(type);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 64),
                const SizedBox(height: 20),
                const Text(
                  'No pudimos cargar tu perfil',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(_errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _loadProfile,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final user = _user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No se encontró la información del usuario.')),
      );
    }

    if (_isEditing) {
      return _buildEditProfile(user);
    }

    return _buildProfile(user);
  }

  Widget _buildProfile(User user) {
    final activeGoal = _activeGoal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            tooltip: 'Editar perfil',
            onPressed: _startEditing,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Center(
              child: CircleAvatar(
                radius: 42,
                child: Icon(
                  Icons.person_outline,
                  size: 44,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Tu perfil',
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Información que utilizamos para adaptar '
                'tu experiencia.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const _SectionTitle(title: 'Datos físicos'),
            const SizedBox(height: 10),
            _ProfileInfoCard(
              children: [
                _ProfileInfoRow(
                  icon: Icons.cake_outlined,
                  label: 'Edad',
                  value: '${_calculateAge(user.birthDate)} años',
                ),
                const Divider(height: 24),
                _ProfileInfoRow(
                  icon: Icons.height,
                  label: 'Estatura',
                  value: '${user.heightCm.toStringAsFixed(1)} cm',
                ),
                const Divider(height: 24),
                _ProfileInfoRow(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Peso actual',
                  value: '${user.currentWeightKg.toStringAsFixed(1)} kg',
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _SectionTitle(title: 'Experiencia y entrenamiento'),
            const SizedBox(height: 10),
            _ProfileInfoCard(
              children: [
                _ProfileInfoRow(
                  icon: Icons.trending_up,
                  label: 'Experiencia',
                  value: _fitnessLevelLabel(user.fitnessLevel),
                ),
                const Divider(height: 24),
                _ProfileInfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Lugar',
                  value: _trainingLocationLabel(user.trainingLocation),
                ),
                const Divider(height: 24),
                _ProfileInfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Frecuencia',
                  value:
                      '${user.weeklyFrequency} '
                      '${user.weeklyFrequency == 1 ? 'día' : 'días'} '
                      'por semana',
                ),
                const Divider(height: 24),
                _ProfileInfoRow(
                  icon: Icons.schedule_outlined,
                  label: 'Tiempo por sesión',
                  value: '${user.availableMinutes} minutos',
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _SectionTitle(title: 'Objetivo principal'),
            const SizedBox(height: 10),
            _ProfileInfoCard(
              children: [
                _ProfileInfoRow(
                  icon: Icons.flag_outlined,
                  label: 'Objetivo',
                  value: activeGoal == null
                      ? 'Sin objetivo activo'
                      : _goalLabel(activeGoal.type),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _startEditing,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Editar perfil'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditProfile(User user) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil'),
        leading: IconButton(
          tooltip: 'Cancelar',
          onPressed: _isSaving ? null : _cancelEditing,
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            const Text(
              'Actualiza tu información',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Estos datos se utilizarán para adaptar '
              'tu experiencia de entrenamiento.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            const _SectionTitle(title: 'Datos físicos'),
            const SizedBox(height: 12),
            _ProfileEditCard(
              children: [
                const Text(
                  'Fecha de nacimiento',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isSaving ? null : _selectBirthDate,
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(
                      _editingBirthDate == null
                          ? 'Seleccionar fecha'
                          : '${_editingBirthDate!.day.toString().padLeft(2, '0')}/'
                                '${_editingBirthDate!.month.toString().padLeft(2, '0')}/'
                                '${_editingBirthDate!.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _heightController,
                  enabled: !_isSaving,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Estatura',
                    suffixText: 'cm',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _weightController,
                  enabled: !_isSaving,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Peso actual',
                    suffixText: 'kg',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _SectionTitle(title: 'Experiencia y entrenamiento'),
            const SizedBox(height: 12),
            _ProfileEditCard(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _editingFitnessLevel,
                  decoration: const InputDecoration(
                    labelText: 'Experiencia entrenando',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'beginner',
                      child: Text('Estoy empezando'),
                    ),
                    DropdownMenuItem(
                      value: 'intermediate',
                      child: Text('Tengo algo de experiencia'),
                    ),
                    DropdownMenuItem(
                      value: 'advanced',
                      child: Text('Tengo mucha experiencia'),
                    ),
                  ],
                  onChanged: _isSaving
                      ? null
                      : (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            _editingFitnessLevel = value;
                          });
                        },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: _editingTrainingLocation,
                  decoration: const InputDecoration(
                    labelText: 'Lugar de entrenamiento',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'gym', child: Text('Gimnasio')),
                    DropdownMenuItem(value: 'home', child: Text('Casa')),
                    DropdownMenuItem(
                      value: 'both',
                      child: Text('Casa y gimnasio'),
                    ),
                  ],
                  onChanged: _isSaving
                      ? null
                      : (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            _editingTrainingLocation = value;
                          });
                        },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<int>(
                  initialValue: _editingWeeklyFrequency,
                  decoration: const InputDecoration(
                    labelText: 'Días por semana',
                    border: OutlineInputBorder(),
                  ),
                  items: List.generate(7, (index) {
                    final days = index + 1;

                    return DropdownMenuItem(
                      value: days,
                      child: Text(
                        '$days '
                        '${days == 1 ? 'día' : 'días'}',
                      ),
                    );
                  }),
                  onChanged: _isSaving
                      ? null
                      : (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            _editingWeeklyFrequency = value;
                          });
                        },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<int>(
                  initialValue: _editingAvailableMinutes,
                  decoration: const InputDecoration(
                    labelText: 'Tiempo disponible por sesión',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 15, child: Text('15 minutos')),
                    DropdownMenuItem(value: 20, child: Text('20 minutos')),
                    DropdownMenuItem(value: 30, child: Text('30 minutos')),
                    DropdownMenuItem(value: 45, child: Text('45 minutos')),
                    DropdownMenuItem(value: 60, child: Text('60 minutos')),
                    DropdownMenuItem(value: 75, child: Text('75 minutos')),
                    DropdownMenuItem(value: 90, child: Text('90 minutos')),
                    DropdownMenuItem(value: 120, child: Text('120 minutos')),
                  ],
                  onChanged: _isSaving
                      ? null
                      : (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            _editingAvailableMinutes = value;
                          });
                        },
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _SectionTitle(title: 'Objetivo principal'),
            const SizedBox(height: 12),
            _ProfileEditCard(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _editingGoalType,
                  decoration: const InputDecoration(
                    labelText: 'Objetivo',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'strength',
                      child: Text('Ganar fuerza'),
                    ),
                    DropdownMenuItem(
                      value: 'hypertrophy',
                      child: Text('Ganar masa muscular'),
                    ),
                    DropdownMenuItem(
                      value: 'fat_loss',
                      child: Text('Perder grasa'),
                    ),
                    DropdownMenuItem(
                      value: 'general_fitness',
                      child: Text('Mejorar condición física'),
                    ),
                  ],
                  onChanged: _isSaving
                      ? null
                      : (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            _editingGoalType = value;
                          });
                        },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : _cancelEditing,
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Guardar cambios'),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge
          ?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(children: children),
      ),
    );
  }
}

class _ProfileEditCard extends StatelessWidget {
  const _ProfileEditCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({
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

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: Icon(icon),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
