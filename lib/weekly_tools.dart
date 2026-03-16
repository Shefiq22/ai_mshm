import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_textstyles.dart';
import 'routes.dart';

// ══════════════════════════════════════════════════════════════════════════════
// ── WeeklyToolsScreen — Landing screen ───────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class WeeklyToolsScreen extends StatelessWidget {
  const WeeklyToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── Teal gradient header ──────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 16, 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Weekly Tools',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                        Text('Complete your weekly health check-ins',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Body ──────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Info banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Weekly Check-ins',
                            style: AppTextStyles.cardTitle
                                .copyWith(fontSize: 15)),
                        const SizedBox(height: 6),
                        Text(
                          'Complete all five check-ins once a week. Each one only takes a minute '
                          'and helps us track how you are feeling over time.',
                          style: AppTextStyles.cardSubtitle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Hirsutism Score card
                  _AssessmentCard(
                    icon: Icons.content_cut_outlined,
                    iconBg: const Color(0xFF2AAFAA),
                    title: 'Hair Growth Check',
                    subtitle: 'Rate hair growth across different areas',
                    description:
                        'Score hair growth on 9 areas of your body. This helps us track changes linked to your hormonal health.',
                    frequency: 'Weekly',
                    lastDone: 'Last: 7 days ago',
                    isDue: true,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.mfgScreen),
                  ),
                  const SizedBox(height: 12),

                  // Mental Wellness card
                  _AssessmentCard(
                    icon: Icons.psychology_outlined,
                    iconBg: const Color(0xFF2AAFAA),
                    title: 'Mental Wellness',
                    subtitle: 'How have you been feeling emotionally?',
                    description:
                        'Answer 4 quick questions about your mood and anxiety over the past week.',
                    frequency: 'Weekly',
                    lastDone: 'Last: 7 days ago',
                    isDue: true,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.phq4Screen),
                  ),
                  const SizedBox(height: 12),

                  // Daily Affect Grid card
                  _AssessmentCard(
                    icon: Icons.grid_view_outlined,
                    iconBg: const Color(0xFF7B5EA7),
                    title: 'Mood Check',
                    subtitle: 'How are you feeling right now?',
                    description:
                        'Pick the emoji that best matches your energy and mood. Takes less than 10 seconds.',
                    frequency: 'Weekly',
                    lastDone: 'Last: 7 days ago',
                    isDue: true,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.affectGridScreen),
                  ),
                  const SizedBox(height: 12),

                  // Cognitive Load card
                  _AssessmentCard(
                    icon: Icons.lightbulb_outline,
                    iconBg: const Color(0xFF3A7BD5),
                    title: 'Focus & Memory',
                    subtitle: 'How sharp have you felt this week?',
                    description:
                        'Rate how well you have been able to concentrate and remember things over the past week.',
                    frequency: 'Weekly',
                    lastDone: 'Last: 7 days ago',
                    isDue: true,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.cognitiveLoadScreen),
                  ),
                  const SizedBox(height: 12),

                  // Sleep Satisfaction card
                  _AssessmentCard(
                    icon: Icons.bedtime_outlined,
                    iconBg: const Color(0xFF1A6B7A),
                    title: 'Sleep Quality',
                    subtitle: 'How well did you sleep last night?',
                    description:
                        'Rate the quality of your sleep. This helps us understand how rest is affecting your health.',
                    frequency: 'Weekly',
                    lastDone: 'Last: 7 days ago',
                    isDue: true,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.sleepSatisfactionScreen),
                  ),
                  const SizedBox(height: 16),

                  // Progress card — updated to 0/5
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("This Week's Progress",
                                style: AppTextStyles.cardTitle
                                    .copyWith(fontSize: 14)),
                            Text('0/5 completed',
                                style: AppTextStyles.cardSubtitle),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(5, (i) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: i < 4 ? 6 : 0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: const LinearProgressIndicator(
                                  value: 0,
                                  minHeight: 6,
                                  backgroundColor: AppColors.progressBg,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.progressFill),
                                ),
                              ),
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Assessment card widget ────────────────────────────────────────────────────
class _AssessmentCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title, subtitle, description, frequency, lastDone;
  final bool isDue;
  final VoidCallback onTap;

  const _AssessmentCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.frequency,
    required this.lastDone,
    required this.isDue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: AppTextStyles.cardTitle
                              .copyWith(fontSize: 15)),
                      const SizedBox(width: 8),
                      if (isDue)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warningLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.warningAmber
                                    .withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.access_time,
                                  size: 11,
                                  color: AppColors.warningAmber),
                              const SizedBox(width: 3),
                              Text('Due',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.warningAmber)),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.cardSubtitle),
                  const SizedBox(height: 6),
                  Text(description,
                      style: AppTextStyles.cardSubtitle
                          .copyWith(color: AppColors.textMedium)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 12, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(frequency,
                          style: AppTextStyles.smallText
                              .copyWith(color: AppColors.textLight)),
                      const SizedBox(width: 12),
                      Text(lastDone,
                          style: AppTextStyles.smallText
                              .copyWith(color: AppColors.textLight)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.textMedium),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── MfgScreen — mFG Hirsutism Score ──────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class MfgScreen extends StatefulWidget {
  const MfgScreen({super.key});
  @override
  State<MfgScreen> createState() => _MfgScreenState();
}

class _MfgScreenState extends State<MfgScreen> {
  bool _showResults = false;
  final Map<int, int> _scores = {};

  static const _zones = [
    _Zone('Upper Lip', 'Above the lip, below the nose', '👄'),
    _Zone('Chin', 'Chin and jawline area', '👄'),
    _Zone('Chest', 'Between and around the breasts', '🫁'),
    _Zone('Upper Back', 'Upper back and shoulders', '🔙'),
    _Zone('Lower Back', 'Lower back above buttocks', '⬇️'),
    _Zone('Upper Abdomen', 'Above the navel', '⬆️'),
    _Zone('Lower Abdomen', 'Below the navel', '⬇️'),
    _Zone('Upper Arm', 'Shoulders to elbows', '💪'),
    _Zone('Thigh', 'Upper inner and outer thighs', '🦵'),
  ];

  int get _total => _scores.values.fold(0, (a, b) => a + b);

  String get _interpretation {
    if (_total < 8) return 'Normal';
    if (_total < 15) return 'Mild';
    if (_total < 20) return 'Moderate';
    return 'Severe';
  }

  Color get _interpretationColor {
    if (_total < 8) return AppColors.riskLow;
    if (_total < 15) return AppColors.warningAmber;
    return AppColors.riskHigh;
  }

  void _openZoneSheet(int index) {
    int tempScore = _scores[index] ?? 0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.fromLTRB(
              24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: AppColors.cardBorder,
                          borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text(_zones[index].name,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 17)),
              const SizedBox(height: 4),
              Text(_zones[index].description,
                  style: AppTextStyles.cardSubtitle),
              const SizedBox(height: 20),
              Text('Score (0 = no hair, 4 = dense coverage)',
                  style: AppTextStyles.inputLabel),
              const SizedBox(height: 12),
              Row(
                  children: List.generate(
                      5,
                      (s) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: s < 4 ? 8 : 0),
                              child: GestureDetector(
                                onTap: () => setModal(() => tempScore = s),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: tempScore == s
                                        ? AppColors.primary
                                        : AppColors.surfaceWhite,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: tempScore == s
                                            ? AppColors.primary
                                            : AppColors.cardBorder),
                                  ),
                                  child: Text('$s',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: tempScore == s
                                              ? Colors.white
                                              : AppColors.textDark)),
                                ),
                              ),
                            ),
                          ))),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _scores[index] = tempScore);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, size: 20, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Hirsutism Score',
                style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            Text('Modified Ferriman-Gallwey (mFG) Assessment',
                style: TextStyle(fontSize: 12, color: AppColors.textMedium)),          ],
        ),
      ),
      body: _showResults ? _buildResults() : _buildAssessment(),
    );
  }

  Widget _buildAssessment() {
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('RUNNING TOTAL',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textMedium,
                                letterSpacing: 0.8)),
                        const SizedBox(height: 4),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: '$_total',
                              style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark)),
                          const TextSpan(
                              text: ' / 36',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textMedium)),
                        ])),
                      ]),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                        color: _interpretationColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(_interpretation,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _interpretationColor)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.primary.withOpacity(0.15))),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(
                            'Rate each body zone from 0 (no terminal hair) to 4 '
                            '(dense/dark coverage). A total score ≥ 8 suggests '
                            'clinical hirsutism.',
                            style: AppTextStyles.cardSubtitle)),
                  ]),
            ),
            const SizedBox(height: 12),
            ..._zones.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => _openZoneSheet(e.key),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                          color: AppColors.surfaceWhite,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.cardBorder)),
                      child: Row(children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(e.value.emoji,
                                  style: const TextStyle(fontSize: 20))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.value.name,
                                style: AppTextStyles.cardTitle
                                    .copyWith(fontSize: 14)),
                            const SizedBox(height: 2),
                            Text(e.value.description,
                                style: AppTextStyles.cardSubtitle),
                          ],
                        )),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              color: AppColors.background,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: AppColors.cardBorder)),
                          child: Center(
                              child: Text('${_scores[e.key] ?? 0}',
                                  style: AppTextStyles.cardTitle
                                      .copyWith(fontSize: 13))),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.chevron_right,
                            size: 18, color: AppColors.textMedium),
                      ]),
                    ),
                  ),
                )),
          ]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _showResults = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('View Results',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    ]);
  }

  Widget _buildResults() {
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TOTAL SCORE',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textMedium,
                                letterSpacing: 0.8)),
                        const SizedBox(height: 4),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: '$_total',
                              style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark)),
                          const TextSpan(
                              text: ' / 36',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textMedium)),
                        ])),
                      ]),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                        color: _interpretationColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(_interpretation,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _interpretationColor)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder)),
              child: Column(children: [
                Text('$_total',
                    style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                        height: 1.0)),
                const SizedBox(height: 4),
                Text('out of 36', style: AppTextStyles.cardSubtitle),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                      color: _interpretationColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(_interpretation,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _interpretationColor)),
                ),
                const SizedBox(height: 20),
                ..._zones.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(children: [
                        Expanded(
                            child: Text(e.value.name,
                                style: AppTextStyles.cardSubtitle
                                    .copyWith(color: AppColors.textDark))),
                        SizedBox(
                          width: 120,
                          child: LinearProgressIndicator(
                            value: (_scores[e.key] ?? 0) / 4,
                            minHeight: 4,
                            backgroundColor: AppColors.cardBorder,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                (_scores[e.key] ?? 0) == 0
                                    ? AppColors.cardBorder
                                    : AppColors.riskHigh),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 16,
                          child: Text('${_scores[e.key] ?? 0}',
                              style: AppTextStyles.cardTitle
                                  .copyWith(fontSize: 13),
                              textAlign: TextAlign.right),
                        ),
                      ]),
                    )),
              ]),
            ),
          ]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => setState(() => _showResults = false),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.cardBorder),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Edit Scores',
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 15)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save & Continue',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15)),
            ),
          ),
        ]),
      ),
    ]);
  }
}

