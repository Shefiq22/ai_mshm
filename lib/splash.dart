import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_textstyles.dart';
import 'routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _brand =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  late final AnimationController _title =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
  late final AnimationController _sub =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  late final AnimationController _line =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _brand.forward();
    await Future.delayed(const Duration(milliseconds: 250));
    _title.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _sub.forward();
    await Future.delayed(const Duration(milliseconds: 150));
    _line.forward();
    await Future.delayed(const Duration(milliseconds: 1300));
    if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.welcome);
  }

  @override
  void dispose() {
    _brand.dispose();
    _title.dispose();
    _sub.dispose();
    _line.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _title, curve: Curves.easeOut));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: _brand,
              child: Text('MSHM', style: AppTextStyles.splashBrand),
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: CurvedAnimation(parent: _title, curve: Curves.easeOut),
              child: SlideTransition(
                position: titleSlide,
                child: Text('AI-MSHM', style: AppTextStyles.splashTitle),
              ),
            ),
            const SizedBox(height: 8),
            FadeTransition(
              opacity: CurvedAnimation(parent: _sub, curve: Curves.easeOut),
              child: Text(
                'Metabolic & Syndromic Health Monitor',
                style: AppTextStyles.splashSubtitle,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _line,
              builder: (_, __) => Container(
                width: 48 * _line.value,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.splashAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}