import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'app_colors.dart';
import 'app_textstyles.dart';
import 'routes.dart';
import 'app_notifications.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static int get _hour => DateTime.now().hour;

  static bool get _isMorning => _hour >= 5 && _hour < 12;
  static bool get _isAfternoon => _hour >= 12 && _hour < 17;

  static String get _greeting {
    if (_isMorning) return 'Good morning';
    if (_isAfternoon) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          // ── Top bar ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(_greeting,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textMedium)),
                  const Text('Sarah',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark)),
                ]),
                Row(children: [
                  NotificationBadge(
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.notifications),
                  ),
                  const SizedBox(width: 4),
                  const SizedBox(width: 4),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary,
                    child: const Text('S',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  ),
                ]),
              ],
            ),
          ),

          // ── Scrollable body ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(children: [
                _RiskGaugeCard(),
                const SizedBox(height: 16),

                Row(children: [
                  Expanded(child: _StatCard(
                      label: 'Data\nCompleteness',
                      value: '72%',
                      sub: '3 missing inputs',
                      isCircle: true,
                      percent: 0.72)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(
                      label: 'Check-in Streak',
                      value: '5',
                      sub: 'days',
                      isCircle: false)),
                ]),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Quick Actions',
                      style: AppTextStyles.sectionTitle),
                ),
                const SizedBox(height: 12),

                // Time-gated check-in tile
                if (_isMorning)
                  _ActionTile(
                    icon: Icons.wb_sunny_outlined,
                    iconBg: const Color(0xFFFFF3E0),
                    iconColor: Colors.orange,
                    dot: Colors.orange,
                    title: 'Morning Check-In',
                    subtitle: 'Rate fatigue & pelvic pressure',
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.morningCheckin),
                  )
                else if (_isAfternoon)
                  _ActionTile(
                    icon: Icons.wb_cloudy_outlined,
                    iconBg: const Color(0xFFFFF8E1),
                    iconColor: Colors.amber.shade700,
                    dot: Colors.amber.shade700,
                    title: 'Afternoon Check-In',
                    subtitle: 'Rate fatigue & pelvic pressure',
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.afternoonCheckin),
                  )
                else
                  _ActionTile(
                    icon: Icons.nightlight_round,
                    iconBg: const Color(0xFFE0F2F1),
                    iconColor: AppColors.primary,
                    dot: AppColors.primary,
                    title: 'Evening Check-In',
                    subtitle: 'Rate breast soreness & acne',
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.eveningCheckin),
                  ),

                const SizedBox(height: 10),

                _ActionTile(
                  icon: Icons.calendar_today_outlined,
                  iconBg: const Color(0xFFF3E5F5),
                  iconColor: const Color(0xFF9C27B0),
                  title: 'Period Tracking',
                  subtitle: 'Log your cycle',
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.periodLog),
                ),

                const SizedBox(height: 10),

                // ── FIXED: now routes to weeklyTools landing screen ────
                _ActionTile(
                  icon: Icons.assignment_outlined,
                  iconBg: const Color(0xFFE3F2FD),
                  iconColor: const Color(0xFF1565C0),
                  title: 'Weekly Tools',
                  subtitle: 'mFG & PHQ-4 due',
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.weeklyTools),
                ),

                const SizedBox(height: 10),

                _ActionTile(
                  icon: Icons.show_chart,
                  iconBg: const Color(0xFFE8F5E9),
                  iconColor: AppColors.riskLow,
                  title: 'Risk Trends',
                  subtitle: 'View your history',
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.riskTrend),
                ),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Today's Summary",
                      style: AppTextStyles.sectionTitle),
                ),
                const SizedBox(height: 12),
                _TodaySummaryCard(),
              ]),
            ),
          ),

          _BottomNav(context),
        ]),
      ),
    );
  }

  Widget _BottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          border: Border(top: BorderSide(color: AppColors.cardBorder))),
      child: Row(children: [
        _NavItem(icon: Icons.home_outlined, label: 'Home',
            active: true, onTap: () {}),
        _NavItem(icon: Icons.calendar_month_outlined, label: 'Cycle',
            onTap: () => Navigator.pushNamed(context, AppRoutes.cycleCalendar)),
        _NavItem(icon: Icons.bar_chart_outlined, label: 'Results',
            onTap: () => Navigator.pushNamed(context, AppRoutes.riskScore)),
        _NavItem(icon: Icons.person_outline, label: 'Profile',
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile)),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── Action Tile ───────────────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final Color? dot;
  final String title, subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.dot,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder)),
          child: Row(children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                  color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Text(title,
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
                    if (dot != null) ...[
                      const SizedBox(width: 6),
                      Container(
                          width: 7, height: 7,
                          decoration: BoxDecoration(
                              color: dot, shape: BoxShape.circle)),
                    ],
                  ]),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.cardSubtitle),
                ])),
            const Icon(Icons.chevron_right,
                size: 18, color: AppColors.textMedium),
          ]),
        ),
      );
}