class _Zone {
  final String name, description, emoji;
  const _Zone(this.name, this.description, this.emoji);
}

// ══════════════════════════════════════════════════════════════════════════════
// ── Phq4Screen — PHQ-4 with depression ≥3 trigger fix ────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class Phq4Screen extends StatefulWidget {
  const Phq4Screen({super.key});
  @override
  State<Phq4Screen> createState() => _Phq4ScreenState();
}

class _Phq4ScreenState extends State<Phq4Screen> {
  final List<int?> _answers = [null, null, null, null];
  bool _showResults = false;

  static const _gad2 = [
    'In the last week, how often have you felt nervous, anxious, or on edge?',
    'In the last week, how often have you been unable to stop or control worrying?',
  ];

  static const _phq2 = [
    'In the last week, how often have you had little interest or pleasure in doing things?',
    'In the last week, how often have you felt down, depressed, or hopeless?',
  ];

  static const _options = [
    '0  —  Not at all',
    '1  —  Several days',
    '2  —  More than half the days',
    '3  —  Nearly every day',
  ];

  int get _total => _answers.fold(0, (s, v) => s + (v ?? 0));
  int get _anxietyScore => (_answers[0] ?? 0) + (_answers[1] ?? 0);
  int get _depressionScore => (_answers[2] ?? 0) + (_answers[3] ?? 0);
  bool get _complete => _answers.every((a) => a != null);

