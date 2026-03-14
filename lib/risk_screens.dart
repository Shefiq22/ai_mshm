import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_textstyles.dart';
import 'routes.dart';
import 'widgets.dart';
import 'dart:math' as math;

// ─── PCOS Risk Score Screen ───────────────────────────────────────────────────
class RiskScoreScreen extends StatefulWidget {
  const RiskScoreScreen({super.key});
  @override
  State<RiskScoreScreen> createState() => _RiskScoreState();
}

class _RiskScoreState extends State<RiskScoreScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _gauge = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 1200))
    ..forward();

  @override
  void dispose() { _gauge.dispose(); super.dispose(); }

  static const _factors = [
    _Factor('LH/FSH Ratio',        0.14, true),
    _Factor('Fasting Insulin',      0.11, true),
    _Factor('Cycle Irregularity',   0.09, true),
    _Factor('Ovarian Volume',       0.07, true),
    _Factor('BMI',                 -0.04, false),
  ];

  static const _explanations = [
    _Explanation('LH/FSH Ratio',
        'Elevated LH relative to FSH suggests hormonal imbalance'),
    _Explanation('Fasting Insulin',
        'Higher insulin levels indicate insulin resistance'),
    _Explanation('Cycle Irregularity',
        'Irregular periods are a hallmark PCOS symptom'),
    _Explanation('Ovarian Volume',
        'Enlarged ovaries with multiple follicles detected'),
    _Explanation('BMI',
        'Your BMI is within a healthy range, lowering risk'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20,
              color: AppColors.textDark),
          onPressed: () => Navigator.pop(context)),
        titleSpacing: 0,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PCOS Risk Score', style: AppTextStyles.cardTitle
                .copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('AI-powered assessment', style: AppTextStyles.smallText),
          ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart, color: AppColors.primary),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.riskTrend)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: AppColors.surfaceWhite,
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
            child: AnimatedBuilder(animation: _gauge, builder: (_, __) {
              final v = 0.68 * CurvedAnimation(
                  parent: _gauge, curve: Curves.easeOutCubic).value;
              return Column(children: [
                // Gauge arc — no text inside, just the arc + needle
                SizedBox(width: 220, height: 120,
                  child: CustomPaint(
                    painter: _MultiColorGaugePainter(value: v),
                  )),
                const SizedBox(height: 12),
                // Score number below the gauge
                Text(v.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 40, fontWeight: FontWeight.w800,
                    color: AppColors.textDark)),
                const SizedBox(height: 8),
                // Risk badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.riskHigh.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20)),
                  child: Row(mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shield_outlined, size: 13,
                          color: AppColors.riskHigh),
                      const SizedBox(width: 4),
                      Text('Risk Tier: High', style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: AppColors.riskHigh)),
                    ])),
                const SizedBox(height: 6),
                Text('Consult healthcare provider',
                  style: AppTextStyles.smallText),
              ]);
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('CONTRIBUTING FACTORS',
                    style: AppTextStyles.smallText.copyWith(
                      fontWeight: FontWeight.w700, letterSpacing: 0.8,
                      color: AppColors.textMedium)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.shapDetail),
                    child: Row(children: [
                      Text('Details', style: AppTextStyles.linkText
                          .copyWith(fontSize: 13)),
                      const Icon(Icons.chevron_right, size: 16,
                          color: AppColors.primary),
                    ])),
                ]),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder)),
                child: Column(children: _factors.map((f) =>
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(f.name, style: AppTextStyles.cardTitle
                                .copyWith(fontSize: 14)),
                            Text(
                              '${f.positive ? '+' : ''}${f.value.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700,
                                color: f.positive
                                    ? AppColors.riskHigh : AppColors.riskLow)),
                          ]),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: f.value.abs() / 0.15,
                            minHeight: 6,
                            backgroundColor: const Color(0xFFEEEEEE),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              f.positive ? AppColors.riskHigh
                                  : AppColors.riskLow))),
                      ]),
                  )).toList()),
              ),
              const SizedBox(height: 20),
              Align(alignment: Alignment.centerLeft,
                child: Text('WHAT THIS MEANS',
                  style: AppTextStyles.smallText.copyWith(
                    fontWeight: FontWeight.w700, letterSpacing: 0.8,
                    color: AppColors.textMedium))),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder)),
                child: Column(children: _explanations.asMap().entries
                  .map((e) => Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      child: Row(children: [
                        Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.riskHigh.withOpacity(0.1),
                            shape: BoxShape.circle),
                          child: Center(child: Text('${e.key + 1}',
                            style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700,
                              color: AppColors.riskHigh)))),
                        const SizedBox(width: 12),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.value.name, style: AppTextStyles
                                .cardTitle.copyWith(fontSize: 14)),
                            const SizedBox(height: 2),
                            Text(e.value.body,
                                style: AppTextStyles.cardSubtitle),
                          ])),
                      ])),
                    if (e.key < _explanations.length - 1)
                      const Divider(height: 1, indent: 14, endIndent: 14),
                  ])).toList()),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 14,
                        color: AppColors.textMedium),
                    const SizedBox(width: 8),
                    Expanded(child: Text(
                      'This score is generated by a machine learning model and is for informational purposes only. Always consult your healthcare provider for diagnosis and treatment decisions.',
                      style: AppTextStyles.smallText)),
                  ])),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(
                        context, AppRoutes.riskTrend),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                    child: Text('View Trend',
                      style: AppTextStyles.linkText))),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                        context, AppRoutes.shapDetail),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                    child: Text('Full Breakdown',
                      style: AppTextStyles.buttonText))),
              ]),
              const SizedBox(height: 10),
              SizedBox(width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClinicalReferralScreen())),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: AppColors.warningAmber),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                  child: Text('View Clinical Referral Recommendation',
                    style: AppTextStyles.linkText.copyWith(
                        color: AppColors.warningAmber)))),
              const SizedBox(height: 24),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ─── Risk Trend Screen ────────────────────────────────────────────────────────
class RiskTrendScreen extends StatefulWidget {
  const RiskTrendScreen({super.key});
  @override
  State<RiskTrendScreen> createState() => _RiskTrendState();
}

