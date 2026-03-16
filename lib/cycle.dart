import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_textstyles.dart';
import 'routes.dart';

// ══════════════════════════════════════════════════════════════════════════════
// ── CycleCalendarScreen ───────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class CycleCalendarScreen extends StatefulWidget {
  const CycleCalendarScreen({super.key});
  @override
  State<CycleCalendarScreen> createState() => _CycleCalendarScreenState();
}

class _CycleCalendarScreenState extends State<CycleCalendarScreen> {
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  final List<(DateTime, DateTime)> _periodRanges = [
    (DateTime(2026, 2, 10), DateTime(2026, 2, 15)),
    (DateTime(2026, 1, 12), DateTime(2026, 1, 17)),
    (DateTime(2025, 12, 14), DateTime(2025, 12, 19)),
    (DateTime(2025, 11, 15), DateTime(2025, 11, 20)),
  ];

  int get _avgCycleLength {
    if (_periodRanges.length < 2) return 28;
    final lengths = <int>[];
    for (int i = 0; i < _periodRanges.length - 1; i++) {
      final gap = _periodRanges[i]
          .$1
          .difference(_periodRanges[i + 1].$1)
          .inDays
          .abs();
      lengths.add(gap);
    }
    return (lengths.reduce((a, b) => a + b) / lengths.length).round();
  }

  int get _avgPeriodLength {
    if (_periodRanges.isEmpty) return 6;
    final lengths = _periodRanges
        .map((r) => r.$2.difference(r.$1).inDays + 1)
        .toList();
    return (lengths.reduce((a, b) => a + b) / lengths.length).round();
  }

  DateTime get _nextPeriodStart {
    final last = _periodRanges.first.$1;
    return last.add(Duration(days: _avgCycleLength));
  }

  DateTime get _nextPeriodEnd =>
      _nextPeriodStart.add(Duration(days: _avgPeriodLength - 1));

  DateTime get _fertileStart =>
      _nextPeriodStart.subtract(const Duration(days: 16));
  DateTime get _fertileEnd =>
      _nextPeriodStart.subtract(const Duration(days: 12));

  DateTime get _ovulationDay =>
      _nextPeriodStart.subtract(const Duration(days: 14));

  int get _nCycles => _periodRanges.length;
  int get _meanCycleLength => _avgCycleLength;

  double get _meanMensesLen {
    if (_periodRanges.isEmpty) return 0;
    final lengths = _periodRanges
        .map((r) => r.$2.difference(r.$1).inDays + 1)
        .toList();
    return lengths.reduce((a, b) => a + b) / lengths.length;
  }

  int get _lutealPhaseLength => _avgCycleLength - 14;
  int get _meanFertilityDays => 5;

  double? get _clv {
    if (_periodRanges.length < 3) return null;
    final lengths = <int>[];
    for (int i = 0; i < _periodRanges.length - 1; i++) {
      final cycleLen = _periodRanges[i]
          .$1
          .difference(_periodRanges[i + 1].$1)
          .inDays
          .abs();
      lengths.add(cycleLen);
    }
    final mean = lengths.reduce((a, b) => a + b) / lengths.length;
    final variance =
        lengths.map((l) => (l - mean) * (l - mean)).reduce((a, b) => a + b) /
            lengths.length;
    return variance > 0 ? variance.abs().toDouble() : 0.0;
  }

  bool _isPeriodDay(DateTime d) {
    for (final r in _periodRanges) {
      if (!d.isBefore(r.$1) && !d.isAfter(r.$2)) return true;
    }
    if (!d.isBefore(_nextPeriodStart) && !d.isAfter(_nextPeriodEnd)) {
      return true;
    }
    return false;
  }

  bool _isPredictedPeriod(DateTime d) =>
      !d.isBefore(_nextPeriodStart) && !d.isAfter(_nextPeriodEnd);

  bool _isFertile(DateTime d) =>
      !d.isBefore(_fertileStart) && !d.isAfter(_fertileEnd);

  bool _isOvulation(DateTime d) =>
      d.year == _ovulationDay.year &&
      d.month == _ovulationDay.month &&
      d.day == _ovulationDay.day;

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  List<DateTime?> _buildGrid() {
    final first = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    final leadingBlanks = (first.weekday - 1) % 7;
    final cells = <DateTime?>[];
    for (int i = 0; i < leadingBlanks; i++) cells.add(null);
    for (int d = 1; d <= daysInMonth; d++) {
      cells.add(DateTime(_focusedMonth.year, _focusedMonth.month, d));
    }
    while (cells.length % 7 != 0) cells.add(null);
    return cells;
  }

  void _prevMonth() => setState(() {
        _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
      });