  // FIX: Total score ≥6 = moderate-to-severe (spec: "Score ≥6 flags
  // moderate-to-severe combined burden")
  String get _interpretation {
    if (_total <= 2) return 'Normal';
    if (_total <= 5) return 'Mild';
    if (_total <= 8) return 'Moderate';
    return 'Severe';
  }

  Color get _interpretationColor {
    if (_total <= 2) return AppColors.riskLow;
    if (_total <= 5) return AppColors.warningAmber;
    return AppColors.riskHigh;
  }

  String _subscoreLabel(int score) {
    if (score <= 1) return 'Normal';
    if (score <= 2) return 'Mild';
    return 'Elevated';
  }

  Color _subscoreColor(int score) {
    if (score <= 1) return AppColors.riskLow;
    if (score <= 2) return AppColors.warningAmber;
    return AppColors.riskHigh;
  }

  // FIX: Depression subscale ≥3 triggers mental health support recommendation
  bool get _depressionTrigger => _depressionScore >= 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 16, 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Mental Wellness',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                        Text('How have you been feeling this week?',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _showResults ? _buildResults() : _buildQuestions(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestions() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline,
                          size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.cardSubtitle,
                            children: [
                              const TextSpan(text: 'Over the '),
                              TextSpan(
                                  text: 'last week',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textDark)),
                              const TextSpan(
                                  text:
                                      ', how often have you been bothered by the following problems? '
                                      'Score ≥3 on either subscale = positive screen.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _SectionLabel(
                    label: 'GAD-2 — Anxiety',
                    color: const Color(0xFF2A7FD4)),
                const SizedBox(height: 12),
                ..._gad2.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _QuestionCard(
                        question: e.value,
                        options: _options,
                        selected: _answers[e.key],
                        onSelect: (v) =>
                            setState(() => _answers[e.key] = v),
                      ),
                    )),
                const SizedBox(height: 8),
                _SectionLabel(
                    label: 'PHQ-2 — Depression',
                    color: const Color(0xFF8B45C8)),
                const SizedBox(height: 12),
                ..._phq2.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _QuestionCard(
                        question: e.value,
                        options: _options,
                        selected: _answers[e.key + 2],
                        onSelect: (v) =>
                            setState(() => _answers[e.key + 2] = v),
                      ),
                    )),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _complete
                  ? () => setState(() => _showResults = true)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.progressBg,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'View Results',
                style: TextStyle(
                    color: _complete ? Colors.white : AppColors.textLight,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Total score card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    children: [
                      Text('$_total',
                          style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                              height: 1.0)),
                      const SizedBox(height: 4),
                      Text('out of 12', style: AppTextStyles.cardSubtitle),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                            color: _interpretationColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(_interpretation,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _interpretationColor)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Subscores
                Row(children: [
                  Expanded(
                    child: _SubScoreCard(
                      label: 'GAD-2 Anxiety',
                      labelColor: const Color(0xFF2A7FD4),
                      score: _anxietyScore,
                      max: 6,
                      statusLabel: _subscoreLabel(_anxietyScore),
                      statusColor: _subscoreColor(_anxietyScore),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SubScoreCard(
                      label: 'PHQ-2 Depression',
                      labelColor: const Color(0xFF8B45C8),
                      score: _depressionScore,
                      max: 6,
                      statusLabel: _subscoreLabel(_depressionScore),
                      statusColor: _subscoreColor(_depressionScore),
                    ),
                  ),
                ]),
                const SizedBox(height: 14),

                // FIX: Depression ≥3 mental health support recommendation banner
                // Spec: "A PHQ-4 Depression subscale score ≥3 concurrently with
                // a high PCOS Risk Score triggers an additional mental health
                // support resource recommendation in the dashboard output."
                if (_depressionTrigger) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B45C8).withOpacity(0.07),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFF8B45C8).withOpacity(0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B45C8).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.favorite_border,
                              color: Color(0xFF8B45C8), size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Mental Health Support Recommended',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF8B45C8))),
                              SizedBox(height: 4),
                              Text(
                                'Your depression subscale score is elevated (≥3). '
                                'This will be flagged alongside your PCOS risk score. '
                                'Speaking with a mental health professional may be beneficial.',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMedium),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Severity scale bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Normal',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMedium)),
                          Text('Mild',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMedium)),
                          Text('Moderate',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMedium)),
                          Text('Severe',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMedium)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              height: 10,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.riskLow,
                                    AppColors.warningAmber,
                                    AppColors.riskHigh,
                                    AppColors.riskCritical,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: (_total / 12) *
                                (MediaQuery.of(context).size.width - 64),
                            top: -2,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.textDark, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() {
                  _showResults = false;
                  _answers.fillRange(0, 4, null);
                }),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.cardBorder),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Edit Answers',
                    style: TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save & Continue',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── AffectGridScreen — 2D Arousal × Valence (3×3 emoji matrix) ───────────────