class _RiskTrendState extends State<RiskTrendScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _chartAnim = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 900))..forward();

  @override
  void dispose() { _chartAnim.dispose(); super.dispose(); }

  static const _weeks = [
    _WeekEntry('W1', 'Jan 6',  0.52, 0.03),
    _WeekEntry('W2', 'Jan 13', 0.55, 0.03),
    _WeekEntry('W3', 'Jan 20', 0.61, 0.06),
    _WeekEntry('W4', 'Jan 27', 0.58, -0.03),
    _WeekEntry('W5', 'Feb 3',  0.63, 0.05),
    _WeekEntry('W6', 'Feb 10', 0.65, 0.02),
    _WeekEntry('W7', 'Feb 17', 0.62, -0.03),
    _WeekEntry('W8', 'Feb 24', 0.68, 0.06),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20,
              color: AppColors.textDark),
          onPressed: () => Navigator.pop(context)),
        titleSpacing: 0,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Risk Trend', style: AppTextStyles.cardTitle
                .copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('8-week history', style: AppTextStyles.smallText),
          ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            Expanded(child: _TrendStatBox(
              label: 'Current', value: '0.68',
              valueColor: AppColors.textDark)),
            const SizedBox(width: 10),
            Expanded(child: _TrendStatBox(
              label: 'vs Last Week', value: '+0.06',
              valueColor: AppColors.riskHigh, isUp: true)),
            const SizedBox(width: 10),
            Expanded(child: _TrendStatBox(
              label: '8-wk Δ', value: '+0.16',
              valueColor: AppColors.riskHigh, isUp: true)),
          ]),
          const SizedBox(height: 14),
          Container(
            height: 230,
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: AnimatedBuilder(
                animation: _chartAnim,
                builder: (_, __) => CustomPaint(
                  painter: _TrendLinePainter(
                    progress: CurvedAnimation(
                        parent: _chartAnim,
                        curve: Curves.easeOutCubic).value,
                    scores: _weeks.map((w) => w.score).toList(),
                    dates: _weeks.map((w) => w.date).toList(),
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Align(alignment: Alignment.centerLeft,
            child: Text('WEEKLY CHANGES', style: AppTextStyles.smallText
                .copyWith(fontWeight: FontWeight.w700,
                    letterSpacing: 0.8, color: AppColors.textMedium))),
          const SizedBox(height: 10),
          ..._weeks.reversed.map((w) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder)),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5F2),
                  borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text(w.week,
                  style: AppTextStyles.smallText.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary, fontSize: 12)))),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(w.date, style: AppTextStyles.cardTitle
                      .copyWith(fontSize: 14)),
                  Text('Score: ${w.score.toStringAsFixed(2)}',
                    style: AppTextStyles.cardSubtitle),
                ])),
              Row(children: [
                Icon(w.delta >= 0 ? Icons.north_east : Icons.south_east,
                  size: 13,
                  color: w.delta >= 0 ? AppColors.riskHigh
                      : AppColors.riskLow),
                const SizedBox(width: 3),
                Text(
                  '${w.delta >= 0 ? '+' : ''}${w.delta.toStringAsFixed(2)}',
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: 14,
                    color: w.delta >= 0 ? AppColors.riskHigh
                        : AppColors.riskLow)),
              ]),
            ]),
          )),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}

// ─── Score Breakdown Screen ───────────────────────────────────────────────────
class ShapDetailScreen extends StatefulWidget {
  const ShapDetailScreen({super.key});
  @override
  State<ShapDetailScreen> createState() => _ShapDetailState();
}

class _ShapDetailState extends State<ShapDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bars = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 900))..forward();
  @override
  void dispose() { _bars.dispose(); super.dispose(); }

  static const _items = [
    _BreakdownItem('LH/FSH Ratio',    '2.98',    '0.14', '+0.01 vs last wk',  true),
    _BreakdownItem('Fasting Insulin', '14.2 μU/mL','0.11','—  No change',     true),
    _BreakdownItem('Cycle Irregularity','45+ days','0.09','—  No change',     true),
    _BreakdownItem('Ovarian Volume',  '12.0 mL', '0.07', '—  No change',      true),
    _BreakdownItem('BMI',             '23.1 kg/m²','-0.04','+0.01 vs last wk',false),
    _BreakdownItem('Hirsutism Score', '8 /36',   '0.05', '+0.01 vs last wk',  true),
    _BreakdownItem('PHQ-4 Score',     '4 /12',   '0.02', '-0.01 vs last wk',  true),
    _BreakdownItem('HbA1c',           '5.4 %',   '0.01', '—  No change',      true),
    _BreakdownItem('Acne Severity',   '6 /10',   '0.03', '+0.01 vs last wk',  true),
  ];

  static const _descriptions = {
    'LH/FSH Ratio':     'Elevated LH ratio remains the top contributor. LH/FSH of 2.98 is above the normal 1:1 ratio.',
    'Fasting Insulin':  'Insulin of 14.2 μU/mL indicates mild insulin resistance, a key PCOS driver.',
    'Cycle Irregularity':'Cycle length of 45+ days confirms oligomenorrhea, a primary Rotterdam criterion.',
    'Ovarian Volume':   'Ovarian volume remained stable. Volumes above 10 mL are considered enlarged and contribute to risk.',
    'BMI':              'Your BMI remains healthy, continuing to lower your overall risk. Slight increase reduced its protective effect.',
    'Hirsutism Score':  'Modified Ferriman-Gallwey score increased slightly, indicating mild excess hair growth contributing to risk.',
    'PHQ-4 Score':      'Psychological distress decreased this week, slightly reducing its contribution to your overall score.',
    'HbA1c':            'HbA1c remains normal. This value has minimal effect on your risk score.',
    'Acne Severity':    'Acne severity increased from last week\'s evening check-ins, adding slightly more risk contribution.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20,
              color: AppColors.textDark),
          onPressed: () => Navigator.pop(context)),
        titleSpacing: 0,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Score Breakdown', style: AppTextStyles.cardTitle
                .copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('SHAP feature contributions',
                style: AppTextStyles.smallText),
          ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AnimatedBuilder(
          animation: _bars,
          builder: (_, __) {
            final p = CurvedAnimation(
                parent: _bars, curve: Curves.easeOutCubic).value;
            return Column(children: [
              ..._items.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: (item.positive
                              ? AppColors.riskHigh : AppColors.riskLow)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8)),
                        child: Icon(
                          item.positive ? Icons.north_east : Icons.south_east,
                          size: 15,
                          color: item.positive ? AppColors.riskHigh
                              : AppColors.riskLow)),
                      const SizedBox(width: 10),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: AppTextStyles.cardTitle
                              .copyWith(fontSize: 14)),
                          Text(item.rawValue,
                              style: AppTextStyles.cardSubtitle),
                        ])),
                      Column(crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${item.positive ? '+' : '-'}${item.shap}',
                            style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700,
                              color: item.positive ? AppColors.riskHigh
                                  : AppColors.riskLow)),
                          Text(item.vsLastWk,
                            style: AppTextStyles.smallText
                                .copyWith(fontSize: 10)),
                        ]),
                    ]),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: double.parse(item.shap) / 0.15 * p,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFEEEEEE),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          item.positive ? AppColors.riskHigh
                              : AppColors.riskLow))),
                    const SizedBox(height: 8),
                    Text(_descriptions[item.name] ?? '',
                      style: AppTextStyles.cardSubtitle),
                  ]),
              )),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 14,
                        color: AppColors.textMedium),
                    const SizedBox(width: 8),
                    Expanded(child: Text(
                      'SHAP values show how each feature pushes the score up or down from a baseline. Larger bars = stronger contribution. Week-over-week changes highlight what shifted since your last assessment.',
                      style: AppTextStyles.smallText)),
                  ])),
              const SizedBox(height: 16),
            ]);
          },
        ),
      ),
    );
  }
}