  void _nextMonth() => setState(() {
        _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
      });

  String _monthLabel() {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[_focusedMonth.month - 1]} ${_focusedMonth.year}';
  }

  int get _daysUntilNext =>
      _nextPeriodStart.difference(DateTime.now()).inDays;

  Future<void> _openLogPeriod() async {
    final result = await Navigator.push<(DateTime, DateTime)?>(
      context,
      MaterialPageRoute(
        builder: (_) => PeriodLogScreen(
          previousPeriodStartDate: _periodRanges.isNotEmpty
              ? _periodRanges.first.$1
              : null,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _periodRanges.insert(0, result);
        _periodRanges.sort((a, b) => b.$1.compareTo(a.$1));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final grid = _buildGrid();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        // ── Teal gradient header ──────────────────────────────────────────
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2E8B9A), Color(0xFF1A6B7A)],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 20, 20),
              child: Column(children: [
                Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text('Cycle Calendar',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                  GestureDetector(
                    onTap: _openLogPeriod,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Row(children: [
                        Icon(Icons.add, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text('Log Period',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ),
                ]),
                const SizedBox(height: 18),
                Row(children: [
                  _HeaderPill(
                    label: 'Next Period',
                    value: _daysUntilNext <= 0
                        ? 'Due now'
                        : 'In $_daysUntilNext days',
                    icon: Icons.circle,
                    iconColor: const Color(0xFFFF6B6B),
                  ),
                  const SizedBox(width: 10),
                  _HeaderPill(
                    label: 'Avg Cycle',
                    value: '$_meanCycleLength days',
                    icon: Icons.loop,
                    iconColor: Colors.white70,
                  ),
                  const SizedBox(width: 10),
                  _HeaderPill(
                    label: 'Cycles Logged',
                    value: '$_nCycles',
                    icon: Icons.bar_chart,
                    iconColor: Colors.white70,
                  ),
                ]),
              ]),
            ),
          ),
        ),

        // ── Scrollable body ───────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(children: [

              // ── Calendar card ──────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder)),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 8, 6),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Text(_monthLabel(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      Row(children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left,
                              size: 20, color: AppColors.textMedium),
                          onPressed: _prevMonth,
                          visualDensity: VisualDensity.compact,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right,
                              size: 20, color: AppColors.textMedium),
                          onPressed: _nextMonth,
                          visualDensity: VisualDensity.compact,
                        ),
                      ]),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                          .map((d) => Expanded(
                                child: Center(
                                  child: Text(d,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textMedium)),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 2,
                        childAspectRatio: 1,
                      ),
                      itemCount: grid.length,
                      itemBuilder: (_, i) {
                        final d = grid[i];
                        if (d == null) return const SizedBox();
                        return _CalendarCell(
                          date: d,
                          isPeriod: _isPeriodDay(d),
                          isPredicted: _isPredictedPeriod(d),
                          isFertile: _isFertile(d),
                          isOvulation: _isOvulation(d),
                          isToday: _isToday(d),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: Wrap(spacing: 12, runSpacing: 8, children: const [
                      _LegendDot(color: Color(0xFFFF6B6B), label: 'Period'),
                      _LegendDot(
                          color: Color(0xFFFFB347),
                          label: 'Predicted',
                          dashed: true),
                      _LegendDot(color: Color(0xFF4CAF9A), label: 'Fertile'),
                      _LegendDot(color: Color(0xFF9C27B0), label: 'Ovulation'),
                    ]),
                  ),
                ]),
              ),

              const SizedBox(height: 16),

              // ── Cycle Analytics card ────────────────────────────────────
              _SectionCard(
                title: 'Cycle Summary',
                children: [
                  Row(children: [
                    Expanded(
                        child: _StatBox(
                            label: 'Avg Cycle',
                            value: '$_avgCycleLength',
                            unit: 'days',
                            color: AppColors.primary)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _StatBox(
                            label: 'Avg Period',
                            value: _meanMensesLen.toStringAsFixed(1),
                            unit: 'days',
                            color: const Color(0xFFFF6B6B))),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _StatBox(
                            label: 'Cycles Logged',
                            value: '$_nCycles',
                            unit: 'total',
                            color: const Color(0xFF9C27B0))),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                        child: _StatBox(
                            label: 'Fertile Days',
                            value: '$_meanFertilityDays',
                            unit: 'days',
                            color: const Color(0xFF4CAF9A))),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _StatBox(
                            label: 'Luteal Phase',
                            value: '$_lutealPhaseLength',
                            unit: 'days',
                            color: const Color(0xFF3A7BD5))),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _StatBox(
                            label: 'Variability',
                            value: _nCycles >= 3
                                ? (_clv ?? 0).toStringAsFixed(1)
                                : '—',
                            unit: _nCycles >= 3 ? 'SD' : 'need 3+',
                            color: const Color(0xFFF5A623))),
                  ]),
                  if (_nCycles < 3) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.15)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.info_outline,
                            size: 14, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Log ${3 - _nCycles} more cycle${3 - _nCycles > 1 ? 's' : ''} to unlock Cycle Variability',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMedium),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 16),

              // ── Upcoming events card ────────────────────────────────────
              _SectionCard(
                title: 'Upcoming',
                children: [
                  _EventRow(
                    color: const Color(0xFFFFB347),
                    icon: Icons.water_drop_outlined,
                    title: 'Next Period',
                    subtitle: _formatRange(_nextPeriodStart, _nextPeriodEnd),
                    tag: _daysUntilNext <= 0
                        ? 'Due now'
                        : 'In $_daysUntilNext days',
                    tagColor: const Color(0xFFFFB347),
                  ),
                  const Divider(height: 20, color: Color(0xFFF2F4F7)),
                  _EventRow(
                    color: const Color(0xFF4CAF9A),
                    icon: Icons.favorite_border,
                    title: 'Fertile Window',
                    subtitle: _formatRange(_fertileStart, _fertileEnd),
                    tag: '$_meanFertilityDays days',
                    tagColor: const Color(0xFF4CAF9A),
                  ),
                  const Divider(height: 20, color: Color(0xFFF2F4F7)),
                  _EventRow(
                    color: const Color(0xFF9C27B0),
                    icon: Icons.stars_outlined,
                    title: 'Ovulation',
                    subtitle: _formatSingle(_ovulationDay),
                    tag: 'Peak',
                    tagColor: const Color(0xFF9C27B0),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Past periods list ───────────────────────────────────────
              _SectionCard(
                title: 'Past Periods',
                children: [
                  if (_periodRanges.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No periods logged yet. Tap "Log Period" to get started.',
                        style: TextStyle(
                            fontSize: 13, color: AppColors.textMedium),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ..._periodRanges.map((r) {
                      final length = r.$2.difference(r.$1).inDays + 1;
                      return Column(children: [
                        _PastPeriodRow(
                            start: r.$1, end: r.$2, length: length),
                        if (r != _periodRanges.last)
                          const Divider(height: 20, color: Color(0xFFF2F4F7)),
                      ]);
                    }),
                ],
              ),

              const SizedBox(height: 8),
            ]),
          ),
        ),

        // ── Bottom nav ────────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              border: Border(top: BorderSide(color: AppColors.cardBorder))),
          child: Row(children: [
            _NavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.dashboard, (r) => false)),
            _NavItem(
                icon: Icons.calendar_month_outlined,
                label: 'Cycle',
                active: true,
                onTap: () {}),
            _NavItem(
                icon: Icons.bar_chart_outlined,
                label: 'Results',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.riskScore)),
            _NavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.profile)),
          ]),
        ),
      ]),
    );
  }

  String _formatRange(DateTime s, DateTime e) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[s.month - 1]} ${s.day} – ${months[e.month - 1]} ${e.day}';
  }

  String _formatSingle(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── PeriodLogScreen ───────────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class PeriodLogScreen extends StatefulWidget {
  final DateTime? previousPeriodStartDate;

  const PeriodLogScreen({super.key, this.previousPeriodStartDate});
  @override
  State<PeriodLogScreen> createState() => _PeriodLogScreenState();
}

class _PeriodLogScreenState extends State<PeriodLogScreen> {
  int _step = 0;

  DateTime? _startDate;
  DateTime? _endDate;

  final Map<DateTime, int> _intensity = {};
  bool _unusualBleeding = false;
  String? _unusualBleedingDesc;
  String? _cycleRegularity;

  List<DateTime> get _days {
    if (_startDate == null || _endDate == null) return [];
    final list = <DateTime>[];
    var d = _startDate!;
    while (!d.isAfter(_endDate!)) {
      list.add(d);
      d = d.add(const Duration(days: 1));
    }
    return list;
  }

  int get _lengthOfMenses =>
      _startDate != null && _endDate != null
          ? _endDate!.difference(_startDate!).inDays + 1
          : 0;

  double get _totalMensesScore {
    if (_intensity.isEmpty) return 0;
    return _intensity.values.reduce((a, b) => a + b) / _intensity.length;
  }

  int? get _lengthOfCycle {
    if (widget.previousPeriodStartDate == null || _startDate == null) return null;
    return _startDate!
        .difference(widget.previousPeriodStartDate!)
        .inDays
        .abs();
  }

  int? get _lutealPhaseLength {
    final loc = _lengthOfCycle;
    if (loc == null) return null;
    return loc - 14;
  }

  int get _totalDaysOfFertility => 5;

  bool get _canContinueStep0 => _startDate != null && _endDate != null;

  Future<void> _pickDate(bool isStart) async {
    final now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime initialDate;
    if (isStart) {
      initialDate = _startDate ?? now;
    } else {
      final candidate =
          _endDate ?? (_startDate ?? now).add(const Duration(days: 5));
      initialDate = candidate.isAfter(now) ? now : candidate;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(picked)) _endDate = null;
      } else {
        _endDate = picked;
      }
      for (final d in _days) {
        _intensity.putIfAbsent(d, () => 2);
      }
    });
  }

  String _fmtLong(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final suffix = _daySuffix(d.day);
    return '${months[d.month - 1]} ${d.day}$suffix, ${d.year}';
  }

  String _fmtShort(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  String _fmtDayHeader(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final wd = days[(d.weekday - 1) % 7];
    return '$wd, ${months[d.month - 1]} ${d.day}';
  }

  String _daySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        _PLHeader(),
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 8),
          child: _PLStepper(current: _step),
        ),
        Expanded(
          child: _step == 0
              ? _PLStep0(
                  startDate: _startDate,
                  endDate: _endDate,
                  onPickStart: () => _pickDate(true),
                  onPickEnd: () => _pickDate(false),
                  canContinue: _canContinueStep0,
                  onContinue: () {
                    for (final d in _days) {
                      _intensity.putIfAbsent(d, () => 2);
                    }
                    setState(() => _step = 1);
                  },
                  fmtLong: _fmtLong,
                  lengthOfCycle: _lengthOfCycle,
                )
              : _step == 1
                  ? _PLStep1(
                      days: _days,
                      intensity: _intensity,
                      unusualBleeding: _unusualBleeding,
                      unusualBleedingDesc: _unusualBleedingDesc,
                      cycleRegularity: _cycleRegularity,
                      onChanged: (d, v) =>
                          setState(() => _intensity[d] = v),
                      onUnusualBleedingChanged: (v) =>
                          setState(() => _unusualBleeding = v),
                      onUnusualDescChanged: (v) =>
                          setState(() => _unusualBleedingDesc = v),
                      onCycleRegularityChanged: (v) =>
                          setState(() => _cycleRegularity = v),
                      onBack: () => setState(() => _step = 0),
                      onReview: () => setState(() => _step = 2),
                      fmtDayHeader: _fmtDayHeader,
                    )
                  : _PLStep2(
                      startDate: _startDate!,
                      endDate: _endDate!,
                      days: _days,
                      intensity: _intensity,
                      unusualBleeding: _unusualBleeding,
                      unusualBleedingDesc: _unusualBleedingDesc,
                      cycleRegularity: _cycleRegularity,
                      lengthOfMenses: _lengthOfMenses,
                      totalMensesScore: _totalMensesScore,
                      lengthOfCycle: _lengthOfCycle,
                      lutealPhaseLength: _lutealPhaseLength,
                      totalDaysOfFertility: _totalDaysOfFertility,
                      onBack: () => setState(() => _step = 1),
                      onSave: () => Navigator.pop(
                          context, (_startDate!, _endDate!)),
                      fmtShort: _fmtShort,
                      fmtDayHeader: _fmtDayHeader,
                    ),
        ),
      ]),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────