// ══════════════════════════════════════════════════════════════════════════════
class AffectGridScreen extends StatefulWidget {
  const AffectGridScreen({super.key});
  @override
  State<AffectGridScreen> createState() => _AffectGridScreenState();
}

class _AffectGridScreenState extends State<AffectGridScreen> {
  // Selected cell: row = arousal (0=low,1=mid,2=high), col = valence (0=neg,1=neu,2=pos)
  int? _selectedRow;
  int? _selectedCol;
  bool _showResults = false;

  // Arousal axis: high energy (top) → low energy (bottom)
  static const _arousalLabels = ['High energy', 'Medium energy', 'Low energy'];
  // Valence axis: not good (left) → good (right)
  static const _valenceLabels = ['Not good', 'Neutral', 'Good'];

  // 3×3 emoji matrix [arousal][valence]
  static const _emojis = [
    ['😤', '😰', '😄'], // High arousal: angry / anxious / excited
    ['😔', '😐', '🙂'], // Mid arousal: sad / neutral / content
    ['😞', '😴', '😌'], // Low arousal: depressed / fatigued / calm
  ];

  static const _labels = [
    ['Angry', 'Anxious', 'Excited'],
    ['Sad', 'Neutral', 'Content'],
    ['Depressed', 'Fatigued', 'Calm'],
  ];

