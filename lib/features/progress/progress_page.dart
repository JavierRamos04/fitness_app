import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../core/database/history_repository.dart';
import '../../core/database/providers/repository_providers.dart';
import '../../core/router/active_tab_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/number_format.dart';
import '../../core/widgets/app_components.dart';

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

  late final ValueNotifier<int> _activeTab;

  @override
  void initState() {
    super.initState();

    _activeTab = ref.read(activeTabProvider);
    _activeTab.addListener(_onActiveTabChanged);

    _loadHistory();
  }

  @override
  void dispose() {
    _activeTab.removeListener(_onActiveTabChanged);
    super.dispose();
  }

  void _onActiveTabChanged() {
    if (_activeTab.value == MainTab.progress) {
      _loadHistory();
    }
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
      return '${formatNumber(volumeKg / 1000)} t';
    }

    return '${formatNumber(volumeKg)} kg';
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy · HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu evolución',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Progreso',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
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
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const AppSectionHeader(title: 'Resumen'),
          _buildSummaryGrid(),
          const SizedBox(height: 28),
          _buildWeightSection(),
          const SizedBox(height: 28),
          AppSectionHeader(
            title: 'Historial',
            trailing: Text(
              pluralize(_totalWorkouts, 'entrenamiento', 'entrenamientos'),
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
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

    final scheme = Theme.of(context).colorScheme;

    final latest = _weightHistory.first;
    final oldest = _weightHistory.last;

    final difference = latest.weightKg - oldest.weightKg;

    final hasChange = _weightHistory.length > 1 && difference.abs() >= 0.05;

    final differenceText = !hasChange
        ? 'Primer registro'
        : difference > 0
        ? '+${formatNumber(difference)} kg desde el inicio'
        : '${formatNumber(difference)} kg desde el inicio';

    final chartEntries = _weightHistory.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(title: 'Peso'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AppIconBadge(icon: Icons.monitor_weight_outlined),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Peso actual registrado',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                formatNumber(latest.weightKg),
                                style: const TextStyle(
                                  fontFamily: AppTheme.displayFont,
                                  fontSize: 44,
                                  fontWeight: FontWeight.w700,
                                  height: 1.05,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'kg',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  differenceText,
                  style: TextStyle(
                    fontSize: 15,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                if (chartEntries.length < 2)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.show_chart,
                          size: 38,
                          color: scheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Aún no hay suficiente historial',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Registra un cambio de peso para '
                          'ver aquí tu evolución.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  )
                else ...[
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: _WeightChart(entries: chartEntries),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Inicio · '
                        '${formatNumber(chartEntries.first.weightKg)} kg',
                        style: TextStyle(
                          fontSize: 13,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Actual · '
                        '${formatNumber(chartEntries.last.weightKg)} kg',
                        style: TextStyle(
                          fontSize: 13,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Últimas mediciones',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        ..._weightHistory.take(5).map((entry) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const AppIconBadge(
                    icon: Icons.monitor_weight_outlined,
                    size: 40,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      DateFormat('dd/MM/yyyy · HH:mm').format(entry.recordedAt),
                      style: TextStyle(
                        fontSize: 15,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Text(
                    '${formatNumber(entry.weightKg)} kg',
                    style: const TextStyle(
                      fontFamily: AppTheme.displayFont,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSummaryGrid() {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: AppStatCard(
                  icon: Icons.fitness_center,
                  label: 'Entrenamientos',
                  value: '$_totalWorkouts',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppStatCard(
                  icon: Icons.repeat,
                  label: 'Series',
                  value: '$_totalSets',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: AppStatCard(
                  icon: Icons.replay,
                  label: 'Repeticiones',
                  value: '$_totalRepetitions',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppStatCard(
                  icon: Icons.scale_outlined,
                  label: 'Volumen',
                  value: _formatVolume(_totalVolumeKg),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Título de una sesión cuya rutina ya no existe: los primeros ejercicios.
  String _fallbackTitle(TrainingHistoryItem item) {
    final names = item.exerciseNames;

    if (names.isEmpty) {
      return 'Entrenamiento';
    }

    if (names.length <= 2) {
      return names.join(' · ');
    }

    return '${names.take(2).join(' · ')} +${names.length - 2}';
  }

  Widget _buildHistoryCard(TrainingHistoryItem item) {
    final scheme = Theme.of(context).colorScheme;
    final workoutName = item.workoutName ?? _fallbackTitle(item);

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
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _formatDate(item.session.startedAt),
                        style: TextStyle(
                          fontSize: 14.5,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.check_circle, color: scheme.primary),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppMetaChip(
                  icon: Icons.timer_outlined,
                  label: _formatDuration(item.session.durationSeconds),
                ),
                AppMetaChip(
                  icon: Icons.fitness_center,
                  label: pluralize(item.exerciseCount, 'ejercicio', 'ejercicios'),
                ),
                AppMetaChip(
                  icon: Icons.repeat,
                  label: pluralize(item.setCount, 'serie', 'series'),
                ),
                AppMetaChip(
                  icon: Icons.replay,
                  label: pluralize(item.totalRepetitions, 'rep.', 'reps'),
                ),
                if (item.totalVolumeKg > 0)
                  AppMetaChip(
                    icon: Icons.scale_outlined,
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
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: AppEmptyState(
          icon: Icons.insights_outlined,
          title: 'Aún no hay entrenamientos',
          message:
              'Cuando completes una sesión aparecerá aquí con su '
              'duración, series y volumen.',
        ),
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

    final lastX = entries.length == 1
        ? size.width / 2
        : leftPadding + chartWidth;
    final firstX = entries.length == 1 ? size.width / 2 : leftPadding;

    final areaPath = Path.from(path)
      ..lineTo(lastX, size.height - bottomPadding)
      ..lineTo(firstX, size.height - bottomPadding)
      ..close();

    canvas.drawPath(
      areaPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            lineColor.withValues(alpha: 0.28),
            lineColor.withValues(alpha: 0.0),
          ],
        ).createShader(Offset.zero & size),
    );

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