class _PLHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2E8B9A), Color(0xFF1A6B7A)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                Text('Log Period',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                SizedBox(height: 2),
                Text('Track your menstrual cycle',
                    style: TextStyle(fontSize: 13, color: Colors.white70)),
              ]),
            ]),
          ),
        ),
      );
}

// ── Stepper ───────────────────────────────────────────────────────────────────
class _PLStepper extends StatelessWidget {
  final int current;
  const _PLStepper({required this.current});
  @override
  Widget build(BuildContext context) => Row(
        children: List.generate(5, (i) {
          if (i.isOdd) {
            final lineIndex = i ~/ 2;
            final active = current > lineIndex;
            return Expanded(
              child: Container(
                  height: 1.5,
                  color: active
                      ? AppColors.primary
                      : const Color(0xFFD0D5DD)),
            );
          }
          final step = i ~/ 2;
          final done = current > step;
          final active = current == step;
          return _PLStepCircle(step: step + 1, done: done, active: active);
        }),
      );
}

class _PLStepCircle extends StatelessWidget {
  final int step;
  final bool done, active;
  const _PLStepCircle(
      {required this.step, required this.done, required this.active});
  @override
  Widget build(BuildContext context) {
    final bg =
        (done || active) ? AppColors.primary : const Color(0xFFE4E7EC);
    final fg =
        (done || active) ? Colors.white : const Color(0xFF98A2B3);
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Center(
        child: done
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : Text('$step',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: fg)),
      ),
    );
  }
}