// ─── Painters ─────────────────────────────────────────────────────────────────
class _MultiColorGaugePainter extends CustomPainter {
  final double value;
  const _MultiColorGaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.75;
    final r = size.width * 0.42;
    const start = math.pi;
    const sweep = math.pi;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    canvas.drawArc(rect, start, sweep, false,
      Paint()..color = const Color(0xFFEEEEEE)
        ..style = PaintingStyle.stroke..strokeWidth = 16
        ..strokeCap = StrokeCap.round);
    final segments = [
      (0.0, 0.33, const Color(0xFF26A69A)),
      (0.33, 0.6, const Color(0xFFFFCA28)),
      (0.6, 0.8, const Color(0xFFFF7043)),
      (0.8, 1.0, const Color(0xFFE53935)),
    ];
    for (final s in segments) {
      if (value <= s.$1) continue;
      final end = math.min(value, s.$2);
      canvas.drawArc(rect,
        start + sweep * s.$1, sweep * (end - s.$1), false,
        Paint()..color = s.$3..style = PaintingStyle.stroke
          ..strokeWidth = 16..strokeCap = StrokeCap.round);
    }
    final na = math.pi + (math.pi * value);
    final nx = cx + (r - 8) * math.cos(na);
    final ny = cy + (r - 8) * math.sin(na);
    canvas.drawLine(Offset(cx, cy), Offset(nx, ny),
      Paint()..color = const Color(0xFF222222)..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round);
    canvas.drawCircle(Offset(cx, cy), 5,
      Paint()..color = const Color(0xFF222222));
  }

  @override
  bool shouldRepaint(_MultiColorGaugePainter o) => o.value != value;
}

class _TrendLinePainter extends CustomPainter {
  final double progress;
  final List<double> scores;
  final List<String> dates;
  const _TrendLinePainter({required this.progress,
    required this.scores, required this.dates});

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.isEmpty) return;
    final w = size.width;
    final h = size.height - 20;
    const minY = 0.0; const maxY = 1.0;
    final gridPaint = Paint()..color = const Color(0xFFEEEEEE)..strokeWidth = 1;
    for (final v in [0.0, 0.25, 0.5, 0.75, 1.0]) {
      final y = h - (v - minY) / (maxY - minY) * h;
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
      if (v == 0.75) {
        _drawDashedLine(canvas, Offset(0, y), Offset(w, y), const Color(0xFFE53935));
        _drawLabel(canvas, 'High', Offset(w - 28, y - 8), const Color(0xFFE53935));
      }
      if (v == 0.5) {
        _drawDashedLine(canvas, Offset(0, y), Offset(w, y), const Color(0xFFFFCA28));
        _drawLabel(canvas, 'Moderate', Offset(w - 52, y - 8), const Color(0xFFFFCA28));
      }
      final tp = TextPainter(
        text: TextSpan(text: v.toStringAsFixed(2),
          style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 9)),
        textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(0, y - 10));
    }
    final n = scores.length;
    Offset pt(int i) {
      final x = i / (n - 1) * w;
      final y = h - (scores[i] - minY) / (maxY - minY) * h;
      return Offset(x, y);
    }
    final fill = Path()..moveTo(pt(0).dx, h);
    for (int i = 0; i < n; i++) {
      if (i / (n - 1) > progress) break;
      fill.lineTo(pt(i).dx, pt(i).dy);
    }
    fill.lineTo(pt(0).dx, h);
    fill.close();
    canvas.drawPath(fill, Paint()
      ..color = AppColors.primary.withOpacity(0.06)
      ..style = PaintingStyle.fill);
    final path = Path();
    bool started = false;
    for (int i = 0; i < n; i++) {
      if (i / (n - 1) > progress) break;
      if (!started) { path.moveTo(pt(i).dx, pt(i).dy); started = true; }
      else path.lineTo(pt(i).dx, pt(i).dy);
    }
    canvas.drawPath(path, Paint()
      ..color = AppColors.primary..style = PaintingStyle.stroke
      ..strokeWidth = 2..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round);
    for (int i = 0; i < n; i++) {
      if (i / (n - 1) > progress) break;
      final p = pt(i);
      canvas.drawCircle(p, 4, Paint()..color = AppColors.primary);
      canvas.drawCircle(p, 4, Paint()
        ..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
      final tp = TextPainter(
        text: TextSpan(text: dates[i],
          style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 9)),
        textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(p.dx - tp.width / 2, h + 4));
    }
  }

  void _drawDashedLine(Canvas c, Offset p1, Offset p2, Color color) {
    final paint = Paint()..color = color.withOpacity(0.5)..strokeWidth = 1;
    double x = p1.dx;
    while (x < p2.dx) {
      c.drawLine(Offset(x, p1.dy), Offset(x + 6, p1.dy), paint);
      x += 10;
    }
  }

  void _drawLabel(Canvas c, String text, Offset pos, Color color) {
    TextPainter(
      text: TextSpan(text: text,
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w600)),
      textDirection: TextDirection.ltr)
      ..layout()
      ..paint(c, pos);
  }

  @override
  bool shouldRepaint(_TrendLinePainter o) => o.progress != progress;
}

