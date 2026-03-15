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

  // ── Hyperalgesia Assessment (PSQ-3) ──────────────────────────────────────
  double _skinSensitivity = 0;
  double _musclePressurePain = 0;
  double _bodyTenderness = 0;

  double get _hyperalgesiaIndex =>
      (_skinSensitivity + _musclePressurePain + _bodyTenderness) / 3;

  String get _hyperalgesiaLabel {
    if (_hyperalgesiaIndex <= 2) return 'Normal';
    if (_hyperalgesiaIndex <= 4) return 'Mild';
    if (_hyperalgesiaIndex <= 6) return 'Moderate';
    return 'Severe';
  }

  Color get _hyperalgesiaColor {
    if (_hyperalgesiaIndex <= 2) return AppColors.riskLow;
    if (_hyperalgesiaIndex <= 4) return AppColors.warningAmber;
    return AppColors.riskHigh;
  }

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

              // ── Fatigue ───────────────────────────────────────────────────
              _CheckinSlider(
                title: 'Physical Fatigue',
                subtitle: 'How tired or physically drained do you feel?',
                value: _fatigue,
                min: 0, max: 10, divisions: 10,
                minLabel: 'Energized',
                maxLabel: 'Exhausted',
                scoreColor: _scoreColor(_fatigue),
                onChanged: (v) => setState(() => _fatigue = v),
              ),
              const SizedBox(height: 28),

              // ── Pelvic Pressure ───────────────────────────────────────────
              _CheckinSlider(
                title: 'Pelvic Pressure',
                subtitle: 'Any lower abdominal pressure or discomfort?',
                value: _pelvicPressure,
                min: 0, max: 10, divisions: 10,
                minLabel: 'No pressure',
                maxLabel: 'Intense',
                scoreColor: _scoreColor(_pelvicPressure),
                onChanged: (v) => setState(() => _pelvicPressure = v),
              ),
              const SizedBox(height: 28),

              // ── Hyperalgesia Assessment Card ──────────────────────────────
              _HyperalgesiaCard(
                skinSensitivity: _skinSensitivity,
                musclePressurePain: _musclePressurePain,
                bodyTenderness: _bodyTenderness,
                index: _hyperalgesiaIndex,
                label: _hyperalgesiaLabel,
                labelColor: _hyperalgesiaColor,
                onSkinChanged: (v) => setState(() => _skinSensitivity = v),
                onMuscleChanged: (v) => setState(() => _musclePressurePain = v),
                onTendernessChanged: (v) => setState(() => _bodyTenderness = v),
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
                min: 0, max: 10, divisions: 10,
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
                min: 0, max: 10, divisions: 10,
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
  // ── Breast: per-side only (no overall slider) ─────────────────────────────
  double _breastLeft = 0;
  double _breastRight = 0;
  String? _mastalgiaSide;
  String? _mastalgiaQuality;

  // ── Acne: per-area 0–3 only (no overall slider) ───────────────────────────
  double _acneFace = 0;
  double _acneChest = 0;
  double _acneBack = 0;

  final TextEditingController _bloatingCtrl = TextEditingController();

  // Simulated values carried from morning/afternoon
  final double _fatigue = 3;
  final double _pelvicPressure = 1;

  @override
  void dispose() {
    _bloatingCtrl.dispose();
    super.dispose();
  }

  Color _scoreColor(double v, {double max = 10}) {
    final ratio = v / max;
    if (ratio <= 0.3) return AppColors.riskLow;
    if (ratio <= 0.6) return AppColors.warningAmber;
    return AppColors.riskHigh;
  }

  // ── Acne level label for 0-3 scale ───────────────────────────────────────
  String _acneLabel(double v) {
    switch (v.round()) {
      case 0: return 'None';
      case 1: return 'Mild';
      case 2: return 'Moderate';
      case 3: return 'Severe';
      default: return 'None';
    }
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

  // ── Per-breast-side slider (0–10) ─────────────────────────────────────────
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

  // ── Per-area acne slider (0–3) ─────────────────────────────────────────────
  Widget _acneAreaSlider(
      String area, double value, ValueChanged<double> onChanged) {
    final color = _scoreColor(value, max: 3);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Container(
            width: 7, height: 7,
            decoration: BoxDecoration(
                color: AppColors.primary, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(area,
              style: AppTextStyles.cardSubtitle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
        ]),
        Row(children: [
          Text(_acneLabel(value),
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color)),
          const SizedBox(width: 6),
          Text('(${value.round()}/3)',
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textMedium)),
        ]),
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
          max: 3,
          divisions: 3,
          onChanged: onChanged,
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('None', style: AppTextStyles.smallText),
        Text('Mild', style: AppTextStyles.smallText),
        Text('Moderate', style: AppTextStyles.smallText),
        Text('Severe', style: AppTextStyles.smallText),
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
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

              // ── Cyclic Breast Soreness (left & right only) ────────────────
              _sectionCard(
                title: 'Cyclic Breast Soreness',
                subtitle: 'Rate the tenderness or pain for each side (0–10).',
                children: [
                  _breastSideSlider('Left', _breastLeft,
                      (v) => setState(() => _breastLeft = v)),
                  const SizedBox(height: 16),
                  _breastSideSlider('Right', _breastRight,
                      (v) => setState(() => _breastRight = v)),

                  // ── Pain character toggles ─────────────────────────────
                  if (_breastLeft > 0 || _breastRight > 0) ...[
                    const SizedBox(height: 18),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: 14),

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
                              () => setState(
                                  () => _mastalgiaQuality = 'Dull'))),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _toggleButton(
                              'Pressure',
                              _mastalgiaQuality == 'Pressure',
                              () => setState(
                                  () => _mastalgiaQuality = 'Pressure'))),
                    ]),
                  ],
                ],
              ),

              const SizedBox(height: 24),

              // ── Acne (per area, 0–3 each, no overall slider) ──────────────
              _sectionCard(
                title: 'Acne Severity',
                subtitle:
                    'Rate each area from 0 (none) to 3 (severe).',
                children: [
                  _acneAreaSlider('Face', _acneFace,
                      (v) => setState(() => _acneFace = v)),
                  const SizedBox(height: 16),
                  _acneAreaSlider('Chest', _acneChest,
                      (v) => setState(() => _acneChest = v)),
                  const SizedBox(height: 16),
                  _acneAreaSlider('Back', _acneBack,
                      (v) => setState(() => _acneBack = v)),
                ],
              ),

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
                        displayMax: 10,
                        color: _scoreColor(_fatigue))),
                    Expanded(child: _SummaryItem(
                        label: 'Pelvic',
                        value: _pelvicPressure,
                        displayMax: 10,
                        color: _scoreColor(_pelvicPressure))),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: _SummaryItem(
                        label: 'L.Breast',
                        value: _breastLeft,
                        displayMax: 10,
                        color: _scoreColor(_breastLeft))),
                    Expanded(child: _SummaryItem(
                        label: 'R.Breast',
                        value: _breastRight,
                        displayMax: 10,
                        color: _scoreColor(_breastRight))),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: _SummaryItem(
                        label: 'Acne Face',
                        value: _acneFace,
                        displayMax: 3,
                        color: _scoreColor(_acneFace, max: 3))),
                    Expanded(child: _SummaryItem(
                        label: 'Acne Back',
                        value: _acneBack,
                        displayMax: 3,
                        color: _scoreColor(_acneBack, max: 3))),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: _SummaryItem(
                        label: 'Acne Chest',
                        value: _acneChest,
                        displayMax: 3,
                        color: _scoreColor(_acneChest, max: 3))),
                    const Expanded(child: SizedBox()),
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
// ── Hyperalgesia Assessment Card (PSQ-3) ──────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _HyperalgesiaCard extends StatelessWidget {
  final double skinSensitivity;
  final double musclePressurePain;
  final double bodyTenderness;
  final double index;
  final String label;
  final Color labelColor;
  final ValueChanged<double> onSkinChanged;
  final ValueChanged<double> onMuscleChanged;
  final ValueChanged<double> onTendernessChanged;

  const _HyperalgesiaCard({
    required this.skinSensitivity,
    required this.musclePressurePain,
    required this.bodyTenderness,
    required this.index,
    required this.label,
    required this.labelColor,
    required this.onSkinChanged,
    required this.onMuscleChanged,
    required this.onTendernessChanged,
  });

  Color _sliderColor(double v) {
    if (v <= 2) return AppColors.riskLow;
    if (v <= 5) return AppColors.warningAmber;
    return AppColors.riskHigh;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ───────────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.touch_app_outlined,
                    color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hyperalgesia Assessment',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    const Text('Pain Sensitivity Questionnaire (PSQ-3)',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textMedium)),
                  ],
                ),
              ),
            ],
          ),

          // ── Info banner ───────────────────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withOpacity(0.15)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline,
                    size: 14, color: AppColors.primary),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Rate how painful everyday pressure stimuli feel today. '
                    'The index is automatically computed from all three scores.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMedium),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 16),

          // ── Q1: Skin Sensitivity ──────────────────────────────────────────
          _PSQSlider(
            question: 'Q1 — Skin Sensitivity',
            description: 'How sensitive is your skin to light touch today?',
            value: skinSensitivity,
            color: _sliderColor(skinSensitivity),
            onChanged: onSkinChanged,
          ),
          const SizedBox(height: 20),

          // ── Q2: Muscle Pressure Pain ──────────────────────────────────────
          _PSQSlider(
            question: 'Q2 — Muscle Pressure Pain',
            description: 'Does pressure on your muscles feel painful today?',
            value: musclePressurePain,
            color: _sliderColor(musclePressurePain),
            onChanged: onMuscleChanged,
          ),
          const SizedBox(height: 20),

          // ── Q3: Body Tenderness ───────────────────────────────────────────
          _PSQSlider(
            question: 'Q3 — Overall Body Tenderness',
            description: 'How would you rate your overall body tenderness?',
            value: bodyTenderness,
            color: _sliderColor(bodyTenderness),
            onChanged: onTendernessChanged,
          ),

          const SizedBox(height: 20),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 14),

          // ── Computed index ────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: labelColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: labelColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hyperalgesia Index',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMedium)),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: index.toStringAsFixed(1),
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: labelColor),
                        ),
                        const TextSpan(
                          text: ' / 10',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textMedium),
                        ),
                      ]),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: labelColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(label,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: labelColor)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single PSQ slider ─────────────────────────────────────────────────────────