// ── Step 0: Period Dates ──────────────────────────────────────────────────────
class _PLStep0 extends StatelessWidget {
  final DateTime? startDate, endDate;
  final VoidCallback onPickStart, onPickEnd, onContinue;
  final bool canContinue;
  final String Function(DateTime) fmtLong;
  final int? lengthOfCycle;

  const _PLStep0({
    required this.startDate,
    required this.endDate,
    required this.onPickStart,
    required this.onPickEnd,
    required this.canContinue,
    required this.onContinue,
    required this.fmtLong,
    required this.lengthOfCycle,
  });

  @override
  Widget build(BuildContext context) => Column(children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Text('Period Dates',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828))),
              const SizedBox(height: 4),
              const Text('Select when your period started and ended.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF667085))),
              const SizedBox(height: 28),
              _PLDateCard(
                label: 'Start Date',
                placeholder: 'Select start date',
                value: startDate != null ? fmtLong(startDate!) : null,
                onTap: onPickStart,
              ),
              const SizedBox(height: 16),
              _PLDateCard(
                label: 'End Date',
                placeholder: 'Select end date',
                value: endDate != null ? fmtLong(endDate!) : null,
                onTap: onPickEnd,
              ),
              if (startDate != null && endDate != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.straighten,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Period length: ${endDate!.difference(startDate!).inDays + 1} days',
                            style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textMedium),
                          ),
                        ),
                      ]),
                      if (lengthOfCycle != null) ...[
                        const SizedBox(height: 8),
                        Row(children: [
                          const Icon(Icons.loop,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Cycle length: $lengthOfCycle days since last period',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textMedium),
                            ),
                          ),
                        ]),
                      ],
                    ],
                  ),
                ),
              ],
            ]),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              24, 8, 24, MediaQuery.of(context).padding.bottom + 20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canContinue ? onContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor:
                    AppColors.primary.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Continue',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ]);
}

