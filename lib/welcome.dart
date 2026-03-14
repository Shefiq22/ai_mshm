import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_textstyles.dart';
import 'routes.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
        ..forward();

  @override
  void dispose() { _fade.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fade,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(),
                // Logo + brand
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.favorite, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 24),
                Text('AI-MSHM', style: AppTextStyles.splashTitle),
                const SizedBox(height: 8),
                Text(
                  'Your personal PCOS health companion',
                  style: AppTextStyles.cardSubtitle,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                // Feature highlights — kept to 3 minimal chips
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _FeatureChip(icon: Icons.insights, label: 'AI Risk Score'),
                    const SizedBox(width: 10),
                    _FeatureChip(icon: Icons.calendar_month, label: 'Cycle Tracking'),
                    const SizedBox(width: 10),
                    _FeatureChip(icon: Icons.biotech, label: 'Lab Analysis'),
                  ],
                ),
                const Spacer(),
                // CTA buttons
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
                    child: const Text('Get Started'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Sign In', style: AppTextStyles.linkText),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.surfaceWhite,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.cardBorder)),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: AppColors.primary, size: 20),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(
        fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
    ]),
  );
}