// ══════════════════════════════════════════════════════════════════════════════
// ── Risk Gauge Card ───────────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _RiskGaugeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('PCOS Risk Score',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
            Text('Updated today', style: AppTextStyles.smallText),
          ]),
          const SizedBox(height: 12),
          SizedBox(
            height: 110,
            width: double.infinity,
            child: CustomPaint(painter: _GaugePainter(value: 0.42)),
          ),
          const SizedBox(height: 4),
          const Text('0.42',
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w800,
                  color: AppColors.textDark)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                color: AppColors.warningAmber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20)),
            child: const Text('Risk Tier: Moderate',
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600,
                    color: AppColors.warningAmber)),
          ),
        ]),
      );
}

class _GaugePainter extends CustomPainter {
  final double value;
  const _GaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height - 10;
    const r = 90.0;
    const stroke = 14.0;

    canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        math.pi, math.pi, false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFFE8F5E9));

    final zones = [
      (0.33, const Color(0xFF4CAF50)),
      (0.33, const Color(0xFFFFC107)),
      (0.34, const Color(0xFFF44336)),
    ];
    double start = 0;
    for (final z in zones) {
      canvas.drawArc(
          Rect.fromCircle(center: Offset(cx, cy), radius: r),
          math.pi + start * math.pi,
          z.$1 * math.pi,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = stroke
            ..strokeCap = StrokeCap.butt
            ..color = z.$2);
      start += z.$1;
    }

    final needleAngle = math.pi + value * math.pi;
    final nx = cx + (r - 4) * math.cos(needleAngle);
    final ny = cy + (r - 4) * math.sin(needleAngle);
    canvas.drawLine(Offset(cx, cy), Offset(nx, ny),
        Paint()
          ..color = AppColors.textDark
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round);
    canvas.drawCircle(Offset(cx, cy), 5, Paint()..color = AppColors.textDark);
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.value != value;
}

// ══════════════════════════════════════════════════════════════════════════════
// ── Stat Card ─────────────────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _StatCard extends StatelessWidget {
  final String label, value, sub;
  final bool isCircle;
  final double percent;

  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
    this.isCircle = false,
    this.percent = 0,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder)),
        child: isCircle
            ? Row(children: [
                SizedBox(
                  width: 44, height: 44,
                  child: CustomPaint(painter: _CirclePainter(percent: percent)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(label,
                        style: AppTextStyles.smallText
                            .copyWith(color: AppColors.textDark),
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(sub, style: AppTextStyles.smallText,
                        overflow: TextOverflow.ellipsis),
                  ]),
                ),
              ])
            : Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(value,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w800,
                          color: AppColors.textDark)),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(sub, style: AppTextStyles.cardSubtitle),
                  ),
                ]),
                const SizedBox(height: 4),
                Text(label, style: AppTextStyles.cardSubtitle),
                const SizedBox(height: 8),
                Row(children: List.generate(5,
                    (i) => Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: i < 4 ? 4 : 0),
                            height: 5,
                            decoration: BoxDecoration(
                                color: i < 5
                                    ? AppColors.primary
                                    : AppColors.cardBorder,
                                borderRadius: BorderRadius.circular(3)),
                          ),
                        ))),
              ]),
      );
}

class _CirclePainter extends CustomPainter {
  final double percent;
  const _CirclePainter({required this.percent});
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 3;
    canvas.drawCircle(c, r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = AppColors.cardBorder);
    canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        -math.pi / 2,
        2 * math.pi * percent,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round
          ..color = AppColors.primary);
    final tp = TextPainter(
        text: TextSpan(
            text: '${(percent * 100).round()}%',
            style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        textDirection: TextDirection.ltr)
      ..layout();
    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(_CirclePainter old) => old.percent != percent;
}

// ══════════════════════════════════════════════════════════════════════════════
// ── Today's Summary Card ──────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _TodaySummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder)),
        child: Row(children: [
          const Icon(Icons.info_outline,
              size: 15, color: AppColors.textMedium),
          const SizedBox(width: 6),
          Expanded(
            child: Text('Complete your check-ins to see today\'s summary',
                style: AppTextStyles.cardSubtitle),
          ),
        ]),
      );
}

// ══════════════════════════════════════════════════════════════════════════════
// ── Bottom Nav Item ───────────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
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
                      color: active ? AppColors.primary : AppColors.textMedium,
                      fontWeight:
                          active ? FontWeight.w600 : FontWeight.w400)),
            ]),
          ),
        ),
      );
}