class _PLDateCard extends StatelessWidget {
  final String label, placeholder;
  final String? value;
  final VoidCallback onTap;
  const _PLDateCard(
      {required this.label,
      required this.placeholder,
      required this.value,
      required this.onTap});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE4E7EC))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF344054))),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD0D5DD))),
              child: Row(children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 16, color: Color(0xFF667085)),
                const SizedBox(width: 10),
                Text(value ?? placeholder,
                    style: TextStyle(
                        fontSize: 14,
                        color: value != null
                            ? const Color(0xFF101828)
                            : const Color(0xFF98A2B3))),
              ]),
            ),
          ),
        ]),
      );
}

// ── Step 1: Bleeding Intensity + Cycle Regularity + Unusual Bleeding ──────────
class _PLStep1 extends StatelessWidget {
  final List<DateTime> days;
  final Map<DateTime, int> intensity;
  final bool unusualBleeding;
  final String? unusualBleedingDesc;
  final String? cycleRegularity;
  final void Function(DateTime, int) onChanged;
  final ValueChanged<bool> onUnusualBleedingChanged;
  final ValueChanged<String> onUnusualDescChanged;
  final ValueChanged<String?> onCycleRegularityChanged;
  final VoidCallback onBack, onReview;
  final String Function(DateTime) fmtDayHeader;

  const _PLStep1({
    required this.days,
    required this.intensity,
    required this.unusualBleeding,
    required this.unusualBleedingDesc,
    required this.cycleRegularity,
    required this.onChanged,
    required this.onUnusualBleedingChanged,
    required this.onUnusualDescChanged,
    required this.onCycleRegularityChanged,
    required this.onBack,
    required this.onReview,
    required this.fmtDayHeader,
  });

  static const _labels = ['Spotting', 'Light', 'Medium', 'Heavy'];

