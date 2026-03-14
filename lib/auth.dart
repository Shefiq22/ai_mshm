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