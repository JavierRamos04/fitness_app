import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../core/database/history_repository.dart';
import '../../core/database/providers/repository_providers.dart';

class ProgressPage extends ConsumerStatefulWidget {
  const ProgressPage({super.key});

  @override
  ConsumerState<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends ConsumerState<ProgressPage> {
  bool _isLoading = true;
  String? _errorMessage;

  List<TrainingHistoryItem> _history = [];
  List<WeightEntry> _weightHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final userRepository = ref.read(userRepositoryProvider);

      final historyRepository = ref.read(historyRepositoryProvider);

      final weightEntryRepository = ref.read(weightEntryRepositoryProvider);

      final user = await userRepository.getUser();

      if (user == null) {
        throw StateError('No hay un usuario configurado.');
      }

      final history = await historyRepository.getCompletedForUser(user.id);

      var weightHistory = await weightEntryRepository.getAllForUser(user.id);

      if (weightHistory.isEmpty) {
        await weightEntryRepository.save(
          userId: user.id,
          recordedAt: DateTime.now(),
          weightKg: user.currentWeightKg,
        );

        weightHistory = await weightEntryRepository.getAllForUser(user.id);
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _history = history;
        _weightHistory = weightHistory;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _history = [];
        _weightHistory = [];
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
    return _history.fold(0, (total, item) => total + item.setCount);
  }

  int get _totalRepetitions {
    return _history.fold(0, (total, item) => total + item.totalRepetitions);
  }

  double get _totalVolumeKg {
    return _history.fold(0.0, (total, item) => total + item.totalVolumeKg);
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
    return DateFormat('dd/MM/yyyy · HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progreso')),
      body: _buildBody(),
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

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          _buildWeightSection(),
          const SizedBox(height: 32),

          const Text(
            'Resumen',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Tu actividad de entrenamiento registrada.',
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '$_totalWorkouts entrenamientos',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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

  Widget _buildWeightSection() {
    if (_weightHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    final latest = _weightHistory.first;
    final oldest = _weightHistory.last;

    final difference = latest.weightKg - oldest.weightKg;

    final hasChange = _weightHistory.length > 1 && difference.abs() >= 0.05;

    final differenceText = !hasChange
        ? 'Primer registro'
        : difference > 0
        ? '+${difference.toStringAsFixed(1)} kg'
        : '${difference.toStringAsFixed(1)} kg';

    final chartEntries = _weightHistory.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Peso',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Evolución de tus registros de peso.',
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  foregroundColor: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer,
                  child: const Icon(Icons.monitor_weight_outlined, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Peso actual registrado',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${latest.weightKg.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        differenceText,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Evolución',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (chartEntries.length < 2)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.show_chart,
                  size: 42,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Aún no hay suficiente historial',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  'Registra un cambio de peso para '
                  'ver aquí tu evolución.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
              child: Column(
                children: [
                  SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: _WeightChart(entries: chartEntries),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Inicio · '
                        '${chartEntries.first.weightKg.toStringAsFixed(1)} kg',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Actual · '
                        '${chartEntries.last.weightKg.toStringAsFixed(1)} kg',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 18),
        const Text(
          'Últimas mediciones',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ..._weightHistory.take(5).map((entry) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.monitor_weight_outlined),
              ),
              title: Text(
                '${entry.weightKg.toStringAsFixed(1)} kg',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyyy · HH:mm').format(entry.recordedAt),
              ),
            ),
          );
        }),
      ],
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
        _SummaryCard(icon: Icons.repeat, label: 'Series', value: '$_totalSets'),
        _SummaryCard(
          icon: Icons.replay,
          label: 'Repeticiones',
          value: '$_totalRepetitions',
        ),
        _SummaryCard(
          icon: Icons.monitor_weight_outlined,
          label: 'Volumen',
          value: _formatVolume(_totalVolumeKg),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(TrainingHistoryItem item) {
    final workoutName = item.workoutName ?? 'Rutina no disponible';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        _formatDate(item.session.startedAt),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _HistoryChip(
                  icon: Icons.timer_outlined,
                  label: _formatDuration(item.session.durationSeconds),
                ),
                _HistoryChip(
                  icon: Icons.fitness_center,
                  label: '${item.exerciseCount} ejercicios',
                ),
                _HistoryChip(
                  icon: Icons.repeat,
                  label: '${item.setCount} series',
                ),
                _HistoryChip(
                  icon: Icons.replay,
                  label: '${item.totalRepetitions} reps',
                ),
                if (item.totalVolumeKg > 0)
                  _HistoryChip(
                    icon: Icons.monitor_weight_outlined,
                    label: _formatVolume(item.totalVolumeKg),
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
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(Icons.insights_outlined, size: 48),
          SizedBox(height: 14),
          Text(
            'Todavía no hay entrenamientos completados.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
  const _HistoryChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(label)],
      ),
    );
  }
}

class _WeightChart extends StatelessWidget {
  const _WeightChart({required this.entries});

  final List<WeightEntry> entries;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomPaint(
      painter: _WeightChartPainter(
        entries: entries,
        lineColor: colorScheme.primary,
        gridColor: colorScheme.outlineVariant,
        pointColor: colorScheme.primary,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  _WeightChartPainter({
    required this.entries,
    required this.lineColor,
    required this.gridColor,
    required this.pointColor,
  });

  final List<WeightEntry> entries;
  final Color lineColor;
  final Color gridColor;
  final Color pointColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) {
      return;
    }

    const leftPadding = 12.0;
    const rightPadding = 12.0;
    const topPadding = 16.0;
    const bottomPadding = 16.0;

    final chartWidth = size.width - leftPadding - rightPadding;

    final chartHeight = size.height - topPadding - bottomPadding;

    final weights = entries.map((entry) => entry.weightKg).toList();

    var minWeight = weights.reduce((a, b) => a < b ? a : b);

    var maxWeight = weights.reduce((a, b) => a > b ? a : b);

    var range = maxWeight - minWeight;

    if (range < 1) {
      final center = (maxWeight + minWeight) / 2;

      minWeight = center - 0.5;
      maxWeight = center + 0.5;
      range = 1;
    } else {
      final padding = range * 0.15;
      minWeight -= padding;
      maxWeight += padding;
      range = maxWeight - minWeight;
    }

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    for (var index = 1; index <= 4; index++) {
      final y = topPadding + (chartHeight * index / 5);

      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );
    }

    final path = Path();

    for (var index = 0; index < entries.length; index++) {
      final entry = entries[index];

      final x = entries.length == 1
          ? size.width / 2
          : leftPadding + chartWidth * (index / (entries.length - 1));

      final normalized = (entry.weightKg - minWeight) / range;

      final y = topPadding + chartHeight * (1 - normalized);

      final point = Offset(x, y);

      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);

    final pointPaint = Paint()
      ..color = pointColor
      ..style = PaintingStyle.fill;

    for (var index = 0; index < entries.length; index++) {
      final entry = entries[index];

      final x = entries.length == 1
          ? size.width / 2
          : leftPadding + chartWidth * (index / (entries.length - 1));

      final normalized = (entry.weightKg - minWeight) / range;

      final y = topPadding + chartHeight * (1 - normalized);

      canvas.drawCircle(Offset(x, y), 5, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) {
    return oldDelegate.entries != entries ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.pointColor != pointColor;
  }
}