  String _dropIcons(int level) {
    switch (level) {
      case 0: return '◎';
      case 1: return '◎◎';
      case 2: return '◎◎◎';
      case 3: return '◎◎◎◎';
      default: return '◎';
    }
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Text('Bleeding & Cycle Details',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828))),
              const SizedBox(height: 4),
              const Text('Rate your flow and tell us about your cycle.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF667085))),
              const SizedBox(height: 20),

              // ── Cycle regularity ───────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cycleRegularity != null
                      ? AppColors.primary.withOpacity(0.03)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: cycleRegularity != null
                        ? AppColors.primary.withOpacity(0.35)
                        : const Color(0xFFE4E7EC),
                    width: cycleRegularity != null ? 1.5 : 1,
                  ),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text('Are your periods regular or irregular?',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828))),
                  const SizedBox(height: 4),
                  const Text(
                      'Regular means your period comes around the same time each month.',
                      style: TextStyle(
                          fontSize: 13, color: Color(0xFF667085))),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(child: _RegularityOption(
                      label: 'Regular',
                      selected: cycleRegularity == 'Regular',
                      onTap: () => onCycleRegularityChanged('Regular'),
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: _RegularityOption(
                      label: 'Irregular',
                      selected: cycleRegularity == 'Irregular',
                      onTap: () => onCycleRegularityChanged('Irregular'),
                    )),
                  ]),
                ]),
              ),

              const SizedBox(height: 16),

              // ── Daily bleeding intensity ───────────────────────────────
              const Text('Bleeding Intensity',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF101828))),
              const SizedBox(height: 4),
              const Text('Set the flow for each day of your period.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF667085))),
              const SizedBox(height: 12),

              ...days.map((d) {
                final sel = intensity[d] ?? 2;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: const Color(0xFFE4E7EC))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(fmtDayHeader(d),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF101828))),
                    const SizedBox(height: 12),
                    Row(
                        children: List.generate(4, (i) {
                      final active = sel == i;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => onChanged(d, i),
                          child: Container(
                            margin:
                                EdgeInsets.only(right: i < 3 ? 8 : 0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10),
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primary.withOpacity(0.08)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: active
                                    ? AppColors.primary
                                    : const Color(0xFFE4E7EC),
                                width: active ? 1.5 : 1,
                              ),
                            ),
                            child: Column(children: [
                              Text(_dropIcons(i),
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: active
                                          ? AppColors.primary
                                          : const Color(0xFFE57373))),
                              const SizedBox(height: 4),
                              Text(_labels[i],
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: active
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: active
                                          ? AppColors.primary
                                          : const Color(0xFF667085))),
                            ]),
                          ),
                        ),
                      );
                    })),
                  ]),
                );
              }),

              const SizedBox(height: 8),

              // ── Unusual Bleeding ───────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: unusualBleeding
                        ? AppColors.riskHigh.withOpacity(0.3)
                        : const Color(0xFFE4E7EC),
                    width: unusualBleeding ? 1.5 : 1,
                  ),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.riskHigh.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.warning_amber_outlined,
                          color: AppColors.riskHigh, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                        Text('Any unusual bleeding?',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF101828))),
                        SizedBox(height: 2),
                        Text(
                            'Bleeding outside your normal period window',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF667085))),
                      ]),
                    ),
                    Switch(
                      value: unusualBleeding,
                      onChanged: onUnusualBleedingChanged,
                      activeColor: AppColors.riskHigh,
                    ),
                  ]),
                  if (unusualBleeding) ...[
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Color(0xFFF2F4F7)),
                    const SizedBox(height: 12),
                    const Text('What best describes it? (optional)',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF344054))),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Spotting mid-cycle',
                        'After intercourse',
                        'Post-exercise',
                        'Between periods',
                        'Heavier than usual',
                      ].map((tag) {
                        final selected = unusualBleedingDesc == tag;
                        return GestureDetector(
                          onTap: () => onUnusualDescChanged(tag),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.riskHigh.withOpacity(0.08)
                                  : const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? AppColors.riskHigh
                                    : const Color(0xFFE4E7EC),
                                width: selected ? 1.5 : 1,
                              ),
                            ),
                            child: Text(tag,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: selected
                                      ? AppColors.riskHigh
                                      : const Color(0xFF344054),
                                )),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ]),
              ),
            ]),
          ),
        ),
        _PLTwoButtons(
            leftLabel: 'Back',
            rightLabel: 'Review',
            onLeft: onBack,
            onRight: onReview),
      ]);
}

// ── Simple regularity option button ───────────────────────────────────────────
class _RegularityOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RegularityOption(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withOpacity(0.08)
                : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  selected ? AppColors.primary : const Color(0xFFE4E7EC),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? AppColors.primary
                        : const Color(0xFF344054))),
          ),
        ),
      );
}

// ── Step 2: Review & Save ─────────────────────────────────────────────────────
class _PLStep2 extends StatelessWidget {
  final DateTime startDate, endDate;
  final List<DateTime> days;
  final Map<DateTime, int> intensity;
  final bool unusualBleeding;
  final String? unusualBleedingDesc;
  final String? cycleRegularity;
  final int lengthOfMenses;
  final double totalMensesScore;
  final int? lengthOfCycle;
  final int? lutealPhaseLength;
  final int totalDaysOfFertility;
  final VoidCallback onBack, onSave;
  final String Function(DateTime) fmtShort;
  final String Function(DateTime) fmtDayHeader;