// ─── Helper widgets ───────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) => Text(label,
    style: AppTextStyles.smallText.copyWith(
      fontWeight: FontWeight.w700, letterSpacing: 0.8,
      color: AppColors.textMedium));
}

class _TrendStatBox extends StatelessWidget {
  final String label, value;
  final Color valueColor;
  final bool isUp;
  const _TrendStatBox({required this.label, required this.value,
    required this.valueColor, this.isUp = false});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
    decoration: BoxDecoration(
      color: AppColors.surfaceWhite,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.cardBorder)),
    child: Column(children: [
      Text(label, style: AppTextStyles.smallText.copyWith(fontSize: 11),
        textAlign: TextAlign.center),
      const SizedBox(height: 6),
      Row(mainAxisSize: MainAxisSize.min, children: [
        if (isUp) Icon(Icons.north_east, size: 13, color: valueColor),
        Text(value, style: AppTextStyles.cardTitle.copyWith(
          fontSize: 18, color: valueColor)),
      ]),
    ]),
  );
}

class _FindingCell extends StatelessWidget {
  final String label, value, badge;
  final Color badgeColor;
  final bool hasBorderRight, hasBorderBottom;
  const _FindingCell({required this.label, required this.value,
    required this.badge, required this.badgeColor,
    this.hasBorderRight = false, this.hasBorderBottom = false});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      border: Border(
        right: hasBorderRight
            ? BorderSide(color: AppColors.cardBorder) : BorderSide.none,
        bottom: hasBorderBottom
            ? BorderSide(color: AppColors.cardBorder) : BorderSide.none)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12)),
      const SizedBox(height: 4),
      Row(children: [
        Text(value, style: AppTextStyles.cardTitle.copyWith(fontSize: 17)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20)),
          child: Text(badge, style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w600,
            color: badgeColor))),
      ]),
    ]),
  );
}

class _EvalItem extends StatelessWidget {
  final int num;
  final String text;
  final bool isLast;
  const _EvalItem({required this.num, required this.text, this.isLast = false});
  @override
  Widget build(BuildContext context) => Column(children: [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            shape: BoxShape.circle),
          child: Center(child: Text('$num', style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w700,
            color: AppColors.primary)))),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTextStyles.cardSubtitle
            .copyWith(color: AppColors.textDark))),
      ])),
    if (!isLast) const Divider(height: 1, indent: 50, endIndent: 14),
  ]);
}

class _DoctorCard extends StatelessWidget {
  final String name, specialty, clinic, address, nextAvail, distance, phone;
  const _DoctorCard({required this.name, required this.specialty,
    required this.clinic, required this.address, required this.nextAvail,
    required this.distance, required this.phone});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.surfaceWhite,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.cardBorder)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5F2),
            borderRadius: BorderRadius.circular(20)),
          child: const Icon(Icons.person_outline,
              color: AppColors.primary, size: 22)),
        const SizedBox(width: 10),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
            Text(specialty, style: AppTextStyles.cardSubtitle),
          ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20)),
          child: Text(distance, style: AppTextStyles.smallText.copyWith(
            color: AppColors.primary, fontWeight: FontWeight.w600))),
      ]),
      const SizedBox(height: 10),
      _DoctorRow(icon: Icons.business_outlined, text: clinic),
      const SizedBox(height: 4),
      _DoctorRow(icon: Icons.location_on_outlined, text: address),
      const SizedBox(height: 4),
      _DoctorRow(icon: Icons.calendar_today_outlined, text: nextAvail),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10))),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone_outlined, size: 16,
                  color: AppColors.textMedium),
              const SizedBox(width: 8),
              Text(phone, style: AppTextStyles.cardSubtitle),
            ]))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10))),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Text('Book', style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
            SizedBox(width: 4),
            Icon(Icons.open_in_new, color: Colors.white, size: 14),
          ])),
      ]),
    ]),
  );
}

class _DoctorRow extends StatelessWidget {
  final IconData icon; final String text;
  const _DoctorRow({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 14, color: AppColors.textMedium),
    const SizedBox(width: 6),
    Expanded(child: Text(text, style: AppTextStyles.cardSubtitle)),
  ]);
}

// ─── Data models ──────────────────────────────────────────────────────────────
class _Factor {
  final String name;
  final double value;
  final bool positive;
  const _Factor(this.name, this.value, this.positive);
}

class _Explanation {
  final String name, body;
  const _Explanation(this.name, this.body);
}

class _WeekEntry {
  final String week, date;
  final double score, delta;
  const _WeekEntry(this.week, this.date, this.score, this.delta);
}

class _BreakdownItem {
  final String name, rawValue, shap, vsLastWk;
  final bool positive;
  const _BreakdownItem(this.name, this.rawValue, this.shap,
      this.vsLastWk, this.positive);
}

// ─── TriageNoLabsScreen ───────────────────────────────────────────────────────
class TriageNoLabsScreen extends StatelessWidget {
  const TriageNoLabsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context)),
        titleSpacing: 0,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Symptom-Based Assessment',
              style: AppTextStyles.cardTitle
                  .copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
          Text('Fallback mode', style: AppTextStyles.smallText),
        ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.warningAmber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warningAmber.withOpacity(0.4))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.warning_amber_rounded,
                  color: AppColors.warningAmber, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fallback Mode — Symptom Data Only',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('Clinical lab results are not yet available. '
                    'Add lab results to improve accuracy.',
                    style: AppTextStyles.cardSubtitle),
                ])),
            ]),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
              child: const Text('Upload Lab Results',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)))),
        ]),
      ),
    );
  }
}

