import 'package:ai_mshm/app_colors.dart';
import 'package:ai_mshm/app_textstyles.dart';
import 'package:ai_mshm/routes.dart';
import 'package:ai_mshm/widgets.dart';
import 'package:flutter/material.dart';

// ─── Screen 10: Wearable Device Setup ────────────────────────────────────────
class OnboardingWearable extends StatefulWidget {
  const OnboardingWearable({super.key});
  @override State<OnboardingWearable> createState() => _OBWearableState();
}

class _OBWearableState extends State<OnboardingWearable> {
  final Set<String> _connected = {};
  bool _skipped = false;

  final _devices = [
    {'name': 'Apple Watch',  'icon': Icons.watch,              'types': 'HRV · Sleep · Steps'},
    {'name': 'Fitbit',       'icon': Icons.fitness_center,     'types': 'HRV · Sleep · Steps'},
    {'name': 'Garmin',       'icon': Icons.gps_fixed,          'types': 'HRV · BBT · Sleep'},
    {'name': 'Oura Ring',    'icon': Icons.circle_outlined,    'types': 'HRV · BBT · Sleep · Temp'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 20),
                const StepProgress(current: 4, total: 6),
                const SizedBox(height: 24),
                const SectionHeader(title: 'Connect Your Wearable',
                  subtitle: 'Wearables enrich your risk score with continuous passive data'),
                const SizedBox(height: 24),

                ..._devices.map((d) {
                  final name = d['name'] as String;
                  final icon = d['icon'] as IconData;
                  final types = d['types'] as String;
                  final isConnected = _connected.contains(name);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isConnected ? AppColors.primary : AppColors.cardBorder,
                          width: isConnected ? 1.5 : 1)),
                      child: Row(children: [
                        Container(width: 48, height: 48,
                          decoration: BoxDecoration(
                            color: isConnected ? AppColors.primary.withOpacity(0.1) : AppColors.iconBg,
                            borderRadius: BorderRadius.circular(12)),
                          child: Icon(icon, color: isConnected ? AppColors.primary : AppColors.textMedium, size: 24)),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(name, style: AppTextStyles.featureTitle),
                          Text(types, style: AppTextStyles.featureSubtitle),
                        ])),
                        GestureDetector(
                          onTap: () => setState(() =>
                            isConnected ? _connected.remove(name) : _connected.add(name)),
                          child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isConnected ? AppColors.riskLow.withOpacity(0.1) : AppColors.primary,
                              borderRadius: BorderRadius.circular(8)),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              if (isConnected) const Icon(Icons.check, size: 14, color: AppColors.riskLow),
                              if (isConnected) const SizedBox(width: 4),
                              Text(isConnected ? 'Connected' : 'Connect',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                  color: isConnected ? AppColors.riskLow : Colors.white)),
                            ])),
                        ),
                      ]),
                    ),
                  );
                }),

                const SizedBox(height: 8),
                Center(child: GestureDetector(
                  onTap: () { setState(() => _skipped = true); Navigator.pushNamed(context, AppRoutes.onboarding5); },
                  child: Text('Skip for Now — I\'ll use smartphone camera only',
                    style: AppTextStyles.linkText.copyWith(fontSize: 13)),
                )),
                const SizedBox(height: 32),
              ]),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(color: AppColors.surfaceWhite,
              border: Border(top: BorderSide(color: AppColors.divider))),
            child: Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.inputBorder)),
                  child: Text('Back', style: AppTextStyles.inputLabel.copyWith(color: AppColors.textMedium)))),
              const SizedBox(width: 12),
              Expanded(child: PrimaryButton(label: 'Next',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.onboarding5))),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ─── Screen 11: rPPG Baseline Capture ────────────────────────────────────────
class OnboardingRPPG extends StatefulWidget {
  const OnboardingRPPG({super.key});
  @override State<OnboardingRPPG> createState() => _OBRPPGState();
}

