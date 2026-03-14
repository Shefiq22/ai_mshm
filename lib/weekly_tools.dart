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
                        Text('Clinical assessments due this week',
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
                        Text('Weekly Clinical Assessments',
                            style: AppTextStyles.cardTitle
                                .copyWith(fontSize: 15)),
                        const SizedBox(height: 6),
                        Text(
                          'Complete both assessments once per week to track your symptoms over time. '
                          'Your responses help build a longitudinal picture for accurate PCOS risk scoring.',
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
                    title: 'Hirsutism Score',
                    subtitle: 'Modified Ferriman-Gallwey (mFG)',
                    description:
                        'Quantify hair growth patterns across 8 body zones to assess hyperandrogenism.',
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
                    subtitle: 'PHQ-4 Assessment',
                    description:
                        'Ultra-brief validated screening for anxiety (GAD-2) and depression (PHQ-2).',
                    frequency: 'Weekly',
                    lastDone: 'Last: 7 days ago',
                    isDue: true,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.phq4Screen),
                  ),
                  const SizedBox(height: 16),

                  // Progress card
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
                            Text('0/2 completed',
                                style: AppTextStyles.cardSubtitle),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
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
                            const SizedBox(width: 8),
                            Expanded(
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
                          ],
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
            // Icon
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

            // Text content
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
                style: TextStyle(fontSize: 12, color: AppColors.textMedium)),
          ],
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
// ── Phq4Screen — PHQ-4 matching screenshots ───────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class Phq4Screen extends StatefulWidget {
  const Phq4Screen({super.key});
  @override
  State<Phq4Screen> createState() => _Phq4ScreenState();
}

class _Phq4ScreenState extends State<Phq4Screen> {
  final List<int?> _answers = [null, null, null, null];
  bool _showResults = false;

  // GAD-2 questions (anxiety)
  static const _gad2 = [
    'In the last week, how often have you felt nervous, anxious, or on edge?',
    'In the last week, how often have you been unable to stop or control worrying?',
  ];

  // PHQ-2 questions (depression)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── Teal header ───────────────────────────────────────────────
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
                        Text('PHQ-4 Psychological Assessment',
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
                // Info banner
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

                // GAD-2 section
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

                // PHQ-2 section
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

        // View Results button
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
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
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
                                (MediaQuery.of(context).size.width -
                                    64),
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

        // Action buttons
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

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Text(label,
      style: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w700, color: color));
}

// ── Question card with 2×2 grid options ──────────────────────────────────────
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
          // 2×2 grid
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
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color:
                  isSelected ? AppColors.primary : AppColors.cardBorder,
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

// ── Sub-score card ────────────────────────────────────────────────────────────
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