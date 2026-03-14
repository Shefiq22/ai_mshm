import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'app_colors.dart';
import 'app_textstyles.dart';
import 'routes.dart';

// ══════════════════════════════════════════════════════════════════════════════
// ── MorningCheckinScreen ──────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class MorningCheckinScreen extends StatefulWidget {
  const MorningCheckinScreen({super.key});
  @override
  State<MorningCheckinScreen> createState() => _MorningCheckinState();
}

class _MorningCheckinState extends State<MorningCheckinScreen> {
  double _fatigue = 0;
  double _pelvicPressure = 0;

  Color _scoreColor(double v) {
    if (v <= 2) return AppColors.riskLow;
    if (v <= 5) return AppColors.warningAmber;
    return AppColors.riskHigh;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new,
                      size: 14, color: AppColors.textDark),
                  label: const Text('Back',
                      style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ),
                Row(children: [
                  Container(
                      width: 8, height: 8,
                      decoration: const BoxDecoration(
                          color: Colors.orange, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  const Text('Morning Check-In',
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMedium,
                          fontWeight: FontWeight.w500)),
                ]),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.wb_sunny_outlined,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                const Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('How are you feeling?',
                      style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  SizedBox(height: 2),
                  Text('Rate your symptoms this morning',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textMedium)),
                ]),
              ]),
              const SizedBox(height: 32),
              _CheckinSlider(
                title: 'Physical Fatigue',
                subtitle: 'How tired or physically drained do you feel?',
                value: _fatigue,
                minLabel: 'Energized',
                maxLabel: 'Exhausted',
                scoreColor: _scoreColor(_fatigue),
                onChanged: (v) => setState(() => _fatigue = v),
              ),
              const SizedBox(height: 28),
              _CheckinSlider(
                title: 'Pelvic Pressure',
                subtitle: 'Any lower abdominal pressure or discomfort?',
                value: _pelvicPressure,
                minLabel: 'No pressure',
                maxLabel: 'Intense',
                scoreColor: _scoreColor(_pelvicPressure),
                onChanged: (v) => setState(() => _pelvicPressure = v),
              ),
              const SizedBox(height: 36),
            ]),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              20, 8, 20, MediaQuery.of(context).padding.bottom + 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HrvCaptureScreen(
                      label: 'Morning Check-In',
                      labelColor: Colors.orange))),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Complete Morning Check-In',
                  style: TextStyle(color: Colors.white, fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── AfternoonCheckinScreen ────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class AfternoonCheckinScreen extends StatefulWidget {
  const AfternoonCheckinScreen({super.key});
  @override
  State<AfternoonCheckinScreen> createState() => _AfternoonCheckinState();
}

class _AfternoonCheckinState extends State<AfternoonCheckinScreen> {
  double _fatigue = 0;
  double _pelvicPressure = 0;

  Color _scoreColor(double v) {
    if (v <= 2) return AppColors.riskLow;
    if (v <= 5) return AppColors.warningAmber;
    return AppColors.riskHigh;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new,
                      size: 14, color: AppColors.textDark),
                  label: const Text('Back',
                      style: TextStyle(color: AppColors.textDark,
                          fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                Row(children: [
                  Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                          color: Colors.amber[700], shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  const Text('Afternoon Check-In',
                      style: TextStyle(fontSize: 13,
                          color: AppColors.textMedium,
                          fontWeight: FontWeight.w500)),
                ]),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                      color: Colors.amber[700],
                      borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.wb_cloudy_outlined,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                const Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('How are you feeling?',
                      style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  SizedBox(height: 2),
                  Text('Rate your symptoms this afternoon',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textMedium)),
                ]),
              ]),
              const SizedBox(height: 32),
              _CheckinSlider(
                title: 'Physical Fatigue',
                subtitle: 'How tired or physically drained do you feel?',
                value: _fatigue,
                minLabel: 'Energized',
                maxLabel: 'Exhausted',
                scoreColor: _scoreColor(_fatigue),
                onChanged: (v) => setState(() => _fatigue = v),
              ),
              const SizedBox(height: 28),
              _CheckinSlider(
                title: 'Pelvic Pressure',
                subtitle: 'Any lower abdominal pressure or discomfort?',
                value: _pelvicPressure,
                minLabel: 'No pressure',
                maxLabel: 'Intense',
                scoreColor: _scoreColor(_pelvicPressure),
                onChanged: (v) => setState(() => _pelvicPressure = v),
              ),
              const SizedBox(height: 36),
            ]),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              20, 8, 20, MediaQuery.of(context).padding.bottom + 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => HrvCaptureScreen(
                      label: 'Afternoon Check-In',
                      labelColor: Colors.amber[700]!))),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Complete Afternoon Check-In',
                  style: TextStyle(color: Colors.white, fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── EveningCheckinScreen ──────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class EveningCheckinScreen extends StatefulWidget {
  const EveningCheckinScreen({super.key});
  @override
  State<EveningCheckinScreen> createState() => _EveningCheckinState();
}

class _EveningCheckinState extends State<EveningCheckinScreen> {
  double _breastSoreness = 0;
  double _acneSeverity = 0;

  // Breast detail
  String? _mastalgiaSide;
  String? _mastalgiaQuality;

  // Per-breast-side sliders — shown when overall soreness > 0
  double _breastLeft = 0;
  double _breastRight = 0;

  // Acne area chips + per-area severity sliders
  final Set<String> _acneAreas = {};
  final Map<String, double> _acneAreaSeverity = {
    'Face': 0,
    'Chest': 0,
    'Back': 0,
  };

  final TextEditingController _bloatingCtrl = TextEditingController();

  // Simulated values carried from morning/afternoon
  final double _fatigue = 3;
  final double _pelvicPressure = 1;

  @override
  void dispose() {
    _bloatingCtrl.dispose();
    super.dispose();
  }

  Color _scoreColor(double v) {
    if (v <= 2) return AppColors.riskLow;
    if (v <= 5) return AppColors.warningAmber;
    return AppColors.riskHigh;
  }

  Widget _sectionCard({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (title.isNotEmpty)
          Text(title.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textLight,
                letterSpacing: 0.8,
              )),
        if (title.isNotEmpty && subtitle.isNotEmpty) const SizedBox(height: 4),
        if (subtitle.isNotEmpty)
          Text(subtitle, style: AppTextStyles.cardSubtitle),
        if (title.isNotEmpty || subtitle.isNotEmpty) const SizedBox(height: 14),
        ...children,
      ]),
    );
  }

  Widget _toggleButton(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.cardBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? AppColors.primary : AppColors.textDark,
            )),
      ),
    );
  }

  // ── Acne area chip ──────────────────────────────────────────────────────────
  Widget _acneAreaChip(String area) {
    final selected = _acneAreas.contains(area);
    return GestureDetector(
      onTap: () => setState(() {
        if (selected) {
          _acneAreas.remove(area);
          _acneAreaSeverity[area] = 0;
        } else {
          _acneAreas.add(area);
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.cardBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selected) ...[
              Container(
                width: 7, height: 7,
                decoration: const BoxDecoration(
                    color: AppColors.primary, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
            ],
            Text(area,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? AppColors.primary : AppColors.textDark,
                )),
          ],
        ),
      ),
    );
  }

  // ── Per-area acne severity slider ───────────────────────────────────────────
  Widget _areaSlider(String area) {
    final value = _acneAreaSeverity[area]!;
    final color = _scoreColor(value);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Container(
            width: 7, height: 7,
            decoration: BoxDecoration(
                color: AppColors.primary, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text('$area severity',
              style: AppTextStyles.cardSubtitle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
        ]),
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: '${value.round()}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color)),
          const TextSpan(
              text: '/10',
              style: TextStyle(
                  fontSize: 12, color: AppColors.textMedium)),
        ])),
      ]),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 4,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          activeTrackColor: color,
          inactiveTrackColor: AppColors.cardBorder,
          thumbColor: color,
          overlayColor: color.withOpacity(0.12),
        ),
        child: Slider(
          value: value,
          min: 0,
          max: 10,
          divisions: 10,
          onChanged: (v) => setState(() => _acneAreaSeverity[area] = v),
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('None', style: AppTextStyles.smallText),
        Text('Severe', style: AppTextStyles.smallText),
      ]),
    ]);
  }

  // ── Per-breast-side slider ──────────────────────────────────────────────────
  Widget _breastSideSlider(
      String side, double value, ValueChanged<double> onChanged) {
    final color = _scoreColor(value);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('$side breast',
            style: AppTextStyles.cardSubtitle.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark)),
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: '${value.round()}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color)),
          const TextSpan(
              text: '/10',
              style: TextStyle(
                  fontSize: 12, color: AppColors.textMedium)),
        ])),
      ]),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 4,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          activeTrackColor: color,
          inactiveTrackColor: AppColors.cardBorder,
          thumbColor: color,
          overlayColor: color.withOpacity(0.12),
        ),
        child: Slider(
          value: value,
          min: 0,
          max: 10,
          divisions: 10,
          onChanged: onChanged,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('No pain', style: AppTextStyles.smallText),
        Text('Worst pain', style: AppTextStyles.smallText),
      ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new,
                      size: 14, color: AppColors.textDark),
                  label: const Text('Back',
                      style: TextStyle(color: AppColors.textDark,
                          fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                Row(children: [
                  Container(
                      width: 8, height: 8,
                      decoration: const BoxDecoration(
                          color: AppColors.primary, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  const Text('Evening Check-In',
                      style: TextStyle(fontSize: 13,
                          color: AppColors.textMedium,
                          fontWeight: FontWeight.w500)),
                ]),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // ── Header ────────────────────────────────────────────────────
              Row(children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                      color: const Color(0xFF1A7A8A),
                      borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.nightlight_round,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                const Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('End of day review',
                      style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  SizedBox(height: 2),
                  Text('Rate your symptoms this evening',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textMedium)),
                ]),
              ]),
              const SizedBox(height: 28),

              // ── Cyclic Breast Soreness overall ────────────────────────────
              _CheckinSlider(
                title: 'Cyclic Breast Soreness',
                subtitle:
                    'Rate the overall tenderness or pain in your breasts today.',
                value: _breastSoreness,
                minLabel: 'No Pain',
                maxLabel: 'Worst Imaginable Pain',
                scoreColor: _scoreColor(_breastSoreness),
                onChanged: (v) => setState(() => _breastSoreness = v),
              ),

              // ── Breast details expand when soreness > 0 ───────────────────
              if (_breastSoreness > 0) ...[
                const SizedBox(height: 16),
                _sectionCard(
                  title: 'Breast Details',
                  subtitle: 'Rate each side and describe the pain.',
                  children: [
                    // Left & right side sliders
                    _breastSideSlider('Left', _breastLeft,
                        (v) => setState(() => _breastLeft = v)),
                    const SizedBox(height: 12),
                    _breastSideSlider('Right', _breastRight,
                        (v) => setState(() => _breastRight = v)),
                    const SizedBox(height: 18),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: 14),

                    // Location toggle
                    Text('Location',
                        style: AppTextStyles.cardSubtitle.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(
                          child: _toggleButton(
                              'Unilateral',
                              _mastalgiaSide == 'Unilateral',
                              () => setState(
                                  () => _mastalgiaSide = 'Unilateral'))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _toggleButton(
                              'Bilateral',
                              _mastalgiaSide == 'Bilateral',
                              () => setState(
                                  () => _mastalgiaSide = 'Bilateral'))),
                    ]),
                    const SizedBox(height: 16),

                    // Quality toggle
                    Text('Quality',
                        style: AppTextStyles.cardSubtitle.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(
                          child: _toggleButton(
                              'Sharp',
                              _mastalgiaQuality == 'Sharp',
                              () => setState(
                                  () => _mastalgiaQuality = 'Sharp'))),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _toggleButton(
                              'Dull',
                              _mastalgiaQuality == 'Dull',
                              () =>
                                  setState(() => _mastalgiaQuality = 'Dull'))),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _toggleButton(
                              'Pressure',
                              _mastalgiaQuality == 'Pressure',
                              () => setState(
                                  () => _mastalgiaQuality = 'Pressure'))),
                    ]),
                  ],
                ),
              ],

              const SizedBox(height: 24),

              // ── Acne overall severity ─────────────────────────────────────
              _CheckinSlider(
                title: 'Acne Severity',
                subtitle:
                    'Rate the overall visibility or discomfort of any skin breakouts today.',
                value: _acneSeverity,
                minLabel: 'None',
                maxLabel: 'Severe',
                scoreColor: _scoreColor(_acneSeverity),
                onChanged: (v) => setState(() => _acneSeverity = v),
              ),

              // ── Acne distribution + per-area sliders (shown when acne > 0) ─
              if (_acneSeverity > 0) ...[
                const SizedBox(height: 16),
                _sectionCard(
                  title: 'Acne Distribution',
                  subtitle:
                      'Select all affected areas, then rate each one.',
                  children: [
                    // Area selection chips
                    Row(children: [
                      Expanded(child: _acneAreaChip('Face')),
                      const SizedBox(width: 8),
                      Expanded(child: _acneAreaChip('Chest')),
                      const SizedBox(width: 8),
                      Expanded(child: _acneAreaChip('Back')),
                    ]),

                    // Per-area severity sliders — only for selected areas
                    if (_acneAreas.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 16),
                      for (final area in ['Face', 'Chest', 'Back'])
                        if (_acneAreas.contains(area)) ...[
                          _areaSlider(area),
                          if (area != ['Face', 'Chest', 'Back']
                              .lastWhere((a) => _acneAreas.contains(a)))
                            const SizedBox(height: 16),
                        ],
                    ],
                  ],
                ),
              ],

              const SizedBox(height: 24),

              // ── Bloating ──────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Bloating Circumference Change',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                  const SizedBox(height: 4),
                  const Text(
                    'User-measured abdominal circumference change (cm). Leave blank if not measured.',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textMedium),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _bloatingCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[+-]?\d*\.?\d*')),
                    ],
                    decoration: InputDecoration(
                      hintText: 'e.g. +2.5',
                      hintStyle: const TextStyle(
                          color: AppColors.textHint, fontSize: 14),
                      suffixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              final v =
                                  double.tryParse(_bloatingCtrl.text) ?? 0;
                              _bloatingCtrl.text =
                                  (v + 0.5).toStringAsFixed(1);
                            },
                            child: const Icon(Icons.keyboard_arrow_up,
                                size: 16, color: AppColors.textMedium),
                          ),
                          GestureDetector(
                            onTap: () {
                              final v =
                                  double.tryParse(_bloatingCtrl.text) ?? 0;
                              _bloatingCtrl.text =
                                  (v - 0.5).toStringAsFixed(1);
                            },
                            child: const Icon(Icons.keyboard_arrow_down,
                                size: 16, color: AppColors.textMedium),
                          ),
                        ],
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceWhite,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColors.inputBorder, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColors.inputBorder, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                    ),
                  ),
                ]),
              ),

              const SizedBox(height: 24),

              // ── Today's Symptoms summary ──────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text("Today's Symptoms",
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _SummaryItem(
                        label: 'Fatigue',
                        value: _fatigue,
                        color: _scoreColor(_fatigue))),
                    Expanded(child: _SummaryItem(
                        label: 'Pelvic',
                        value: _pelvicPressure,
                        color: _scoreColor(_pelvicPressure))),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: _SummaryItem(
                        label: 'Breast',
                        value: _breastSoreness,
                        color: _scoreColor(_breastSoreness))),
                    Expanded(child: _SummaryItem(
                        label: 'Acne',
                        value: _acneSeverity,
                        color: _scoreColor(_acneSeverity))),
                  ]),
                ]),
              ),
              const SizedBox(height: 8),
            ]),
          ),
        ),

        // ── CTA ───────────────────────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.fromLTRB(
              20, 8, 20, MediaQuery.of(context).padding.bottom + 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(
                      builder: (_) => const HrvCaptureScreen(
                          label: 'Evening Check-In',
                          labelColor: AppColors.primary))),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Complete Evening Check-In',
                  style: TextStyle(color: Colors.white, fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── HrvCaptureScreen ──────────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class HrvCaptureScreen extends StatefulWidget {
  final String label;
  final Color labelColor;
  const HrvCaptureScreen(
      {super.key, required this.label, required this.labelColor});
  @override
  State<HrvCaptureScreen> createState() => _HrvCaptureScreenState();
}

class _HrvCaptureScreenState extends State<HrvCaptureScreen>
    with SingleTickerProviderStateMixin {
  bool _done = false;
  late AnimationController _tickController;
  late Animation<double> _tickScale;

  @override
  void initState() {
    super.initState();
    _tickController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _tickScale =
        CurvedAnimation(parent: _tickController, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _tickController.dispose();
    super.dispose();
  }

  void _startCapture() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _done = true);
      _tickController.forward();
    });
  }

  void _goToDashboard() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.dashboard, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new,
                      size: 14, color: AppColors.textDark),
                  label: const Text('Back',
                      style: TextStyle(color: AppColors.textDark,
                          fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                Row(children: [
                  Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                          color: widget.labelColor, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text(widget.label,
                      style: const TextStyle(fontSize: 13,
                          color: AppColors.textMedium,
                          fontWeight: FontWeight.w500)),
                ]),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.favorite_border,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                const Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('HRV Capture',
                      style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  SizedBox(height: 2),
                  Text('2-minute rPPG session',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textMedium)),
                ]),
              ]),
              const SizedBox(height: 24),
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xFFE8ECEF),
                    borderRadius: BorderRadius.circular(20)),
                child: _done
                    ? _CompleteView(scale: _tickScale)
                    : _CameraView(),
              ),
              const SizedBox(height: 20),
              Text(
                'Position your face in the frame. Stay still for 2 minutes while we '
                'measure your heart rate variability using remote photoplethysmography.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText,
              ),
              const SizedBox(height: 32),
            ]),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              20, 0, 20, MediaQuery.of(context).padding.bottom + 16),
          child: Column(children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _done ? _goToDashboard : _startCapture,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _done ? AppColors.riskLow : AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  _done ? 'Complete Check-In' : 'Start HRV Capture',
                  style: const TextStyle(color: Colors.white, fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _goToDashboard,
              child: const Text('Skip for now',
                  style: TextStyle(fontSize: 14,
                      color: AppColors.textMedium,
                      fontWeight: FontWeight.w500)),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ── Camera placeholder ────────────────────────────────────────────────────────
class _CameraView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.face_retouching_natural,
              size: 48, color: Color(0xFF9EAAB5)),
          SizedBox(height: 12),
          Text('Camera preview',
              style: TextStyle(fontSize: 14,
                  color: Color(0xFF9EAAB5), fontWeight: FontWeight.w400)),
        ],
      );
}