// ─── PeriodLogScreen ──────────────────────────────────────────────────────────
class PeriodLogScreen extends StatefulWidget {
  const PeriodLogScreen({super.key});
  @override
  State<PeriodLogScreen> createState() => _PeriodLogScreenState();
}

class _PeriodLogScreenState extends State<PeriodLogScreen> {
  int _step = 0;
  DateTime? _startDate;
  DateTime? _endDate;
  final Map<DateTime, int> _intensity = {};

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

  bool get _canContinueStep0 => _startDate != null && _endDate != null;

  Future<void> _pickDate(bool isStart) async {
    final now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime initialDate;
    if (isStart) {
      initialDate = _startDate ?? now;
    } else {
      final candidate = _endDate ?? (_startDate ?? now).add(const Duration(days: 5));
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
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    final suffix = _daySuffix(d.day);
    return '${months[d.month - 1]} ${d.day}$suffix, ${d.year}';
  }

  String _fmtShort(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  String _fmtDayHeader(DateTime d) {
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
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
                )
              : _step == 1
                  ? _PLStep1(
                      days: _days,
                      intensity: _intensity,
                      onChanged: (d, v) => setState(() => _intensity[d] = v),
                      onBack: () => setState(() => _step = 0),
                      onReview: () => setState(() => _step = 2),
                      fmtDayHeader: _fmtDayHeader,
                    )
                  : _PLStep2(
                      startDate: _startDate!,
                      endDate: _endDate!,
                      days: _days,
                      intensity: _intensity,
                      onBack: () => setState(() => _step = 1),
                      onSave: () => Navigator.pop(context),
                      fmtShort: _fmtShort,
                      fmtDayHeader: _fmtDayHeader,
                    ),
        ),
      ]),
    );
  }
}

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
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('Log Period',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
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
            color: active ? AppColors.primary : const Color(0xFFD0D5DD),
          ),
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
  const _PLStepCircle({required this.step, required this.done, required this.active});
  @override
  Widget build(BuildContext context) {
    final bg = (done || active) ? AppColors.primary : const Color(0xFFE4E7EC);
    final fg = (done || active) ? Colors.white : const Color(0xFF98A2B3);
    return Container(
      width: 34, height: 34,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Center(
        child: done
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : Text('$step', style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: fg)),
      ),
    );
  }
}

class _PLStep0 extends StatelessWidget {
  final DateTime? startDate, endDate;
  final VoidCallback onPickStart, onPickEnd, onContinue;
  final bool canContinue;
  final String Function(DateTime) fmtLong;

  const _PLStep0({
    required this.startDate, required this.endDate,
    required this.onPickStart, required this.onPickEnd,
    required this.canContinue, required this.onContinue,
    required this.fmtLong,
  });

  @override
  Widget build(BuildContext context) => Column(children: [
    Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Period Dates',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                  color: Color(0xFF101828))),
          const SizedBox(height: 4),
          const Text('Select when your period started and ended.',
              style: TextStyle(fontSize: 14, color: Color(0xFF667085))),
          const SizedBox(height: 28),
          _PLDateCard(
            label: 'Start Date', placeholder: 'Select start date',
            value: startDate != null ? fmtLong(startDate!) : null,
            onTap: onPickStart,
          ),
          const SizedBox(height: 16),
          _PLDateCard(
            label: 'End Date', placeholder: 'Select end date',
            value: endDate != null ? fmtLong(endDate!) : null,
            onTap: onPickEnd,
          ),
        ]),
      ),
    ),
    Padding(
      padding: EdgeInsets.fromLTRB(24, 8, 24, MediaQuery.of(context).padding.bottom + 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canContinue ? onContinue : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Text('Continue',
              style: TextStyle(color: Colors.white, fontSize: 16,
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
  const _PLDateCard({required this.label, required this.placeholder,
    required this.value, required this.onTap});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E7EC))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 13,
          fontWeight: FontWeight.w500, color: Color(0xFF344054))),
      const SizedBox(height: 10),
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD0D5DD))),
          child: Row(children: [
            const Icon(Icons.calendar_today_outlined,
                size: 16, color: Color(0xFF667085)),
            const SizedBox(width: 10),
            Text(value ?? placeholder,
                style: TextStyle(fontSize: 14,
                    color: value != null
                        ? const Color(0xFF101828) : const Color(0xFF98A2B3))),
          ]),
        ),
      ),
    ]),
  );
}

class _PLStep1 extends StatelessWidget {
  final List<DateTime> days;
  final Map<DateTime, int> intensity;
  final void Function(DateTime, int) onChanged;
  final VoidCallback onBack, onReview;
  final String Function(DateTime) fmtDayHeader;

  const _PLStep1({required this.days, required this.intensity,
    required this.onChanged, required this.onBack, required this.onReview,
    required this.fmtDayHeader});

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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Bleeding Intensity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                  color: Color(0xFF101828))),
          const SizedBox(height: 4),
          const Text('Set the flow for each day of your period.',
              style: TextStyle(fontSize: 14, color: Color(0xFF667085))),
          const SizedBox(height: 20),
          ...days.map((d) {
            final sel = intensity[d] ?? 2;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE4E7EC))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(fmtDayHeader(d),
                    style: const TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w600, color: Color(0xFF101828))),
                const SizedBox(height: 12),
                Row(children: List.generate(4, (i) {
                  final active = sel == i;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(d, i),
                      child: Container(
                        margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.primary.withOpacity(0.08) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: active ? AppColors.primary : const Color(0xFFE4E7EC),
                            width: active ? 1.5 : 1,
                          ),
                        ),
                        child: Column(children: [
                          Text(_dropIcons(i),
                              style: TextStyle(fontSize: 11,
                                  color: active ? AppColors.primary
                                      : const Color(0xFFE57373))),
                          const SizedBox(height: 4),
                          Text(_labels[i],
                              style: TextStyle(fontSize: 11,
                                  fontWeight: active
                                      ? FontWeight.w600 : FontWeight.w400,
                                  color: active ? AppColors.primary
                                      : const Color(0xFF667085))),
                        ]),
                      ),
                    ),
                  );
                })),
              ]),
            );
          }),
        ]),
      ),
    ),
    _PLTwoButtons(leftLabel: 'Back', rightLabel: 'Review',
        onLeft: onBack, onRight: onReview),
  ]);
}