  const _PLStep2({
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.intensity,
    required this.unusualBleeding,
    required this.unusualBleedingDesc,
    required this.cycleRegularity,
    required this.lengthOfMenses,
    required this.totalMensesScore,
    required this.lengthOfCycle,
    required this.lutealPhaseLength,
    required this.totalDaysOfFertility,
    required this.onBack,
    required this.onSave,
    required this.fmtShort,
    required this.fmtDayHeader,
  });

  static const _labels = ['Spotting', 'Light', 'Medium', 'Heavy'];

  String _dropStr(int level) {
    switch (level) {
      case 0: return '◎';
      case 1: return '◎ ◎';
      case 2: return '◎ ◎ ◎';
      case 3: return '◎ ◎ ◎ ◎';
      default: return '◎ ◎ ◎';
    }
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Text('Review & Save',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828))),
              const SizedBox(height: 4),
              const Text('Check your details before saving.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF667085))),
              const SizedBox(height: 24),

              // ── Summary card ───────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE4E7EC))),
                child: Column(children: [
                  _PLReviewRow(
                      label: 'Period length',
                      value: '$lengthOfMenses days',
                      bold: true),
                  const Divider(height: 20, color: Color(0xFFF2F4F7)),
                  _PLReviewRow(
                      label: 'Start date',
                      value: fmtShort(startDate),
                      bold: true),
                  const Divider(height: 20, color: Color(0xFFF2F4F7)),
                  _PLReviewRow(
                      label: 'End date',
                      value: fmtShort(endDate),
                      bold: true),
                  const Divider(height: 20, color: Color(0xFFF2F4F7)),
                  _PLReviewRow(
                      label: 'Average flow',
                      value: _flowLabel(totalMensesScore),
                      bold: true),
                  if (lengthOfCycle != null) ...[
                    const Divider(height: 20, color: Color(0xFFF2F4F7)),
                    _PLReviewRow(
                        label: 'Days since last period',
                        value: '$lengthOfCycle days',
                        bold: true),
                  ],
                  const Divider(height: 20, color: Color(0xFFF2F4F7)),
                  _PLReviewRow(
                      label: 'Cycle regularity',
                      value: cycleRegularity ?? 'Not set',
                      bold: true,
                      valueColor: cycleRegularity == null
                          ? AppColors.textLight
                          : cycleRegularity == 'Regular'
                              ? AppColors.riskLow
                              : AppColors.riskHigh),
                  const Divider(height: 20, color: Color(0xFFF2F4F7)),
                  _PLReviewRow(
                      label: 'Unusual bleeding',
                      value: unusualBleeding ? 'Yes' : 'No',
                      bold: true,
                      valueColor:
                          unusualBleeding ? AppColors.riskHigh : null),
                ]),
              ),

              if (unusualBleeding && unusualBleedingDesc != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.riskHigh.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.riskHigh.withOpacity(0.2)),
                  ),
                  child: Row(children: [
                    Icon(Icons.warning_amber_outlined,
                        size: 14, color: AppColors.riskHigh),
                    const SizedBox(width: 8),
                    Text(unusualBleedingDesc!,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppColors.riskHigh,
                            fontWeight: FontWeight.w500)),
                  ]),
                ),
              ],

              const SizedBox(height: 16),

              // ── Daily flow breakdown ───────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE4E7EC))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text('Daily Flow',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828))),
                  const SizedBox(height: 14),
                  ...days.map((d) {
                    final lvl = intensity[d] ?? 2;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                        Text(fmtDayHeader(d),
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF667085))),
                        Row(children: [
                          Text(_dropStr(lvl),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFE57373))),
                          const SizedBox(width: 6),
                          Text(_labels[lvl],
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF101828))),
                        ]),
                      ]),
                    );
                  }),
                ]),
              ),
            ]),
          ),
        ),
        _PLTwoButtons(
            leftLabel: 'Back',
            rightLabel: 'Save Period',
            onLeft: onBack,
            onRight: onSave),
      ]);

  // Convert numeric score to a readable label for patients
  String _flowLabel(double score) {
    if (score < 0.5) return 'Spotting';
    if (score < 1.5) return 'Light';
    if (score < 2.5) return 'Medium';
    return 'Heavy';
  }
}

class _PLReviewRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  final Color? valueColor;
  const _PLReviewRow(
      {required this.label,
      required this.value,
      this.bold = false,
      this.valueColor});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF667085))),
          ),
          const SizedBox(width: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                  color: valueColor ?? const Color(0xFF101828))),
        ],
      );
}