class _OBRPPGState extends State<OnboardingRPPG> with TickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(vsync: this,
    duration: const Duration(milliseconds: 800))..repeat(reverse: true);
  late final AnimationController _wave = AnimationController(vsync: this,
    duration: const Duration(seconds: 2))..repeat();

  bool _started = false, _done = false;
  int _seconds = 120;

  void _startSession() {
    setState(() => _started = true);
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _seconds--);
      if (_seconds <= 0) { setState(() => _done = true); return false; }
      return true;
    });
  }

  String get _timer => '${(_seconds ~/ 60).toString().padLeft(2,'0')}:${(_seconds % 60).toString().padLeft(2,'0')}';

  @override void dispose() { _pulse.dispose(); _wave.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(children: [
          // Camera preview simulation
          Container(color: const Color(0xFF1A1A2E)),

          if (!_done) Column(children: [
            const SizedBox(height: 20),
            const StepProgress(current: 5, total: 6),
            const Spacer(),

            // Face alignment ring
            AnimatedBuilder(animation: _pulse, builder: (_, __) => Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _started
                    ? AppColors.primary.withOpacity(0.5 + 0.5 * _pulse.value)
                    : Colors.white.withOpacity(0.3),
                  width: 3)),
              child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.face_outlined, color: Colors.white.withOpacity(0.6), size: 64),
                if (_started) ...[
                  const SizedBox(height: 8),
                  Text(_timer, style: const TextStyle(color: Colors.white, fontSize: 24,
                    fontWeight: FontWeight.w800, letterSpacing: 2)),
                ],
              ])),
            )),

            const SizedBox(height: 24),
            Text(_started ? 'Stay still, look at camera, neutral lighting'
              : 'Position your face in the ring',
              style: const TextStyle(color: Colors.white70, fontSize: 14), textAlign: TextAlign.center),

            const SizedBox(height: 20),

            // SQI bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                  Text('Signal Quality', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  Text('Good', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 6),
                ClipRRect(borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(value: 0.82, minHeight: 6,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
              ]),
            ),

            const Spacer(),

            if (!_started)
              Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: PrimaryButton(label: 'Start 2-Minute Session', onPressed: _startSession)),
            if (_started)
              Padding(padding: const EdgeInsets.all(20),
                child: TextButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.onboarding5),
                  child: const Text('Skip today', style: TextStyle(color: Colors.white54, fontSize: 14)))),
          ]),

          // Done overlay
          if (_done)
            Container(color: AppColors.background,
              child: SafeArea(child: Center(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.check_circle_outline, color: AppColors.riskLow, size: 72),
                  const SizedBox(height: 20),
                  Text('Baseline Captured!', style: AppTextStyles.screenTitle),
                  const SizedBox(height: 12),
                  Text('Your HRV baseline has been recorded.', style: AppTextStyles.screenSubtitle, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  Container(padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.surfaceWhite, borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [
                      _HrvMetric(label: 'RMSSD', value: '42ms'),
                      _HrvMetric(label: 'SDNN',  value: '58ms'),
                      _HrvMetric(label: 'LF/HF', value: '1.8'),
                    ])),
                  const SizedBox(height: 32),
                  PrimaryButton(label: 'Continue',
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.onboardingDone)),
                ]),
              ))),
            ),
        ]),
      ),
    );
  }
}

class _HrvMetric extends StatelessWidget {
  final String label, value;
  const _HrvMetric({required this.label, required this.value});
  @override Widget build(BuildContext context) => Column(children: [
    Text(value, style: AppTextStyles.biomarkerValue.copyWith(fontSize: 18)),
    Text(label, style: AppTextStyles.biomarkerUnit),
  ]);
}

// ─── Screen 12: Onboarding Complete ──────────────────────────────────────────
class OnboardingComplete extends StatefulWidget {
  const OnboardingComplete({super.key});
  @override State<OnboardingComplete> createState() => _OBCompleteState();
}

class _OBCompleteState extends State<OnboardingComplete> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

  @override void initState() { super.initState(); _c.forward(); }
  @override void dispose()   { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _c, curve: Curves.easeOut),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              const SizedBox(height: 60),

              // Animated checkmark
              Container(width: 100, height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF7EA), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_outline, color: AppColors.riskLow, size: 60)),

              const SizedBox(height: 28),
              Text('You\'re All Set!', style: AppTextStyles.screenTitle, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text('Your health profile is ready. Here\'s what\'s been configured:',
                style: AppTextStyles.screenSubtitle, textAlign: TextAlign.center),

              const SizedBox(height: 28),

              // Setup summary
              ...[
                _SetupRow(icon: Icons.watch_outlined,         label: 'Wearable connected',       done: true),
                _SetupRow(icon: Icons.videocam_outlined,      label: 'rPPG Baseline captured',   done: true),
                _SetupRow(icon: Icons.calendar_today_outlined, label: 'Cycle history recorded',  done: true),
                _SetupRow(icon: Icons.science_outlined,       label: 'Clinical data — pending',  done: false),
              ],

              const SizedBox(height: 28),

              // Data layer status
              Container(padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surfaceWhite, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder)),
                child: Column(children: [
                  _LayerStatus(label: 'Passive Layer',   status: 'Active', color: AppColors.riskLow),
                  const SizedBox(height: 8),
                  _LayerStatus(label: 'Active Layer',    status: 'Pending', color: AppColors.warningAmber),
                  const SizedBox(height: 8),
                  _LayerStatus(label: 'Clinical Layer',  status: 'Pending', color: AppColors.warningAmber),
                ])),

              const Spacer(),
              PrimaryButton(label: 'Go to My Dashboard',
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.dashboard)),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ),
    );
  }
}

class _SetupRow extends StatelessWidget {
  final IconData icon; final String label; final bool done;
  const _SetupRow({required this.icon, required this.label, required this.done});

  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Icon(icon, size: 20, color: done ? AppColors.primary : AppColors.textLight),
      const SizedBox(width: 12),
      Expanded(child: Text(label, style: AppTextStyles.cardSubtitle.copyWith(
        color: done ? AppColors.textDark : AppColors.textLight))),
      Icon(done ? Icons.check_circle : Icons.radio_button_unchecked,
        size: 18, color: done ? AppColors.riskLow : AppColors.textLight),
    ]),
  );
}

class _LayerStatus extends StatelessWidget {
  final String label, status; final Color color;
  const _LayerStatus({required this.label, required this.status, required this.color});

  @override Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: AppTextStyles.sectionLabel),
      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
        child: Text(status, style: AppTextStyles.badgeText.copyWith(color: color))),
    ],
  );
}