import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/models.dart';
import '../../../domain/trends.dart';
import '../../../domain/units.dart';
import '../../app_controller.dart';
import '../../core/widgets.dart';
import '../../navigation/top_level_scroll.dart';

class TrendsScreen extends ConsumerStatefulWidget {
  const TrendsScreen({super.key});

  @override
  ConsumerState<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends ConsumerState<TrendsScreen> with SingleTickerProviderStateMixin {
  static const TrendDataBuilder _builder = TrendDataBuilder();
  final List<ScrollController> _scrollControllers = List<ScrollController>.generate(
    3,
    (_) => ScrollController(),
  );
  late final TopLevelScrollCoordinator _scrollCoordinator;
  late final TabController _tabs;
  late final ScrollToTopCallback _scrollToTop;
  TrendRange _range = TrendRange.thirtyDays;
  DateTimeRange? _customRange;
  bool _table = false;

  @override
  void initState() {
    super.initState();
    _scrollCoordinator = ref.read(topLevelScrollCoordinatorProvider);
    _tabs = TabController(length: 3, vsync: this)..addListener(_handleTabChanged);
    _scrollToTop = () => animateTopLevelScrollToStart(context, _scrollControllers[_tabs.index]);
    _scrollCoordinator.register(TopLevelDestination.trends, _scrollToTop);
  }

  @override
  void dispose() {
    _scrollCoordinator.unregister(TopLevelDestination.trends, _scrollToTop);
    _tabs.removeListener(_handleTabChanged);
    _tabs.dispose();
    for (final controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleTabChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appControllerProvider);
    final animal = state.selectedAnimal;
    if (animal == null) {
      return const Scaffold(
        body: EmptyState(
          icon: Icons.insights_outlined,
          title: 'No trends yet',
          body: 'Add an animal and record measurements to see descriptive trends.',
        ),
      );
    }
    final compact = usesCompactVerticalLayout(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: compact ? 48 : null,
        title: const AnimalPicker(),
        actions: [
          if (_tabs.index != 2)
            IconButton(
              tooltip: _table ? 'Show chart' : 'Show accessible data table',
              onPressed: () => setState(() => _table = !_table),
              icon: Icon(_table ? Icons.show_chart_rounded : Icons.table_rows_outlined),
            ),
          const SettingsAction(),
          const SizedBox(width: 4),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            _trendTab('Breathing', Icons.air_rounded, compact),
            _trendTab('Weight', Icons.monitor_weight_outlined, compact),
            _trendTab('Medication', Icons.medication_outlined, compact),
          ],
        ),
      ),
      body: ConstrainedPage(
        padding: EdgeInsets.fromLTRB(16, compact ? 6 : 14, 16, compact ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _RangePicker(selected: _range, customRange: _customRange, onSelected: _selectRange),
            SizedBox(height: compact ? 8 : 14),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _measurementView(kind: _TrendKind.respiratory, animal: animal, state: state),
                  _measurementView(
                    kind: _TrendKind.weight,
                    animal: animal,
                    state: state,
                    scrollController: _scrollControllers[1],
                  ),
                  _medicationView(
                    animal: animal,
                    state: state,
                    scrollController: _scrollControllers[2],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Tab _trendTab(String label, IconData icon, bool compact) => compact
      ? Tab(
          height: 42,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(icon, size: 19), const SizedBox(width: 7), Text(label)],
          ),
        )
      : Tab(text: label, icon: Icon(icon));

  Widget _measurementView({
    required _TrendKind kind,
    required Animal animal,
    required CreaturelyState state,
    ScrollController? scrollController,
  }) {
    final now = DateTime.now();
    final start = _range == TrendRange.custom
        ? _customRange?.start
        : _builder.startFor(_range, now);
    final end = _range == TrendRange.custom
        ? _customRange == null
              ? now
              : DateTime(
                  _customRange!.end.year,
                  _customRange!.end.month,
                  _customRange!.end.day,
                  23,
                  59,
                  59,
                )
        : now;
    final unit = state.snapshot.settings.weightUnit == WeightUnit.kilograms ? 'kg' : 'lb';
    final points = kind == _TrendKind.respiratory
        ? _builder.respiratory(state.snapshot, animal.id, start: start, end: end)
        : _builder.weight(
            state.snapshot,
            animal.id,
            state.snapshot.settings.weightUnit,
            start: start,
            end: end,
          );
    final label = kind == _TrendKind.respiratory ? 'breaths/min' : unit;
    if (points.isEmpty) {
      return EmptyState(
        icon: kind == _TrendKind.respiratory ? Icons.air_rounded : Icons.monitor_weight_outlined,
        title: 'No ${kind == _TrendKind.respiratory ? 'breathing' : 'weight'} data in this range',
        body: 'Choose another range or record a new measurement from the Animals dashboard.',
      );
    }
    final summary = TrendSummary.fromValues(points.map((value) => value.value));
    return ListView(
      controller: scrollController ?? _scrollControllers[0],
      children: [
        _SummaryRow(summary: summary, unit: label, kind: kind),
        const SizedBox(height: 16),
        if (_table)
          _TrendTable(points: points, unit: label, kind: kind)
        else
          _TrendChart(
            points: points,
            unit: label,
            kind: kind,
            thresholds: kind == _TrendKind.respiratory ? animal.thresholds : null,
          ),
        const SizedBox(height: 14),
        Text(
          points.length < 3
              ? 'Sparse data: each saved measurement is shown; a line is not interpreted as a forecast.'
              : 'Descriptive view only: latest, average, and observed range. '
                    'No predictions or diagnosis.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _medicationView({
    required Animal animal,
    required CreaturelyState state,
    required ScrollController scrollController,
  }) {
    final now = DateTime.now();
    final start = _range == TrendRange.custom
        ? _customRange?.start
        : _builder.startFor(_range, now);
    final end = _range == TrendRange.custom
        ? _customRange == null
              ? now
              : DateTime(
                  _customRange!.end.year,
                  _customRange!.end.month,
                  _customRange!.end.day,
                  23,
                  59,
                  59,
                )
        : now;
    final doses = state.snapshot.doseLedger
        .where(
          (dose) =>
              dose.animalId == animal.id &&
              (start == null || !dose.dueAt.isBefore(start)) &&
              !dose.dueAt.isAfter(end),
        )
        .toList(growable: false);
    if (doses.isEmpty) {
      return const EmptyState(
        icon: Icons.medication_outlined,
        title: 'No medication doses in this range',
        body: 'Choose another range or add a medication schedule from the Animals dashboard.',
      );
    }
    final medicationNames = <String, String>{
      for (final medication in state.snapshot.medications)
        if (medication.animalId == animal.id) medication.id: medication.name,
    };
    final grouped = <String, List<DoseLedgerEntry>>{};
    for (final dose in doses) {
      grouped.putIfAbsent(dose.medicationId, () => <DoseLedgerEntry>[]).add(dose);
    }
    final medicationIds = grouped.keys.toList(growable: false)
      ..sort(
        (first, second) => (medicationNames[first] ?? 'Medication').compareTo(
          medicationNames[second] ?? 'Medication',
        ),
      );
    return ListView(
      controller: scrollController,
      children: [
        _MedicationSummary(doses: doses),
        const SizedBox(height: 16),
        Text('By medication', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              for (var index = 0; index < medicationIds.length; index++) ...[
                if (index > 0) const Divider(height: 1),
                _MedicationBreakdownTile(
                  name: medicationNames[medicationIds[index]] ?? 'Medication',
                  doses: grouped[medicationIds[index]]!,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Counts reflect the dose statuses recorded in this date range.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Future<void> _selectRange(TrendRange value) async {
    if (value != TrendRange.custom) {
      setState(() => _range = value);
      return;
    }
    final selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: _customRange,
    );
    if (selected != null) {
      setState(() {
        _customRange = selected;
        _range = value;
      });
    }
  }
}

enum _TrendKind { respiratory, weight }

class _MedicationSummary extends StatelessWidget {
  const _MedicationSummary({required this.doses});

  final List<DoseLedgerEntry> doses;

  @override
  Widget build(BuildContext context) {
    final metrics = <({String label, int count, IconData icon})>[
      (
        label: 'Given',
        count: doses.where((dose) => dose.status == DoseStatus.given).length,
        icon: Icons.check_circle_outline_rounded,
      ),
      (
        label: 'Skipped',
        count: doses.where((dose) => dose.status == DoseStatus.skipped).length,
        icon: Icons.fast_forward_rounded,
      ),
      (
        label: 'Missed',
        count: doses.where((dose) => dose.status == DoseStatus.missed).length,
        icon: Icons.event_busy_outlined,
      ),
      (
        label: 'Unrecorded',
        count: doses.where((dose) => dose.status == DoseStatus.unrecorded).length,
        icon: Icons.schedule_rounded,
      ),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textScale = MediaQuery.textScalerOf(context).scale(1);
            final columns = constraints.maxWidth >= 520 && textScale <= 1.4
                ? 4
                : constraints.maxWidth >= 260
                ? 2
                : 1;
            const spacing = 12.0;
            final width = (constraints.maxWidth - (columns - 1) * spacing) / columns;
            return Wrap(
              spacing: spacing,
              runSpacing: 12,
              children: [
                for (final metric in metrics)
                  SizedBox(
                    width: width,
                    child: Semantics(
                      label: '${metric.label}: ${metric.count}',
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(metric.icon, size: 21),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${metric.count}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      metric.label,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MedicationBreakdownTile extends StatelessWidget {
  const _MedicationBreakdownTile({required this.name, required this.doses});

  final String name;
  final List<DoseLedgerEntry> doses;

  @override
  Widget build(BuildContext context) {
    final given = doses.where((dose) => dose.status == DoseStatus.given).length;
    final skipped = doses.where((dose) => dose.status == DoseStatus.skipped).length;
    final missed = doses.where((dose) => dose.status == DoseStatus.missed).length;
    final unrecorded = doses.where((dose) => dose.status == DoseStatus.unrecorded).length;
    return ListTile(
      leading: const Icon(Icons.medication_outlined),
      title: Text(name),
      subtitle: Text(
        '$given given • $skipped skipped • $missed missed'
        '${unrecorded == 0 ? '' : ' • $unrecorded unrecorded'}',
      ),
    );
  }
}

class _RangePicker extends StatelessWidget {
  const _RangePicker({required this.selected, required this.customRange, required this.onSelected});

  final TrendRange selected;
  final DateTimeRange? customRange;
  final ValueChanged<TrendRange> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: SegmentedButton<TrendRange>(
      segments: [
        const ButtonSegment(value: TrendRange.sevenDays, label: Text('7D')),
        const ButtonSegment(value: TrendRange.thirtyDays, label: Text('30D')),
        const ButtonSegment(value: TrendRange.ninetyDays, label: Text('90D')),
        const ButtonSegment(value: TrendRange.oneYear, label: Text('1Y')),
        ButtonSegment(
          value: TrendRange.custom,
          label: Text(
            customRange == null
                ? 'Custom'
                : '${DateFormat.Md().format(customRange!.start)}–'
                      '${DateFormat.Md().format(customRange!.end)}',
          ),
        ),
        const ButtonSegment(value: TrendRange.allTime, label: Text('All')),
      ],
      selected: {selected},
      onSelectionChanged: (values) => onSelected(values.first),
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.summary, required this.unit, required this.kind});

  final TrendSummary summary;
  final String unit;
  final _TrendKind kind;

  @override
  Widget build(BuildContext context) {
    String measurement(double value) =>
        kind == _TrendKind.respiratory ? formatRespiratoryRate(value) : formatDisplayNumber(value);
    final values = <({String label, String value, String supporting})>[
      (label: 'Latest', value: measurement(summary.latest), supporting: unit),
      (
        label: 'Average',
        value: summary.average.toStringAsFixed(1),
        supporting: '$unit • ${summary.count} ${summary.count == 1 ? 'entry' : 'entries'}',
      ),
      (
        label: 'Observed range',
        value: '${measurement(summary.minimum)}–${measurement(summary.maximum)}',
        supporting: unit,
      ),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textScale = MediaQuery.textScalerOf(context).scale(1);
            final columns = constraints.maxWidth >= 330 && textScale <= 1.4
                ? 3
                : constraints.maxWidth >= 260
                ? 2
                : 1;
            const spacing = 12.0;
            final width = (constraints.maxWidth - (columns - 1) * spacing) / columns;
            return Wrap(
              spacing: spacing,
              runSpacing: 16,
              children: [
                for (final metric in values)
                  SizedBox(
                    width: width,
                    child: _SummaryMetric(
                      label: metric.label,
                      value: metric.value,
                      supporting: metric.supporting,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value, required this.supporting});

  final String label;
  final String value;
  final String supporting;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label $value $supporting',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 5),
        Text(
          value,
          maxLines: 1,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 1),
        Text(
          supporting,
          maxLines: 2,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    ),
  );
}

class _TrendChart extends StatelessWidget {
  const _TrendChart({
    required this.points,
    required this.unit,
    required this.kind,
    required this.thresholds,
  });

  final List<TrendPoint> points;
  final String unit;
  final _TrendKind kind;
  final RespiratoryThresholds? thresholds;

  @override
  Widget build(BuildContext context) {
    final values = points.map((value) => value.value).toList(growable: false);
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final firstLocalDate = points.first.at.toLocal();
    final singleCalendarDay = points.every(
      (point) => DateUtils.isSameDay(point.at.toLocal(), firstLocalDate),
    );
    final configured = thresholds;
    final allValues = <double>[
      ...values,
      ...<double?>[
        configured?.minimum,
        configured?.target,
        configured?.maximum,
      ].whereType<double>(),
    ];
    final scale = TrendAxisScale.fromValues(allValues);
    final labelIndexes = <int>{0, (points.length - 1) ~/ 2, points.length - 1};
    String measurement(double value) =>
        kind == _TrendKind.respiratory ? formatRespiratoryRate(value) : formatDisplayNumber(value);
    final summary =
        '${points.length} measurements. Latest ${measurement(values.last)} $unit. '
        'Observed range ${measurement(min)} to ${measurement(max)} $unit.';
    return Semantics(
      image: true,
      label: summary,
      child: ExcludeSemantics(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 22, 18, 12),
            child: SizedBox(
              height: 330,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (points.length - 1).clamp(1, 100000).toDouble(),
                  minY: scale.minimum,
                  maxY: scale.maximum,
                  gridData: FlGridData(
                    horizontalInterval: scale.interval,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: Theme.of(context).colorScheme.outlineVariant, strokeWidth: 1),
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                      bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 48,
                        interval: scale.interval,
                        getTitlesWidget: (value, meta) => SideTitleWidget(
                          meta: meta,
                          space: 6,
                          fitInside: SideTitleFitInsideData.fromTitleMeta(
                            meta,
                            distanceFromEdge: 2,
                          ),
                          child: Text(
                            formatDisplayNumber(value),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 38,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.round().clamp(0, points.length - 1);
                          if ((value - index).abs() > 0.01 || !labelIndexes.contains(index)) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            meta: meta,
                            space: 8,
                            fitInside: SideTitleFitInsideData.fromTitleMeta(
                              meta,
                              distanceFromEdge: 4,
                            ),
                            child: Text(
                              (singleCalendarDay ? DateFormat.jm() : DateFormat.Md()).format(
                                points[index].at.toLocal(),
                              ),
                              style: Theme.of(context).textTheme.labelSmall,
                              maxLines: 1,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      if (configured?.minimum != null)
                        _thresholdLine(
                          configured!.minimum!,
                          Theme.of(context).colorScheme.tertiary,
                        ),
                      if (configured?.target != null)
                        _thresholdLine(configured!.target!, Theme.of(context).colorScheme.primary),
                      if (configured?.maximum != null)
                        _thresholdLine(configured!.maximum!, Theme.of(context).colorScheme.error),
                    ],
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      maxContentWidth: 170,
                      tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      getTooltipItems: (spots) => spots
                          .map(
                            (spot) => LineTooltipItem(
                              '${measurement(points[spot.x.round()].value)} $unit\n'
                              '${DateFormat.MMMd().add_jm().format(points[spot.x.round()].at.toLocal())}',
                              TextStyle(
                                color: Theme.of(context).colorScheme.onInverseSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (var index = 0; index < points.length; index++)
                          FlSpot(index.toDouble(), points[index].value),
                      ],
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      isCurved: false,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 220),
              ),
            ),
          ),
        ),
      ),
    );
  }

  HorizontalLine _thresholdLine(double value, Color color) =>
      HorizontalLine(y: value, color: color, strokeWidth: 1.5, dashArray: <int>[6, 5]);
}

class _TrendTable extends StatelessWidget {
  const _TrendTable({required this.points, required this.unit, required this.kind});

  final List<TrendPoint> points;
  final String unit;
  final _TrendKind kind;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Accessible measurement table with ${points.length} rows',
    child: Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Date and time')),
            DataColumn(label: Text('Displayed value'), numeric: true),
            DataColumn(label: Text('Canonical/raw value')),
          ],
          rows: points
              .map(
                (point) => DataRow(
                  cells: [
                    DataCell(Text(DateFormat.yMMMd().add_jm().format(point.at.toLocal()))),
                    DataCell(
                      Text(
                        '${kind == _TrendKind.respiratory ? formatRespiratoryRate(point.value) : formatDisplayNumber(point.value)} $unit',
                      ),
                    ),
                    DataCell(Text('${point.rawValue} ${point.rawUnit}')),
                  ],
                ),
              )
              .toList(growable: false),
        ),
      ),
    ),
  );
}