class _PLStep2 extends StatelessWidget {
  final DateTime startDate, endDate;
  final List<DateTime> days;
  final Map<DateTime, int> intensity;
  final VoidCallback onBack, onSave;
  final String Function(DateTime) fmtShort;
  final String Function(DateTime) fmtDayHeader;

  const _PLStep2({required this.startDate, required this.endDate,
    required this.days, required this.intensity,
    required this.onBack, required this.onSave,
    required this.fmtShort, required this.fmtDayHeader});

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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Review & Save',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                  color: Color(0xFF101828))),
          const SizedBox(height: 4),
          const Text('Confirm your period details before saving.',
              style: TextStyle(fontSize: 14, color: Color(0xFF667085))),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE4E7EC))),
            child: Column(children: [
              _PLReviewRow(label: 'Duration', value: '${days.length} days', bold: true),
              const Divider(height: 20, color: Color(0xFFF2F4F7)),
              _PLReviewRow(label: 'Start', value: fmtShort(startDate), bold: true),
              const Divider(height: 20, color: Color(0xFFF2F4F7)),
              _PLReviewRow(label: 'End', value: fmtShort(endDate), bold: true),
            ]),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE4E7EC))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Daily Flow',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                      color: Color(0xFF101828))),
              const SizedBox(height: 14),
              ...days.map((d) {
                final lvl = intensity[d] ?? 2;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text(fmtDayHeader(d),
                        style: const TextStyle(fontSize: 13, color: Color(0xFF667085))),
                    Row(children: [
                      Text(_dropStr(lvl),
                          style: const TextStyle(fontSize: 12, color: Color(0xFFE57373))),
                      const SizedBox(width: 6),
                      Text(_labels[lvl],
                          style: const TextStyle(fontSize: 13,
                              fontWeight: FontWeight.w600, color: Color(0xFF101828))),
                    ]),
                  ]),
                );
              }),
            ]),
          ),
        ]),
      ),
    ),
    _PLTwoButtons(leftLabel: 'Back', rightLabel: 'Save Period',
        onLeft: onBack, onRight: onSave),
  ]);
}

class _PLReviewRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  const _PLReviewRow({required this.label, required this.value, this.bold = false});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF667085))),
      Text(value, style: TextStyle(fontSize: 14,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          color: const Color(0xFF101828))),
    ],
  );
}

class _PLTwoButtons extends StatelessWidget {
  final String leftLabel, rightLabel;
  final VoidCallback onLeft, onRight;
  const _PLTwoButtons({required this.leftLabel, required this.rightLabel,
    required this.onLeft, required this.onRight});
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(
        16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(leftLabel, style: const TextStyle(fontSize: 15,
              fontWeight: FontWeight.w600, color: Color(0xFF344054))),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(rightLabel, style: const TextStyle(fontSize: 15,
              fontWeight: FontWeight.w600, color: Colors.white)),
        ),
      ),
    ]),
  );
}

// ─── Clinical Referral Screen ─────────────────────────────────────────────────
class ClinicalReferralScreen extends StatelessWidget {
  const ClinicalReferralScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const _ReferralMainScreen();
  }
}

// ── Main Referral Screen ──────────────────────────────────────────────────────
class _ReferralMainScreen extends StatelessWidget {
  const _ReferralMainScreen();

  static const _evaluations = [
    'Complete hormone panel (FSH, LH, testosterone, DHEA-S)',
    'Pelvic ultrasound to assess ovarian morphology',
    'Fasting glucose and insulin levels',
    'Lipid profile assessment',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Clinical Referral',
              style: AppTextStyles.cardTitle
                  .copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
          Text('Specialist recommendation', style: AppTextStyles.smallText),
        ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Urgency banner ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warningAmber.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.warningAmber.withOpacity(0.35)),
            ),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.warningAmber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.warning_amber_rounded,
                    color: AppColors.warningAmber, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.warningAmber,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Urgent',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                    const SizedBox(width: 8),
                    Text('Risk Score: 0.78',
                        style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12)),
                  ]),
                  const SizedBox(height: 6),
                  Text('High Risk Detected',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                  const SizedBox(height: 2),
                  Text('Recommend consultation within 2 weeks',
                      style: AppTextStyles.cardSubtitle),
                ])),
            ]),
          ),

          const SizedBox(height: 20),
          _CRSectionLabel('RECOMMENDED SPECIALIST'),
          const SizedBox(height: 10),

          // ── Specialist card ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.medical_services_outlined,
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('Reproductive Endocrinologist',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                  Text('Based on your clinical profile',
                      style: AppTextStyles.cardSubtitle),
                ])),
              ]),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Elevated androgen levels and irregular cycles suggest PCOS requiring specialist evaluation',
                  style: AppTextStyles.cardSubtitle.copyWith(
                      color: AppColors.textDark, fontSize: 13),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 20),
          _CRSectionLabel('KEY CLINICAL FINDINGS'),
          const SizedBox(height: 10),

          // ── Findings grid ──
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(children: [
              Row(children: [
                Expanded(child: _FindingCell(
                  label: 'LH/FSH Ratio', value: '2.8', badge: 'elevated',
                  badgeColor: AppColors.riskHigh,
                  hasBorderRight: true, hasBorderBottom: true)),
                Expanded(child: _FindingCell(
                  label: 'Free Testosterone', value: '48 pg/mL', badge: 'elevated',
                  badgeColor: AppColors.riskHigh, hasBorderBottom: true)),
              ]),
              Row(children: [
                Expanded(child: _FindingCell(
                  label: 'Cycle Length', value: '45+ days', badge: 'irregular',
                  badgeColor: AppColors.warningAmber, hasBorderRight: true)),
                Expanded(child: _FindingCell(
                  label: 'mFG Score', value: '12', badge: 'elevated',
                  badgeColor: AppColors.riskHigh)),
              ]),
            ]),
          ),

          const SizedBox(height: 20),
          _CRSectionLabel('RECOMMENDED EVALUATIONS'),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(children: _evaluations.asMap().entries.map((e) =>
              _EvalItem(
                num: e.key + 1,
                text: e.value,
                isLast: e.key == _evaluations.length - 1,
              )).toList()),
          ),

          const SizedBox(height: 20),
          _CRSectionLabel('NEARBY SPECIALISTS'),
          const SizedBox(height: 10),

          _DoctorCard(
            name: 'Dr. Sarah Chen, MD',
            specialty: 'Reproductive Endocrinology',
            clinic: 'Women\'s Health Specialists',
            address: '123 Medical Center Dr, Suite 400',
            nextAvail: 'Next available: March 15, 2024',
            distance: '2.3 miles',
            phone: '(555) 123-4567',
          ),
          const SizedBox(height: 10),
          _DoctorCard(
            name: 'Dr. Michael Torres, MD',
            specialty: 'OB/GYN, PCOS Specialist',
            clinic: 'Metro Women\'s Care',
            address: '456 Healthcare Blvd, Floor 2',
            nextAvail: 'Next available: March 18, 2024',
            distance: '4.1 miles',
            phone: '(555) 987-6543',
          ),

          const SizedBox(height: 20),

          // ── Bottom action buttons ──
          Row(children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const _ClinicalSummaryPage())),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    const Icon(Icons.description_outlined, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text('View Summary', style: AppTextStyles.linkText),
                  ]),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const _ClinicalSummaryPage())),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(Icons.download_outlined, size: 16, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Download PDF', style: TextStyle(color: Colors.white,
                        fontSize: 14, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),
            ),
          ]),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.shield_outlined, size: 14,
                  color: AppColors.textMedium),
              const SizedBox(width: 8),
              Expanded(child: Text(
                'This referral recommendation is based on AI analysis and should be discussed with your healthcare provider. The final decision on specialist consultation rests with you and your primary care physician.',
                style: AppTextStyles.smallText,
              )),
            ]),
          ),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}

