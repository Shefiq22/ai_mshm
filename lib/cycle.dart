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

  // ── Mock data: past period ranges ─────────────────────────────────────────
  // Each entry: [start, end]
  final List<(DateTime, DateTime)> _periodRanges = [
    (DateTime(2026, 2, 10), DateTime(2026, 2, 15)),
    (DateTime(2026, 1, 12), DateTime(2026, 1, 17)),
    (DateTime(2025, 12, 14), DateTime(2025, 12, 19)),
    (DateTime(2025, 11, 15), DateTime(2025, 11, 20)),
  ];

  // Average cycle length derived from mock data
  int get _avgCycleLength => 29;
  int get _avgPeriodLength => 6;

  // Predicted next period start
  DateTime get _nextPeriodStart {
    final last = _periodRanges.first.$1;
    return last.add(Duration(days: _avgCycleLength));
  }

  DateTime get _nextPeriodEnd =>
      _nextPeriodStart.add(Duration(days: _avgPeriodLength - 1));

  // Fertile window: roughly 12–16 days before next period
  DateTime get _fertileStart =>
      _nextPeriodStart.subtract(const Duration(days: 16));
  DateTime get _fertileEnd =>
      _nextPeriodStart.subtract(const Duration(days: 12));

  // Ovulation day
  DateTime get _ovulationDay =>
      _nextPeriodStart.subtract(const Duration(days: 14));

  // ── Helpers ───────────────────────────────────────────────────────────────
  bool _isPeriodDay(DateTime d) {
    for (final r in _periodRanges) {
      if (!d.isBefore(r.$1) && !d.isAfter(r.$2)) return true;
    }
    // Also mark predicted
    if (!d.isBefore(_nextPeriodStart) && !d.isAfter(_nextPeriodEnd)) return true;
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

  // Days in focused month grid (including leading/trailing padding)
  List<DateTime?> _buildGrid() {
    final first = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    // weekday: 1=Mon … 7=Sun → we want Mon as col 0
    final leadingBlanks = (first.weekday - 1) % 7;
    final cells = <DateTime?>[];
    for (int i = 0; i < leadingBlanks; i++) cells.add(null);
    for (int d = 1; d <= daysInMonth; d++) {
      cells.add(DateTime(_focusedMonth.year, _focusedMonth.month, d));
    }
    // Pad to full rows
    while (cells.length % 7 != 0) cells.add(null);
    return cells;
  }

  void _prevMonth() => setState(() {
        _focusedMonth =
            DateTime(_focusedMonth.year, _focusedMonth.month - 1);
      });

  void _nextMonth() => setState(() {
        _focusedMonth =
            DateTime(_focusedMonth.year, _focusedMonth.month + 1);
      });

  String _monthLabel() {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[_focusedMonth.month - 1]} ${_focusedMonth.year}';
  }

  // Days until next period
  int get _daysUntilNext =>
      _nextPeriodStart.difference(DateTime.now()).inDays;

  @override
  Widget build(BuildContext context) {
    final grid = _buildGrid();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        // ── Teal gradient header ─────────────────────────────────────────
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
                // Top row: back + title
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
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.periodLog),
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
                // Cycle stat pills
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
                    value: '$_avgCycleLength days',
                    icon: Icons.loop,
                    iconColor: Colors.white70,
                  ),
                  const SizedBox(width: 10),
                  _HeaderPill(
                    label: 'Avg Period',
                    value: '$_avgPeriodLength days',
                    icon: Icons.water_drop_outlined,
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
                  // Month nav
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

                  // Day-of-week headers
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

                  // Calendar grid
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

                  // Legend
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: Wrap(spacing: 16, runSpacing: 8, children: const [
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

              // ── Upcoming events card ────────────────────────────────────
              _SectionCard(
                title: 'Upcoming',
                children: [
                  _EventRow(
                    color: const Color(0xFFFFB347),
                    icon: Icons.water_drop_outlined,
                    title: 'Next Period',
                    subtitle: _formatRange(_nextPeriodStart, _nextPeriodEnd),
                    tag: 'In $_daysUntilNext days',
                    tagColor: const Color(0xFFFFB347),
                  ),
                  const Divider(height: 20, color: Color(0xFFF2F4F7)),
                  _EventRow(
                    color: const Color(0xFF4CAF9A),
                    icon: Icons.favorite_border,
                    title: 'Fertile Window',
                    subtitle: _formatRange(_fertileStart, _fertileEnd),
                    tag: '5 days',
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

              // ── Cycle stats card ────────────────────────────────────────
              _SectionCard(
                title: 'Cycle Stats',
                children: [
                  Row(children: [
                    Expanded(child: _StatBox(
                        label: 'Avg Cycle', value: '$_avgCycleLength',
                        unit: 'days', color: AppColors.primary)),
                    const SizedBox(width: 12),
                    Expanded(child: _StatBox(
                        label: 'Avg Period', value: '$_avgPeriodLength',
                        unit: 'days', color: const Color(0xFFFF6B6B))),
                    const SizedBox(width: 12),
                    Expanded(child: _StatBox(
                        label: 'Regularity', value: '92',
                        unit: '%', color: const Color(0xFF4CAF9A))),
                  ]),
                ],
              ),

              const SizedBox(height: 16),

              // ── Past periods list ───────────────────────────────────────
              _SectionCard(
                title: 'Past Periods',
                children: [
                  ..._periodRanges.map((r) {
                    final length =
                        r.$2.difference(r.$1).inDays + 1;
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
              border:
                  Border(top: BorderSide(color: AppColors.cardBorder))),
          child: Row(children: [
            _NavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                onTap: () =>
                    Navigator.pushNamedAndRemoveUntil(
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
// ── Calendar Cell ─────────────────────────────────────────────────────────────
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
        border: isToday
            ? Border.all(
                color: AppColors.primary, width: 1.5)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text('${date.day}',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isToday ? FontWeight.w700 : FontWeight.w400,
                  color: textColor)),
          if (hasDot)
            Positioned(
              bottom: 3,
              child: Container(
                width: 4, height: 4,
                decoration: BoxDecoration(
                    color: dotColor, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── Small reusable widgets ────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════

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
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis),
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
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10, height: 10,
          decoration: BoxDecoration(
              color: dashed ? color.withOpacity(0.3) : color,
              shape: BoxShape.circle,
              border: dashed
                  ? Border.all(color: color, width: 1.5)
                  : null),
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
              style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
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
          width: 36, height: 36,
          decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(title,
              style: AppTextStyles.cardTitle.copyWith(fontSize: 13)),
          const SizedBox(height: 2),
          Text(subtitle, style: AppTextStyles.cardSubtitle),
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
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color)),
            TextSpan(
                text: unit,
                style: TextStyle(
                    fontSize: 11,
                    color: color.withOpacity(0.7))),
          ])),
          const SizedBox(height: 4),
          Text(label,
              style: AppTextStyles.smallText,
              textAlign: TextAlign.center),
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
        width: 36, height: 36,
        decoration: BoxDecoration(
            color: const Color(0xFFFF6B6B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.water_drop_outlined,
            color: Color(0xFFFF6B6B), size: 18),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Text(label, style: AppTextStyles.cardTitle.copyWith(fontSize: 13)),
        const SizedBox(height: 2),
        Text('$length days', style: AppTextStyles.cardSubtitle),
      ])),
      const Icon(Icons.chevron_right,
          size: 16, color: AppColors.textMedium),
    ]);
  }
}

// ── Bottom Nav Item (mirrors dashboard.dart) ──────────────────────────────────
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
                  color:
                      active ? AppColors.primary : AppColors.textMedium),
              const SizedBox(height: 3),
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: active
                          ? AppColors.primary
                          : AppColors.textMedium,
                      fontWeight: active
                          ? FontWeight.w600
                          : FontWeight.w400)),
            ]),
          ),
        ),
      );
}