// ── Session complete ──────────────────────────────────────────────────────────
class _CompleteView extends StatelessWidget {
  final Animation<double> scale;
  const _CompleteView({required this.scale});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: scale,
            child: Container(
              width: 72, height: 72,
              decoration: const BoxDecoration(
                  color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Session complete!',
              style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 4),
          const Text('HRV: 42ms',
              style: TextStyle(fontSize: 13, color: AppColors.textMedium)),
        ],
      );
}

// ══════════════════════════════════════════════════════════════════════════════
// ── Shared Slider Widget ──────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _CheckinSlider extends StatelessWidget {
  final String title, subtitle, minLabel, maxLabel;
  final double value;
  final Color scoreColor;
  final ValueChanged<double> onChanged;

  const _CheckinSlider({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.minLabel,
    required this.maxLabel,
    required this.scoreColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: AppTextStyles.cardSubtitle),
                ])),
            const SizedBox(width: 10),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '${value.round()}',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: scoreColor)),
              const TextSpan(
                  text: '/10',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textMedium)),
            ])),
          ]),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape:
                  const RoundSliderOverlayShape(overlayRadius: 18),
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.cardBorder,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.12),
            ),
            child: Slider(
                value: value,
                min: 0,
                max: 10,
                divisions: 10,
                onChanged: onChanged),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(minLabel, style: AppTextStyles.smallText),
            Text(maxLabel, style: AppTextStyles.smallText),
          ]),
        ],
      );
}

// ── Summary Item ──────────────────────────────────────────────────────────────
class _SummaryItem extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _SummaryItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Row(children: [
        Text('$label  ',
            style: AppTextStyles.cardSubtitle
                .copyWith(color: AppColors.textDark)),
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: '${value.round()}',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: color,
                  fontSize: 14)),
          const TextSpan(
              text: '/10',
              style: TextStyle(
                  color: AppColors.textMedium, fontSize: 12)),
        ])),
      ]);
}