  bool get _complete => _selectedRow != null && _selectedCol != null;

  String get _selectedEmoji =>
      _complete ? _emojis[_selectedRow!][_selectedCol!] : '';
  String get _selectedLabel =>
      _complete ? _labels[_selectedRow!][_selectedCol!] : '';
  String get _selectedArousal =>
      _complete ? _arousalLabels[_selectedRow!] : '';
  String get _selectedValence =>
      _complete ? _valenceLabels[_selectedCol!] : '';

  // Encoded as arousal (0–2) and valence (0–2) for ML feature storage
  int get _arousalValue => _selectedRow ?? 0;
  int get _valenceValue => _selectedCol ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7B5EA7), Color(0xFF5A3E8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 16, 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Mood Check',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                        Text('How are you feeling right now?',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _showResults ? _buildResults() : _buildGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B5EA7).withOpacity(0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF7B5EA7).withOpacity(0.15)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 16, color: Color(0xFF7B5EA7)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tap the emoji that best matches how you feel right now. '
                          'Think about your energy level and whether your mood feels positive or negative.',
                          style: AppTextStyles.cardSubtitle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Valence axis labels (top)
                Padding(
                  padding: const EdgeInsets.only(left: 56),
                  child: Row(
                    children: _valenceLabels
                        .map((l) => Expanded(
                              child: Text(l,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textMedium)),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8),

                // Grid rows
                ...List.generate(3, (row) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        // Arousal label
                        SizedBox(
                          width: 48,
                          child: Text(_arousalLabels[row],
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textMedium)),
                        ),
                        const SizedBox(width: 8),
                        // 3 cells
                        ...List.generate(3, (col) {
                          final isSelected =
                              _selectedRow == row && _selectedCol == col;
                          return Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: col < 2 ? 8 : 0),
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  _selectedRow = row;
                                  _selectedCol = col;
                                }),
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF7B5EA7)
                                            .withOpacity(0.1)
                                        : AppColors.surfaceWhite,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF7B5EA7)
                                          : AppColors.cardBorder,
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(_emojis[row][col],
                                          style: const TextStyle(
                                              fontSize: 24)),
                                      const SizedBox(height: 4),
                                      Text(_labels[row][col],
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                              color: isSelected
                                                  ? const Color(0xFF7B5EA7)
                                                  : AppColors.textMedium)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }),

                if (_complete) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B5EA7).withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFF7B5EA7).withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Text(_selectedEmoji,
                            style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_selectedLabel,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF7B5EA7))),
                            Text(
                                'Arousal: $_selectedArousal · Valence: $_selectedValence',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMedium)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _complete
                  ? () => setState(() => _showResults = true)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B5EA7),
                disabledBackgroundColor: AppColors.progressBg,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('View Results',
                  style: TextStyle(
                      color: _complete ? Colors.white : AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    children: [
                      Text(_selectedEmoji,
                          style: const TextStyle(fontSize: 64)),
                      const SizedBox(height: 8),
                      Text(_selectedLabel,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF7B5EA7))),
                      const SizedBox(height: 8),
                      Text(
                          'Energy: $_selectedArousal · Mood: $_selectedValence',
                          style: AppTextStyles.cardSubtitle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _showResults = false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.cardBorder),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Edit',
                    style: TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B5EA7),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save & Continue',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── CognitiveLoadScreen — Attention & Memory Self-Rating (1–5) ───────────────
