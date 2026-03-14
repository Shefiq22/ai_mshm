import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_textstyles.dart';
import 'routes.dart';
import 'widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  final _email = TextEditingController();
  bool _sent = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_email.text.isEmpty) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _loading = false;
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _c, curve: Curves.easeOut),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const BackRow(),
                const SizedBox(height: 32),
                const Icon(Icons.lock_reset, size: 48, color: AppColors.primary),
                const SizedBox(height: 20),
                Text('Reset Your Password', style: AppTextStyles.screenTitle),
                const SizedBox(height: 8),
                Text(
                  'Enter your account email and we\'ll send you a reset link.',
                  style: AppTextStyles.screenSubtitle,
                ),
                const SizedBox(height: 32),
                if (!_sent) ...[
                  Text('Email', style: AppTextStyles.inputLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTextStyles.inputText,
                    decoration:
                        const InputDecoration(hintText: 'you@example.com'),
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    label: 'Send Reset Link',
                    isLoading: _loading,
                    onPressed: _submit,
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            color: AppColors.primary, size: 28),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email Sent!',
                                  style: AppTextStyles.featureTitle),
                              const SizedBox(height: 4),
                              Text(
                                'Check your inbox for the password reset link.',
                                style: AppTextStyles.cardSubtitle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.login),
                    child:
                        Text('Back to Login', style: AppTextStyles.linkText),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  int _cooldown = 0;

  void _resend() {
    setState(() => _cooldown = 60);
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _cooldown--);
      return _cooldown > 0;
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
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
            children: [
              const SizedBox(height: 60),
              AnimatedBuilder(
                animation: _pulse,
                builder: (_, __) => Transform.scale(
                  scale: 0.95 + 0.05 * _pulse.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary
                          .withOpacity(0.1 + 0.05 * _pulse.value),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mark_email_unread_outlined,
                        color: AppColors.primary, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text('Check Your Inbox',
                  style: AppTextStyles.screenTitle,
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(
                'We\'ve sent a verification link to your email.\nClick it to activate your account.',
                style: AppTextStyles.screenSubtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('Waiting for verification...',
                      style: AppTextStyles.smallText),
                ],
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                label: 'I\'ve Verified — Continue',
                onPressed: () => Navigator.pushReplacementNamed(
                    context, AppRoutes.OnboardingFlow),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _cooldown == 0 ? _resend : null,
                child: Text(
                  _cooldown > 0
                      ? 'Resend in ${_cooldown}s'
                      : 'Resend Email',
                  style: AppTextStyles.linkText.copyWith(
                    color: _cooldown > 0
                        ? AppColors.textLight
                        : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.signup),
                child: Text(
                  'Wrong email? Go back',
                  style: AppTextStyles.smallText
                      .copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}