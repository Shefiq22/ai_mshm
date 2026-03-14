import 'package:flutter/material.dart';
import 'dart:async';
import 'app_colors.dart';
import 'app_textstyles.dart';
import 'routes.dart';
import 'widgets.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _step = 0;
  final int _totalSteps = 6;

  // Step 1 – Personal Info
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedEthnicity;
  bool _ethnicityOpen = false;

  // Step 2 – Physical Measurements
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  // Step 3 – Skin Changes
  bool? _skinChanges;

  // Step 4 – Menstrual History
  final _cycleLengthController = TextEditingController();
  final _periodsPerYearController = TextEditingController();
  String? _cycleRegularity; // 'Regular' | 'Irregular'

  // Step 5 – Wearable
  String? _selectedWearable;

  // Step 6 – rPPG states: idle | holding | capturing | success
  String _rppgState = 'idle';
  int _captureSeconds = 0;
  Timer? _captureTimer;

  final List<String> _ethnicities = [
    'White/Caucasian',
    'Black/African American',
    'Hispanic/Latino',
    'Asian',
    'South Asian',
    'Middle Eastern',
    'Mixed/Other',
    'Prefer not to say',
  ];

  final List<Map<String, dynamic>> _wearables = [
    {'label': 'Apple Watch', 'icon': Icons.watch},
    {'label': 'Fitbit', 'icon': Icons.fitness_center},
    {'label': 'Garmin', 'icon': Icons.directions_run},
    {'label': 'Oura Ring', 'icon': Icons.circle_outlined},
  ];

  double get _progress => (_step + 1) / _totalSteps;
  int get _percent => ((_step + 1) / _totalSteps * 100).round();

  void _next() {
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      // After step 6 complete → show completion screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const _CompletionScreen()),
      );
    }
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  void _startRppgCapture() {
    setState(() => _rppgState = 'holding');
    // After 2s holding still → start capturing
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _rppgState = 'capturing';
        _captureSeconds = 0;
      });
      _captureTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) {
          t.cancel();
          return;
        }
        setState(() => _captureSeconds++);
        if (_captureSeconds >= 5) {
          // Demo: 5s instead of 120s
          t.cancel();
          setState(() => _rppgState = 'success');
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _cycleLengthController.dispose();
    _periodsPerYearController.dispose();
    _captureTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildProgressBar(),
              const SizedBox(height: 24),
              Expanded(child: _buildStep()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Step ${_step + 1} of $_totalSteps',
                style: AppTextStyles.smallText),
            Text('$_percent%', style: AppTextStyles.smallText),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 6,
            backgroundColor: AppColors.cardBorder,
            valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _buildPersonalInfo();
      case 1:
        return _buildPhysicalMeasurements();
      case 2:
        return _buildSkinChanges();
      case 3:
        return _buildMenstrualHistory();
      case 4:
        return _buildWearableSetup();
      case 5:
        return _buildRppgBaseline();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStepHeader(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.screenTitle),
            Text(subtitle, style: AppTextStyles.screenSubtitle),
          ],
        ),
      ],
    );
  }

  Widget _buildNavButtons({bool showSkip = false}) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _back,
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Back'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              side: BorderSide(color: AppColors.cardBorder),
              foregroundColor: AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PrimaryButton(
            label: showSkip ? 'Skip' : 'Continue →',
            onPressed: _next,
          ),
        ),
      ],
    );
  }

  // ── Step 1: Personal Info ───────────────────────────────────────────────────
  Widget _buildPersonalInfo() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            icon: Icons.person_outline,
            title: 'Personal Info',
            subtitle: 'Tell us about yourself',
          ),
          const SizedBox(height: 24),
          Text('Full Name', style: AppTextStyles.inputLabel),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            style: AppTextStyles.inputText,
            decoration: const InputDecoration(hintText: 'Your name'),
          ),
          const SizedBox(height: 18),
          Text('Age', style: AppTextStyles.inputLabel),
          const SizedBox(height: 8),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            style: AppTextStyles.inputText,
            decoration: const InputDecoration(hintText: 'e.g. 28'),
          ),
          const SizedBox(height: 18),
          Text('Ethnicity', style: AppTextStyles.inputLabel),
          const SizedBox(height: 8),
          _buildEthnicityDropdown(),
          const SizedBox(height: 28),
          PrimaryButton(label: 'Continue', onPressed: _next),
        ],
      ),
    );
  }

  Widget _buildEthnicityDropdown() {
    return Column(
      children: [
        GestureDetector(
          onTap: () =>
              setState(() => _ethnicityOpen = !_ethnicityOpen),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedEthnicity ?? 'Select ethnicity',
                  style: _selectedEthnicity != null
                      ? AppTextStyles.inputText
                      : AppTextStyles.inputHint,
                ),
                Icon(Icons.keyboard_arrow_down,
                    color: AppColors.textMedium),
              ],
            ),
          ),
        ),
        if (_ethnicityOpen)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: _ethnicities.map((e) {
                final selected = e == _selectedEthnicity;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedEthnicity = e;
                    _ethnicityOpen = false;
                  }),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Text(
                      e,
                      style: TextStyle(
                        fontSize: 14,
                        color: selected
                            ? Colors.white
                            : AppColors.textDark,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // ── Step 2: Physical Measurements (with live BMI) ──────────────────────────
  Widget _buildPhysicalMeasurements() {
    final h = double.tryParse(_heightController.text);
    final w = double.tryParse(_weightController.text);
    double? bmi;
    if (h != null && h > 0 && w != null && w > 0) {
      bmi = w / ((h / 100) * (h / 100));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          icon: Icons.straighten,
          title: 'Physical Measurements',
          subtitle: 'Height, weight & BMI',
        ),
        const SizedBox(height: 24),
        Text('Height (cm)', style: AppTextStyles.inputLabel),
        const SizedBox(height: 8),
        TextField(
          controller: _heightController,
          keyboardType: TextInputType.number,
          style: AppTextStyles.inputText,
          decoration: const InputDecoration(hintText: 'e.g. 165'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 18),
        Text('Weight (kg)', style: AppTextStyles.inputLabel),
        const SizedBox(height: 8),
        TextField(
          controller: _weightController,
          keyboardType: TextInputType.number,
          style: AppTextStyles.inputText,
          decoration: const InputDecoration(hintText: 'e.g. 65'),
          onChanged: (_) => setState(() {}),
        ),
        if (bmi != null) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF7F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Computed BMI',
                    style: AppTextStyles.cardSubtitle.copyWith(
                      color: AppColors.textMedium, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  bmi.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: _bmiColor(bmi),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 28),
        _buildNavButtons(),
      ],
    );
  }

  Color _bmiColor(double bmi) {
    if (bmi < 18.5) return const Color(0xFF3A7BD5);
    if (bmi < 25) return AppColors.riskLow;
    if (bmi < 30) return AppColors.warningAmber;
    return AppColors.riskHigh;
  }

  // ── Step 3: Skin Changes ────────────────────────────────────────────────────
  Widget _buildSkinChanges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          icon: Icons.face_retouching_natural_outlined,
          title: 'Skin Changes',
          subtitle: 'Acanthosis Nigricans screening',
        ),
        const SizedBox(height: 16),
        Text(
          'Acanthosis Nigricans is a darkening and thickening of the skin, often in the neck, armpits, or groin area. It can be associated with insulin resistance.',
          style: AppTextStyles.screenSubtitle,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _buildYesNoCard('Yes', _skinChanges == true,
                () => setState(() => _skinChanges = true)),
            const SizedBox(width: 12),
            _buildYesNoCard('No', _skinChanges == false,
                () => setState(() => _skinChanges = false)),
          ],
        ),
        const SizedBox(height: 24),
        _buildNavButtons(),
      ],
    );
  }

  Widget _buildYesNoCard(
      String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withOpacity(0.08)
                : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color:
                  selected ? AppColors.primary : AppColors.cardBorder,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: selected
                    ? AppColors.primary
                    : AppColors.textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Step 4: Menstrual History ───────────────────────────────────────────────
  Widget _buildMenstrualHistory() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            icon: Icons.calendar_today_outlined,
            title: 'Menstrual History',
            subtitle: 'Cycle patterns & regularity',
          ),
          const SizedBox(height: 24),

          Text('Typical cycle length (days)',
              style: AppTextStyles.inputLabel),
          const SizedBox(height: 8),
          TextField(
            controller: _cycleLengthController,
            keyboardType: TextInputType.number,
            style: AppTextStyles.inputText,
            decoration: const InputDecoration(hintText: 'e.g. 28'),
          ),

          const SizedBox(height: 18),
          Text('Periods per year (approx.)',
              style: AppTextStyles.inputLabel),
          const SizedBox(height: 8),
          TextField(
            controller: _periodsPerYearController,
            keyboardType: TextInputType.number,
            style: AppTextStyles.inputText,
            decoration: const InputDecoration(hintText: 'e.g. 12'),
          ),

          const SizedBox(height: 18),
          Text('Cycle regularity', style: AppTextStyles.inputLabel),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildRegularityCard('Regular'),
              const SizedBox(width: 12),
              _buildRegularityCard('Irregular'),
            ],
          ),

          const SizedBox(height: 28),
          _buildNavButtons(),
        ],
      ),
    );
  }

  Widget _buildRegularityCard(String label) {
    final selected = _cycleRegularity == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _cycleRegularity = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 22),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withOpacity(0.08)
                : AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color:
                  selected ? AppColors.primary : AppColors.cardBorder,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: selected
                    ? AppColors.primary
                    : AppColors.textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Step 5: Wearable Setup ──────────────────────────────────────────────────
  Widget _buildWearableSetup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          icon: Icons.watch_outlined,
          title: 'Wearable Setup',
          subtitle: 'Connect your device',
        ),
        const SizedBox(height: 16),
        Text(
          'Connect a wearable device for automatic HRV and activity data, or skip this step.',
          style: AppTextStyles.screenSubtitle,
        ),
        const SizedBox(height: 20),
        ..._wearables.map((w) => _buildWearableRow(w)),
        const SizedBox(height: 24),
        _buildNavButtons(showSkip: true),
      ],
    );
  }

  Widget _buildWearableRow(Map<String, dynamic> w) {
    final selected = _selectedWearable == w['label'];
    return GestureDetector(
      onTap: () =>
          setState(() => _selectedWearable = w['label'] as String),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                selected ? AppColors.primary : AppColors.cardBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(w['icon'] as IconData,
                color: AppColors.textMedium, size: 24),
            const SizedBox(width: 14),
            Text(w['label'] as String,
                style: AppTextStyles.inputText),
          ],
        ),
      ),
    );
  }

  // ── Step 6: rPPG Baseline ───────────────────────────────────────────────────
  Widget _buildRppgBaseline() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            icon: Icons.favorite_outline,
            title: 'rPPG Baseline',
            subtitle: 'Heart rate variability capture',
          ),
          const SizedBox(height: 16),
          Text(
            "We'll use your front camera to capture a 2-minute rPPG baseline for heart rate variability. Position your face in the frame and remain still.",
            style: AppTextStyles.screenSubtitle,
          ),
          const SizedBox(height: 20),

          // Camera preview box
          Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              color: const Color(0xFFECECEC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: _buildCameraPreviewContent(),
          ),

          const SizedBox(height: 20),

          // State-dependent bottom section
          if (_rppgState == 'idle') ...[
            PrimaryButton(
              label: 'Start Baseline Capture',
              onPressed: _startRppgCapture,
            ),
            const SizedBox(height: 12),
            _buildNavButtons(),
          ] else if (_rppgState == 'holding') ...[
            _buildStatusBanner(
              color: AppColors.warningAmber,
              bgColor: const Color(0xFFFFF8EC),
              icon: Icons.accessibility_new_outlined,
              message: 'Hold still… positioning detected',
            ),
            const SizedBox(height: 12),
            _buildNavButtons(),
          ] else if (_rppgState == 'capturing') ...[
            _buildStatusBanner(
              color: AppColors.primary,
              bgColor: AppColors.primary.withOpacity(0.08),
              icon: Icons.favorite,
              message:
                  'Capturing… ${_captureSeconds}s / 5s (demo)',
            ),
            const SizedBox(height: 12),
            _buildNavButtons(),
          ] else if (_rppgState == 'success') ...[
            _buildStatusBanner(
              color: AppColors.riskLow,
              bgColor: const Color(0xFFEAF6EE),
              icon: Icons.check_circle_outline,
              message: 'Capture successful! Baseline saved.',
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Continue →',
              onPressed: _next,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCameraPreviewContent() {
    if (_rppgState == 'idle') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Face scan icon using nested arcs
          SizedBox(
            width: 60,
            height: 60,
            child: CustomPaint(painter: _FaceScanPainter()),
          ),
          const SizedBox(height: 10),
          Text('Camera preview',
              style: AppTextStyles.cardSubtitle),
        ],
      );
    } else if (_rppgState == 'holding') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.face_outlined,
              size: 48, color: Color(0xFFFF9800)),
          const SizedBox(height: 8),
          Text('Hold still…',
              style: AppTextStyles.cardTitle
                  .copyWith(color: const Color(0xFFFF9800))),
        ],
      );
    } else if (_rppgState == 'capturing') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite,
              size: 48, color: AppColors.primary),
          const SizedBox(height: 8),
          Text('Capturing HRV data…',
              style: AppTextStyles.cardTitle
                  .copyWith(color: AppColors.primary)),
          const SizedBox(height: 6),
          // Mini progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _captureSeconds / 5,
                minHeight: 6,
                backgroundColor: AppColors.cardBorder,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
        ],
      );
    } else {
      // success
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.riskLow.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle,
                size: 36, color: AppColors.riskLow),
          ),
          const SizedBox(height: 10),
          Text('Baseline captured',
              style: AppTextStyles.cardTitle
                  .copyWith(color: AppColors.riskLow)),
        ],
      );
    }
  }

  Widget _buildStatusBanner({
    required Color color,
    required Color bgColor,
    required IconData icon,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.smallText.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Face scan icon painter ────────────────────────────────────────────────────
class _FaceScanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9E9E9E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;
    final r = 8.0;

    // Top-left corner
    canvas.drawLine(Offset(0, r), Offset(0, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(r, 0), paint);
    // Top-right corner
    canvas.drawLine(Offset(w - r, 0), Offset(w, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, r), paint);
    // Bottom-left corner
    canvas.drawLine(Offset(0, h - r), Offset(0, h), paint);
    canvas.drawLine(Offset(0, h), Offset(r, h), paint);
    // Bottom-right corner
    canvas.drawLine(Offset(w - r, h), Offset(w, h), paint);
    canvas.drawLine(Offset(w, h), Offset(w, h - r), paint);

    // Smiley placeholder
    final center = Offset(w / 2, h / 2 + 4);
    canvas.drawArc(
      Rect.fromCenter(center: center, width: 24, height: 16),
      0.2,
      2.7,
      false,
      paint,
    );
    // Eyes
    canvas.drawCircle(Offset(w / 2 - 8, h / 2 - 4), 2, paint..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(w / 2 + 8, h / 2 - 4), 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ── Completion Screen ─────────────────────────────────────────────────────────
class _CompletionScreen extends StatelessWidget {
  const _CompletionScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Sparkle decoration
              Align(
                alignment: const Alignment(0.6, 0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.amber.shade600,
                    size: 22,
                  ),
                ),
              ),

              // Check circle
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF26A69A),
                      Color(0xFF00796B),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 46,
                ),
              ),

              const SizedBox(height: 28),

              Text(
                "You're all set!",
                style: AppTextStyles.screenTitle.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 14),

              Text(
                'Your baseline has been saved. Your AI-powered metabolic health monitoring begins now. Complete daily check-ins for the most accurate risk assessment.',
                style: AppTextStyles.screenSubtitle.copyWith(
                  fontSize: 15,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'Go to Dashboard',
                  onPressed: () => Navigator.pushReplacementNamed(
                      context, AppRoutes.dashboard),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Your first morning check-in will be available tomorrow at 8 AM',
                style: AppTextStyles.smallText,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}