// ══════════════════════════════════════════════════════════════════════════════
class CognitiveLoadScreen extends StatefulWidget {
  const CognitiveLoadScreen({super.key});
  @override
  State<CognitiveLoadScreen> createState() => _CognitiveLoadScreenState();
}

class _CognitiveLoadScreenState extends State<CognitiveLoadScreen> {
  int? _attentionRating;
  int? _memoryRating;
  bool _showResults = false;

  bool get _complete => _attentionRating != null && _memoryRating != null;

  static const _ratingLabels = ['Very Poor', 'Poor', 'Moderate', 'Good', 'Excellent'];
  static const _ratingEmojis = ['😵', '😔', '😐', '🙂', '😊'];

  String _label(int? v) => v != null ? _ratingLabels[v - 1] : '—';
  String _emoji(int? v) => v != null ? _ratingEmojis[v - 1] : '';

  // Average of both ratings stored as cognitive_load_score (1–5)
  double get _cognitiveLoadScore =>
      ((_attentionRating ?? 0) + (_memoryRating ?? 0)) / 2;

  Widget _buildRatingRow(String label, int? current, ValueChanged<int> onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark)),
        const SizedBox(height: 10),
        Row(
          children: List.generate(5, (i) {
            final val = i + 1;
            final isSelected = current == val;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < 4 ? 8 : 0),
                child: GestureDetector(
                  onTap: () => onSelect(val),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.cardBorder,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(children: [
                      Text(_ratingEmojis[i],
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 4),
                      Text('$val',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textDark)),
                    ]),
                  ),
                ),
              ),
            );
          }),
        ),
        if (current != null) ...[
          const SizedBox(height: 6),
          Text(_ratingLabels[current - 1],
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary)),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3A7BD5), Color(0xFF1A5BB5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 16, 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Cognitive Load',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                        Text('Focus & memory check',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _showResults ? _buildResults() : _buildRatings(),
          ),
        ],
      ),
    );
  }

  Widget _buildRatings() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A7BD5).withOpacity(0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF3A7BD5).withOpacity(0.15)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 16, color: Color(0xFF3A7BD5)),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Rate how well you have been able to focus and remember things '
                          'over the past week. There are no right or wrong answers.',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textMedium),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: _buildRatingRow(
                    'Attention — How well were you able to focus?',
                    _attentionRating,
                    (v) => setState(() => _attentionRating = v),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: _buildRatingRow(
                    'Memory — How well were you able to remember things?',
                    _memoryRating,
                    (v) => setState(() => _memoryRating = v),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _complete
                  ? () => setState(() => _showResults = true)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3A7BD5),
                disabledBackgroundColor: AppColors.progressBg,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('View Results',
                  style: TextStyle(
                      color: _complete ? Colors.white : AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(children: [
                  Expanded(
                    child: _SimpleScoreCard(
                      label: 'Attention',
                      emoji: _emoji(_attentionRating),
                      score: _attentionRating ?? 0,
                      max: 5,
                      sublabel: _label(_attentionRating),
                      color: const Color(0xFF3A7BD5),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SimpleScoreCard(
                      label: 'Memory',
                      emoji: _emoji(_memoryRating),
                      score: _memoryRating ?? 0,
                      max: 5,
                      sublabel: _label(_memoryRating),
                      color: const Color(0xFF3A7BD5),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _showResults = false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.cardBorder),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Edit',
                    style: TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A7BD5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save & Continue',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── SleepSatisfactionScreen — Post-Sleep Quality Rating (1–5) ────────────────
// ══════════════════════════════════════════════════════════════════════════════
class SleepSatisfactionScreen extends StatefulWidget {
  const SleepSatisfactionScreen({super.key});
  @override
  State<SleepSatisfactionScreen> createState() =>
      _SleepSatisfactionScreenState();
}

class _SleepSatisfactionScreenState extends State<SleepSatisfactionScreen> {
  int? _rating;
  bool _showResults = false;

  static const _ratingLabels = ['Very Poor', 'Poor', 'Fair', 'Good', 'Excellent'];
  static const _ratingEmojis = ['😵', '😔', '😐', '🙂', '😴'];
  static const _ratingDescriptions = [
    'Barely slept, feel exhausted',
    'Restless night, not refreshed',
    'Some rest but could be better',
    'Good sleep, feeling rested',
    'Excellent sleep, fully refreshed',
  ];

  bool get _complete => _rating != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A6B7A), Color(0xFF0D4A55)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 16, 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Sleep Quality',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                        Text('Rate last night\'s sleep',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _showResults ? _buildResults() : _buildRating(),
          ),
        ],
      ),
    );
  }

  Widget _buildRating() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A6B7A).withOpacity(0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF1A6B7A).withOpacity(0.15)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.info_outline,
                          size: 16, color: Color(0xFF1A6B7A)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'How would you rate the quality of last night\'s sleep? '
                          'This cross-validates passive sleep tracking data.',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textMedium),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text('Rate your sleep quality',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                const SizedBox(height: 16),

                // 5 rating cards stacked
                ...List.generate(5, (i) {
                  final val = i + 1;
                  final isSelected = _rating == val;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _rating = val),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1A6B7A).withOpacity(0.07)
                              : AppColors.surfaceWhite,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF1A6B7A)
                                : AppColors.cardBorder,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(children: [
                          Text(_ratingEmojis[i],
                              style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$val — ${_ratingLabels[i]}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? const Color(0xFF1A6B7A)
                                            : AppColors.textDark)),
                                const SizedBox(height: 2),
                                Text(_ratingDescriptions[i],
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textMedium)),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle,
                                color: Color(0xFF1A6B7A), size: 20),
                        ]),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _complete
                  ? () => setState(() => _showResults = true)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A6B7A),
                disabledBackgroundColor: AppColors.progressBg,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('View Results',
                  style: TextStyle(
                      color: _complete ? Colors.white : AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    children: [
                      Text(_ratingEmojis[(_rating ?? 1) - 1],
                          style: const TextStyle(fontSize: 64)),
                      const SizedBox(height: 8),
                      Text('${_rating ?? 0} / 5',
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                              height: 1.0)),
                      const SizedBox(height: 4),
                      Text(_ratingLabels[(_rating ?? 1) - 1],
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A6B7A))),
                      const SizedBox(height: 4),
                      Text(_ratingDescriptions[(_rating ?? 1) - 1],
                          style: AppTextStyles.cardSubtitle,
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _showResults = false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.cardBorder),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Edit',
                    style: TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6B7A),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save & Continue',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── Shared small widgets ──────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Text(label,
      style: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w700, color: color));
}

