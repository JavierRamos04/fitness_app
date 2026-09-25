import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/history_repository.dart';
import '../../core/database/providers/repository_providers.dart';

class ProgressPage extends ConsumerStatefulWidget {
  const ProgressPage({super.key});

  @override
  ConsumerState<ProgressPage> createState() =>
      _ProgressPageState();
}

class _ProgressPageState
    extends ConsumerState<ProgressPage> {
  bool _isLoading = true;
  String? _errorMessage;

  List<TrainingHistoryItem> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final userRepository =
      ref.read(userRepositoryProvider);

      final historyRepository =
      ref.read(historyRepositoryProvider);

      final user = await userRepository.getUser();

      if (user == null) {
        throw StateError(
          'No hay un usuario configurado.',
        );
      }

      final history =
      await historyRepository.getCompletedForUser(
        user.id,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _history = history;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _history = [];
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _refresh() async {
    await _loadHistory();
  }

  int get _totalWorkouts {
    return _history.length;
  }

  int get _totalSets {
    return _history.fold(
      0,
          (total, item) => total + item.setCount,
    );
  }

  int get _totalRepetitions {
    return _history.fold(
      0,
          (total, item) =>
      total + item.totalRepetitions,
    );
  }

  double get _totalVolumeKg {
    return _history.fold(
      0.0,
          (total, item) =>
      total + item.totalVolumeKg,
    );
  }

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) {
      return 'Duración no disponible';
    }

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    if (minutes == 0) {
      return '${remainingSeconds}s';
    }

    return '$minutes min ${remainingSeconds}s';
  }

  String _formatVolume(double volumeKg) {
    if (volumeKg <= 0) {
      return '—';
    }

    if (volumeKg >= 1000) {
      return '${(volumeKg / 1000).toStringAsFixed(1)} t';
    }

    return '${volumeKg.toStringAsFixed(1)} kg';
  }

  String _formatDate(DateTime date) {
    return DateFormat(
      'dd/MM/yyyy · HH:mm',
    ).format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progreso'),
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
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Resumen',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tu actividad de entrenamiento registrada.',
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          _buildSummaryGrid(),
          const SizedBox(height: 32),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Historial',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '$_totalWorkouts entrenamientos',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (_history.isEmpty)
            _buildEmptyState()
          else
            ..._history.map(_buildHistoryCard),
        ],
      ),
    );
  }

  Widget _buildSummaryGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.30,
      children: [
        _SummaryCard(
          icon: Icons.fitness_center,
          label: 'Entrenamientos',
          value: '$_totalWorkouts',
        ),
        _SummaryCard(
          icon: Icons.repeat,
          label: 'Series',
          value: '$_totalSets',
        ),
        _SummaryCard(
          icon: Icons.replay,
          label: 'Repeticiones',
          value: '$_totalRepetitions',
        ),
        _SummaryCard(
          icon: Icons.monitor_weight_outlined,
          label: 'Volumen',
          value: _formatVolume(
            _totalVolumeKg,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(
      TrainingHistoryItem item,
      ) {
    final workoutName =
        item.workoutName ?? 'Rutina no disponible';

    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        workoutName,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _formatDate(
                          item.session.startedAt,
                        ),
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _HistoryChip(
                  icon: Icons.timer_outlined,
                  label: _formatDuration(
                    item.session.durationSeconds,
                  ),
                ),
                _HistoryChip(
                  icon: Icons.fitness_center,
                  label:
                  '${item.exerciseCount} ejercicios',
                ),
                _HistoryChip(
                  icon: Icons.repeat,
                  label:
                  '${item.setCount} series',
                ),
                _HistoryChip(
                  icon: Icons.replay,
                  label:
                  '${item.totalRepetitions} reps',
                ),
                if (item.totalVolumeKg > 0)
                  _HistoryChip(
                    icon: Icons.monitor_weight_outlined,
                    label: _formatVolume(
                      item.totalVolumeKg,
                    ),
                  ),
              ],
            ),
          ],
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
            Icons.insights_outlined,
            size: 48,
          ),
          SizedBox(height: 14),
          Text(
            'Todavía no hay entrenamientos completados.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Cuando completes una sesión aparecerá aquí.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon),
            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
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
    );
  }
}

class _HistoryChip extends StatelessWidget {
  const _HistoryChip({
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