// ── Clinical Summary / PDF Preview Screen ─────────────────────────────────────
class _ClinicalSummaryPage extends StatefulWidget {
  const _ClinicalSummaryPage();
  @override
  State<_ClinicalSummaryPage> createState() => _ClinicalSummaryState();
}

class _ClinicalSummaryState extends State<_ClinicalSummaryPage> {
  bool _riskOpen = true;
  bool _clinicalOpen = false;
  bool _referralOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Clinical Summary',
              style: AppTextStyles.cardTitle
                  .copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
          Text('PDF Preview', style: AppTextStyles.smallText),
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.download_outlined, size: 14, color: Colors.white),
                  SizedBox(width: 4),
                  Text('PDF', style: TextStyle(color: Colors.white,
                      fontSize: 13, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // ── Report header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('AI-MSHM Clinical Report',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
                  const SizedBox(height: 2),
                  Text('PCOS Risk Assessment Summary',
                      style: AppTextStyles.cardSubtitle),
                ])),
                const SizedBox(width: 8),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('Generated: March 10, 2024',
                      style: AppTextStyles.smallText),
                  const SizedBox(height: 2),
                  Text('ID: PT-2024-0892',
                      style: AppTextStyles.smallText),
                ]),
              ]),
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFF2F4F7)),
              const SizedBox(height: 14),
              Row(children: [
                Flexible(child: _SummaryInfoCell(
                  icon: Icons.person_outline,
                  label: 'Patient',
                  value: 'Sarah Johnson',
                )),
                Flexible(child: _SummaryInfoCell(
                  icon: Icons.calendar_today_outlined,
                  label: 'Age',
                  value: '28 years',
                )),
              ]),
            ]),
          ),

          const SizedBox(height: 12),

          // ── Risk Assessment section ──
          _CRExpandableSection(
            icon: Icons.show_chart,
            title: 'Risk Assessment',
            isOpen: _riskOpen,
            onToggle: () => setState(() => _riskOpen = !_riskOpen),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Current Risk Score',
                      style: AppTextStyles.cardSubtitle),
                  const SizedBox(height: 4),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text('0.68',
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 32)),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.riskHigh.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('High Risk',
                          style: TextStyle(fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.riskHigh)),
                    ),
                  ]),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('vs Previous',
                      style: AppTextStyles.smallText),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.north_east, size: 14, color: AppColors.riskHigh),
                    const SizedBox(width: 4),
                    Text('+0.16',
                        style: TextStyle(fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.riskHigh)),
                  ]),
                ]),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                const Icon(Icons.shield_outlined, size: 14,
                    color: AppColors.textMedium),
                const SizedBox(width: 6),
                Text('Model confidence: 89%',
                    style: AppTextStyles.cardSubtitle),
              ]),
              const SizedBox(height: 16),
              _CRSectionLabel('Risk Drivers (SHAP Analysis)'),
              const SizedBox(height: 12),
              _SummaryShapBar(label: 'LH/FSH Ratio',
                  value: '2.8', shap: '+0.14', fill: 1.0,
                  color: AppColors.riskHigh),
              _SummaryShapBar(label: 'Fasting Insulin',
                  value: '18 mIU/L', shap: '+0.11', fill: 0.78,
                  color: AppColors.riskHigh),
              _SummaryShapBar(label: 'Cycle Irregularity',
                  value: 'Yes', shap: '+0.09', fill: 0.64,
                  color: AppColors.riskHigh),
              _SummaryShapBar(label: 'Ovarian Volume',
                  value: '12.4 mL', shap: '+0.07', fill: 0.50,
                  color: AppColors.riskHigh),
              _SummaryShapBar(label: 'BMI',
                  value: '22.8', shap: '-0.04', fill: 0.29,
                  color: AppColors.riskLow),
            ]),
          ),

          const SizedBox(height: 12),

          // ── Clinical Data section ──
          _CRExpandableSection(
            icon: Icons.description_outlined,
            title: 'Clinical Data',
            isOpen: _clinicalOpen,
            onToggle: () => setState(() => _clinicalOpen = !_clinicalOpen),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _CRSectionLabel('HORMONES'),
              const SizedBox(height: 10),
              Row(children: [
                Flexible(child: _LabCell(label: 'LH', value: '14.2 mIU/mL', flag: 'HIGH')),
                const SizedBox(width: 10),
                Flexible(child: _LabCell(label: 'FSH', value: '5.1 mIU/mL')),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Flexible(child: _LabCell(label: 'Total Testosterone', value: '68 ng/dL', flag: 'HIGH')),
                const SizedBox(width: 10),
                Flexible(child: _LabCell(label: 'Free Testosterone', value: '48 pg/mL', flag: 'HIGH')),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Flexible(child: _LabCell(label: 'DHEA-S', value: '320 μg/dL')),
                const Flexible(child: SizedBox.shrink()),
              ]),
              const SizedBox(height: 16),
              _CRSectionLabel('METABOLIC'),
              const SizedBox(height: 10),
              Row(children: [
                Flexible(child: _LabCell(label: 'Fasting Glucose', value: '98 mg/dL')),
                const SizedBox(width: 10),
                Flexible(child: _LabCell(label: 'Fasting Insulin', value: '18 mIU/L', flag: 'HIGH')),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Flexible(child: _LabCell(label: 'HOMA-IR', value: '4.4', flag: 'HIGH')),
                const SizedBox(width: 10),
                Flexible(child: _LabCell(label: 'HbA1c', value: '5.4%')),
              ]),
            ]),
          ),

          const SizedBox(height: 12),

          // ── Referral Template section ──
          _CRExpandableSection(
            icon: Icons.warning_amber_rounded,
            title: 'Referral Template',
            isOpen: _referralOpen,
            onToggle: () => setState(() => _referralOpen = !_referralOpen),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Text(
                'CLINICAL REFERRAL REQUEST\n\n'
                'Patient: Sarah Johnson\n'
                'DOB: March 15, 1996\n'
                'MRN: PT-2024-0892\n\n'
                'Referring Diagnosis: Suspected Polycystic Ovary Syndrome (PCOS)\n\n'
                'Clinical Indication:\n'
                'Patient presents with irregular menstrual cycles (45+ days), '
                'clinical signs of hyperandrogenism (mFG score: 12), and biochemical '
                'evidence of elevated androgens. AI-assisted risk assessment indicates '
                'high probability (0.68) of PCOS based on integrated multi-modal data analysis.\n\n'
                'Key Findings:\n'
                '- LH/FSH ratio: 2.8 (elevated)\n'
                '- Free testosterone: 48 pg/mL (elevated)\n'
                '- Evidence of insulin resistance (HOMA-IR: 4.4)\n'
                '- Ovarian volume: 12.4 mL on imaging\n\n'
                'Requested Consultation:\n'
                'Reproductive Endocrinology evaluation for PCOS diagnosis confirmation '
                'and management recommendations.\n\n'
                'Urgency: Within 2 weeks recommended\n\n'
                'Thank you for your consultation.',
                style: const TextStyle(
                  fontSize: 13, height: 1.6,
                  fontFamily: 'monospace',
                  color: Color(0xFF344054),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Bottom action bar ──
          Row(children: [
            Flexible(child: _SummaryActionBtn(icon: Icons.download_outlined, label: 'Download', onTap: () {})),
            const SizedBox(width: 10),
            Flexible(child: _SummaryActionBtn(icon: Icons.share_outlined, label: 'Share', onTap: () {})),
            const SizedBox(width: 10),
            Flexible(child: _SummaryActionBtn(icon: Icons.print_outlined, label: 'Print', onTap: () {})),
          ]),

          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.shield_outlined, size: 13,
                  color: AppColors.textMedium),
              const SizedBox(width: 8),
              Expanded(child: Text(
                'This report is generated by AI-MSHM for informational purposes. '
                'Risk scores are model predictions and should be interpreted alongside '
                'clinical judgment. This document does not constitute a medical '
                'diagnosis. Always consult qualified healthcare providers for diagnosis '
                'and treatment decisions.',
                style: AppTextStyles.smallText.copyWith(fontSize: 10),
              )),
            ]),
          ),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}

