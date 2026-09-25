import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

class ExercisesPage extends ConsumerStatefulWidget {
  const ExercisesPage({super.key});

  @override
  ConsumerState<ExercisesPage> createState() =>
      _ExercisesPageState();
}

class _ExercisesPageState
    extends ConsumerState<ExercisesPage> {
  bool _isLoading = true;
  String? _errorMessage;

  List<Exercise> _allExercises = [];
  List<Exercise> _filteredExercises = [];

  final _searchController = TextEditingController();

  String _difficultyFilter = 'all';
  String _muscleFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadExercises() async {
    try {
      final database = ref.read(databaseProvider);

      final exercises =
      await database.select(database.exercises).get();

      if (!mounted) {
        return;
      }

      setState(() {
        _allExercises = exercises;
        _filteredExercises = exercises;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _allExercises = [];
        _filteredExercises = [];
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  void _applyFilters() {
    final search =
    _searchController.text.trim().toLowerCase();

    final filtered = _allExercises.where((exercise) {
      final matchesSearch =
          search.isEmpty ||
              exercise.name.toLowerCase().contains(search) ||
              exercise.primaryMuscle
                  .toLowerCase()
                  .contains(search) ||
              exercise.movementPattern
                  .toLowerCase()
                  .contains(search);

      final matchesDifficulty =
          _difficultyFilter == 'all' ||
              exercise.difficulty == _difficultyFilter;

      final matchesMuscle =
          _muscleFilter == 'all' ||
              exercise.primaryMuscle == _muscleFilter;

      return matchesSearch &&
          matchesDifficulty &&
          matchesMuscle;
    }).toList();

    setState(() {
      _filteredExercises = filtered;
    });
  }

  List<String> get _availableMuscles {
    final muscles = _allExercises
        .map((exercise) => exercise.primaryMuscle)
        .toSet()
        .toList();

    muscles.sort();
    return muscles;
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

  String _muscleLabel(String muscle) {
    switch (muscle) {
      case 'chest':
        return 'Pecho';
      case 'back':
        return 'Espalda';
      case 'quadriceps':
        return 'Cuádriceps';
      case 'hamstrings':
        return 'Isquiotibiales';
      case 'glutes':
        return 'Glúteos';
      case 'calves':
        return 'Pantorrillas';
      case 'shoulders':
        return 'Hombros';
      case 'biceps':
        return 'Bíceps';
      case 'triceps':
        return 'Tríceps';
      case 'core':
        return 'Core';
      default:
        return muscle;
    }
  }

  String _exerciseTypeLabel(String type) {
    switch (type) {
      case 'strength':
        return 'Fuerza';
      case 'cardio':
        return 'Cardio';
      case 'mobility':
        return 'Movilidad';
      case 'stretching':
        return 'Estiramiento';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca de ejercicios'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadExercises,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _searchController,
            onChanged: (_) => _applyFilters(),
            decoration: InputDecoration(
              labelText: 'Buscar ejercicio',
              hintText: 'Ej. sentadilla',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
              _searchController.text.isEmpty
                  ? null
                  : IconButton(
                onPressed: () {
                  _searchController.clear();
                  _applyFilters();
                },
                icon: const Icon(Icons.clear),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _difficultyFilter,
            decoration: const InputDecoration(
              labelText: 'Nivel',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'all',
                child: Text('Todos los niveles'),
              ),
              DropdownMenuItem(
                value: 'beginner',
                child: Text('Principiante'),
              ),
              DropdownMenuItem(
                value: 'intermediate',
                child: Text('Intermedio'),
              ),
              DropdownMenuItem(
                value: 'advanced',
                child: Text('Avanzado'),
              ),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                _difficultyFilter = value;
              });

              _applyFilters();
            },
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _muscleFilter,
            decoration: const InputDecoration(
              labelText: 'Grupo muscular',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(
                value: 'all',
                child: Text('Todos los grupos'),
              ),
              ..._availableMuscles.map(
                    (muscle) => DropdownMenuItem(
                  value: muscle,
                  child: Text(_muscleLabel(muscle)),
                ),
              ),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                _muscleFilter = value;
              });

              _applyFilters();
            },
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Ejercicios',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${_filteredExercises.length}',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_filteredExercises.isEmpty)
            _buildEmptyState()
          else
            ..._filteredExercises.map(
              _buildExerciseCard,
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showExerciseDetails(exercise),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                exercise.name,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    icon: Icons.accessibility_new,
                    label: _muscleLabel(
                      exercise.primaryMuscle,
                    ),
                  ),
                  _InfoChip(
                    icon: Icons.signal_cellular_alt,
                    label: _difficultyLabel(
                      exercise.difficulty,
                    ),
                  ),
                  _InfoChip(
                    icon: Icons.category_outlined,
                    label: _exerciseTypeLabel(
                      exercise.exerciseType,
                    ),
                  ),
                ],
              ),
              if (exercise.description.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  exercise.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.touch_app_outlined,
                    size: 17,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Toca para ver detalles',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off,
            size: 48,
          ),
          SizedBox(height: 14),
          Text(
            'No encontramos ejercicios.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Prueba con otro término o cambia los filtros.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showExerciseDetails(Exercise exercise) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.78,
            minChildSize: 0.55,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  32,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _InfoChip(
                          icon: Icons.accessibility_new,
                          label: _muscleLabel(
                            exercise.primaryMuscle,
                          ),
                        ),
                        _InfoChip(
                          icon: Icons.signal_cellular_alt,
                          label: _difficultyLabel(
                            exercise.difficulty,
                          ),
                        ),
                        _InfoChip(
                          icon: Icons.category_outlined,
                          label: _exerciseTypeLabel(
                            exercise.exerciseType,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _DetailSection(
                      title: 'Descripción',
                      text: exercise.description,
                    ),
                    _DetailSection(
                      title: 'Técnica',
                      text: exercise.technique,
                    ),
                    _DetailSection(
                      title: 'Instrucciones',
                      text: exercise.instructions,
                    ),
                    _DetailSection(
                      title: 'Errores frecuentes',
                      text: exercise.commonMistakes,
                    ),
                    _DetailSection(
                      title: 'Consideraciones',
                      text: exercise.considerations,
                    ),
                    _DetailSection(
                      title: 'Patrón de movimiento',
                      text: exercise.movementPattern,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}