class _PSQSlider extends StatelessWidget {
  final String question;
  final String description;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;

  const _PSQSlider({
    required this.question,
    required this.description,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(question,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  const SizedBox(height: 2),
                  Text(description,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMedium)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '${value.round()}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: color),
                ),
                const TextSpan(
                  text: '/10',
                  style: TextStyle(
                      fontSize: 11, color: AppColors.textMedium),
                ),
              ]),
            ),
          ],
        ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('No pain',
                style: TextStyle(fontSize: 11, color: AppColors.textLight)),
            const Text('Severe',
                style: TextStyle(fontSize: 11, color: AppColors.textLight)),
          ],
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ── Shared Slider Widget ──────────────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════════════════════
class _CheckinSlider extends StatelessWidget {
  final String title, subtitle, minLabel, maxLabel;
  final double value, min, max;
  final int divisions;
  final Color scoreColor;
  final ValueChanged<double> onChanged;

  const _CheckinSlider({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
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
              TextSpan(
                  text: '/${max.round()}',
                  style: const TextStyle(
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
                min: min,
                max: max,
                divisions: divisions,
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
  final int displayMax;
  final Color color;
  const _SummaryItem(
      {required this.label,
      required this.value,
      required this.displayMax,
      required this.color});

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
          TextSpan(
              text: '/$displayMax',
              style: const TextStyle(
                  color: AppColors.textMedium, fontSize: 12)),
        ])),
      ]);
}