class _PLTwoButtons extends StatelessWidget {
  final String leftLabel, rightLabel;
  final VoidCallback onLeft, onRight;
  const _PLTwoButtons(
      {required this.leftLabel,
      required this.rightLabel,
      required this.onLeft,
      required this.onRight});
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16,
            MediaQuery.of(context).padding.bottom + 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF2F4F7))),
        ),
        child: Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onLeft,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                side: const BorderSide(color: Color(0xFFD0D5DD)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(leftLabel,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF344054))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: onRight,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(rightLabel,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
          ),
        ]),
      );
}

// ══════════════════════════════════════════════════════════════════════════════
// ── Shared calendar/cycle widgets ─────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════

class _CalendarCell extends StatelessWidget {
  final DateTime date;
  final bool isPeriod, isPredicted, isFertile, isOvulation, isToday;

  const _CalendarCell({
    required this.date,
    required this.isPeriod,
    required this.isPredicted,
    required this.isFertile,
    required this.isOvulation,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    Color? bg;
    Color textColor = AppColors.textDark;
    bool hasDot = false;
    Color dotColor = Colors.transparent;

    if (isOvulation) {
      bg = const Color(0xFF9C27B0);
      textColor = Colors.white;
    } else if (isPeriod && !isPredicted) {
      bg = const Color(0xFFFF6B6B);
      textColor = Colors.white;
    } else if (isPredicted) {
      bg = const Color(0xFFFFB347).withOpacity(0.25);
      textColor = const Color(0xFFFF8C00);
      hasDot = true;
      dotColor = const Color(0xFFFFB347);
    } else if (isFertile) {
      bg = const Color(0xFF4CAF9A).withOpacity(0.15);
      textColor = const Color(0xFF2E8B7A);
    }

    return Container(
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border:
            isToday ? Border.all(color: AppColors.primary, width: 1.5) : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text('${date.day}',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                  color: textColor)),
          if (hasDot)
            Positioned(
              bottom: 3,
              child: Container(
                width: 4,
                height: 4,
                decoration:
                    BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color iconColor;

  const _HeaderPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Row(children: [
              Icon(icon, size: 8, color: iconColor),
              const SizedBox(width: 4),
              Text(label,
                  style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500)),
            ]),
            const SizedBox(height: 3),
            Text(value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
          ]),
        ),
      );
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool dashed;

  const _LegendDot(
      {required this.color, required this.label, this.dashed = false});

  @override
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              color: dashed ? color.withOpacity(0.3) : color,
              shape: BoxShape.circle,
              border:
                  dashed ? Border.all(color: color, width: 1.5) : null),
        ),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textMedium)),
      ]);
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 14),
          ...children,
        ]),
      );
}

class _EventRow extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title, subtitle, tag;
  final Color tagColor;

  const _EventRow({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagColor,
  });

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark)),
          const SizedBox(height: 2),
          Text(subtitle,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textMedium)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
              color: tagColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20)),
          child: Text(tag,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: tagColor)),
        ),
      ]);
}

class _StatBox extends StatelessWidget {
  final String label, value, unit;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.15))),
        child: Column(children: [
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: color)),
          const SizedBox(height: 2),
          Text(unit,
              style:
                  TextStyle(fontSize: 10, color: color.withOpacity(0.7))),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textMedium),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis),
        ]),
      );
}

class _PastPeriodRow extends StatelessWidget {
  final DateTime start, end;
  final int length;

  const _PastPeriodRow(
      {required this.start, required this.end, required this.length});

  @override
  Widget build(BuildContext context) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final label =
        '${months[start.month - 1]} ${start.day} – ${months[end.month - 1]} ${end.day}, ${end.year}';

    return Row(children: [
      Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
            color: const Color(0xFFFF6B6B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.water_drop_outlined,
            color: Color(0xFFFF6B6B), size: 18),
      ),
      const SizedBox(width: 12),
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        const SizedBox(height: 2),
        Text('$length days',
            style: const TextStyle(
                fontSize: 12, color: AppColors.textMedium)),
      ])),
      const Icon(Icons.chevron_right,
          size: 16, color: AppColors.textMedium),
    ]);
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(children: [
              Icon(icon,
                  size: 22,
                  color: active ? AppColors.primary : AppColors.textMedium),
              const SizedBox(height: 3),
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color:
                          active ? AppColors.primary : AppColors.textMedium,
                      fontWeight: active
                          ? FontWeight.w600
                          : FontWeight.w400)),
            ]),
          ),
        ),
      );
}