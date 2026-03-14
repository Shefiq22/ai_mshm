import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_textstyles.dart';
import 'routes.dart';
import 'widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  late final Animation<double> _fade =
      CurvedAnimation(parent: _c, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.08),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));

  bool _obscure = true;
  final _email = TextEditingController();
  final _pw = TextEditingController();

  @override
  void initState() {
    super.initState();
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    _email.dispose();
    _pw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const BackRow(),
                  const SizedBox(height: 24),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.monitor_heart,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(height: 20),
                  Text('Welcome Back', style: AppTextStyles.screenTitle),
                  const SizedBox(height: 6),
                  Text('Log in to continue tracking your health',
                      style: AppTextStyles.screenSubtitle),
                  const SizedBox(height: 28),
                  Text('Email Address', style: AppTextStyles.inputLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTextStyles.inputText,
                    decoration: const InputDecoration(
                      hintText: 'you@example.com',
                      prefixIcon: Icon(Icons.mail_outline,
                          color: AppColors.textHint, size: 20),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Password', style: AppTextStyles.inputLabel),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.forgotPassword),
                        child: Text('Forgot Password?',
                            style: AppTextStyles.linkText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _pw,
                    obscureText: _obscure,
                    style: AppTextStyles.inputText,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColors.textHint, size: 20),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => _obscure = !_obscure),
                        child: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textHint,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    label: 'Log In',
                    onPressed: () => Navigator.pushReplacementNamed(
                        context, AppRoutes.dashboard),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Don't have an account? ",
                            style: AppTextStyles.smallText),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.signup),
                          child: Text('Sign Up', style: AppTextStyles.linkText),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}