class _QuestionCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final int? selected;
  final ValueChanged<int> onSelect;

  const _QuestionCard({
    required this.question,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: selected != null
                ? AppColors.primary.withOpacity(0.3)
                : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question,
              style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
          const SizedBox(height: 14),
          Column(
            children: [
              Row(children: [
                Expanded(child: _OptionTile(label: options[0], value: 0, selected: selected, onTap: onSelect)),
                const SizedBox(width: 8),
                Expanded(child: _OptionTile(label: options[1], value: 1, selected: selected, onTap: onSelect)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: _OptionTile(label: options[2], value: 2, selected: selected, onTap: onSelect)),
                const SizedBox(width: 8),
                Expanded(child: _OptionTile(label: options[3], value: 3, selected: selected, onTap: onSelect)),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final int value;
  final int? selected;
  final ValueChanged<int> onTap;

  const _OptionTile(
      {required this.label,
      required this.value,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.cardBorder,
              width: isSelected ? 1.5 : 1),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textDark)),
      ),
    );
  }
}

class _SubScoreCard extends StatelessWidget {
  final String label, statusLabel;
  final Color labelColor, statusColor;
  final int score, max;

  const _SubScoreCard({
    required this.label,
    required this.labelColor,
    required this.score,
    required this.max,
    required this.statusLabel,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder)),
        child: Column(children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: labelColor)),
          const SizedBox(height: 8),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: '$score',
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark)),
            TextSpan(
                text: ' / $max',
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textMedium)),
          ])),
          const SizedBox(height: 6),
          Text(statusLabel,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: statusColor)),
        ]),
      );
}

class _SimpleScoreCard extends StatelessWidget {
  final String label, emoji, sublabel;
  final int score, max;
  final Color color;

  const _SimpleScoreCard({
    required this.label,
    required this.emoji,
    required this.score,
    required this.max,
    required this.sublabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder)),
        child: Column(children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color)),
          const SizedBox(height: 8),
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: '$score',
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark)),
            TextSpan(
                text: ' / $max',
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textMedium)),
          ])),
          const SizedBox(height: 4),
          Text(sublabel,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ]),
      );
}

// Shared ML variable row used across all result screens
class _MLRow extends StatelessWidget {
  final String label, value;
  const _MLRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: AppColors.textMedium)),
            ),
            const SizedBox(width: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark)),
          ],
        ),
      );
}