// ── Helper widgets for Clinical Referral ─────────────────────────────────────
class _CRSectionLabel extends StatelessWidget {
  final String text;
  const _CRSectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
    style: AppTextStyles.smallText.copyWith(
      fontWeight: FontWeight.w700, letterSpacing: 0.8,
      color: AppColors.textMedium));
}

class _CRExpandableSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isOpen;
  final VoidCallback onToggle;
  final Widget child;
  const _CRExpandableSection({required this.icon, required this.title,
    required this.isOpen, required this.onToggle, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 32;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(child: Text(title,
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 15))),
                Icon(isOpen ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                    color: AppColors.textMedium),
              ]),
            ),
          ),
          if (isOpen) ...[
            const Divider(height: 1, color: Color(0xFFF2F4F7)),
            SizedBox(
              width: screenWidth,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryShapBar extends StatelessWidget {
  final String label, value, shap;
  final double fill;
  final Color color;
  const _SummaryShapBar({required this.label, required this.value,
    required this.shap, required this.fill, required this.color});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: AppTextStyles.cardSubtitle
            .copyWith(color: AppColors.textDark, fontSize: 13)),
        Row(children: [
          Text(value, style: AppTextStyles.smallText),
          const SizedBox(width: 8),
          Text(shap, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
              color: color)),
        ]),
      ]),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: fill,
          minHeight: 6,
          backgroundColor: const Color(0xFFEEEEEE),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    ]),
  );
}

class _LabCell extends StatelessWidget {
  final String label, value;
  final String? flag;
  const _LabCell({required this.label, required this.value, this.flag});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyles.smallText.copyWith(fontSize: 11)),
      const SizedBox(height: 4),
      Row(children: [
        Text(value, style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
        if (flag != null) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.warningAmber.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(flag!,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                    color: AppColors.warningAmber)),
          ),
        ],
      ]),
    ]),
  );
}

class _SummaryInfoCell extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _SummaryInfoCell({required this.icon, required this.label,
    required this.value});

  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 16, color: AppColors.textMedium),
    const SizedBox(width: 8),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyles.smallText.copyWith(fontSize: 11)),
      Text(value, style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
    ]),
  ]);
}

class _SummaryActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SummaryActionBtn({required this.icon, required this.label,
    required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(children: [
        Icon(icon, size: 20, color: AppColors.textMedium),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.smallText.copyWith(fontSize: 12)),
      ]),
    ),
  );
}