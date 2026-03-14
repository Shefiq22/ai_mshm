import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_textstyles.dart';
import 'routes.dart';
import 'widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  late final Animation<double> _fade =
      CurvedAnimation(parent: _c, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.08),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));

  int _role = 0;
  bool _obscurePw = true;
  bool _obscureConfirm = true;
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void initState() {
    super.initState();
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
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
                  const BrandBadge(),
                  const SizedBox(height: 14),
                  Text('Create your account', style: AppTextStyles.screenTitle),
                  const SizedBox(height: 6),
                  Text('Start your personalised health journey',
                      style: AppTextStyles.screenSubtitle),
                  const SizedBox(height: 28),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        _RoleTab(
                          label: 'Patient',
                          icon: Icons.person_outline,
                          selected: _role == 0,
                          onTap: () => setState(() => _role = 0),
                        ),
                        _RoleTab(
                          label: 'Clinician',
                          icon: Icons.medical_services_outlined,
                          selected: _role == 1,
                          onTap: () => setState(() => _role = 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Full Name', style: AppTextStyles.inputLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _name,
                    style: AppTextStyles.inputText,
                    decoration: InputDecoration(
                      hintText: _role == 0 ? 'Your full name' : 'Dr. Full Name',
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('Email', style: AppTextStyles.inputLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTextStyles.inputText,
                    decoration: InputDecoration(
                      hintText: _role == 0 ? 'you@example.com' : 'doctor@clinic.com',
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('Password', style: AppTextStyles.inputLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _password,
                    obscureText: _obscurePw,
                    style: AppTextStyles.inputText,
                    decoration: InputDecoration(
                      hintText: 'Min 8 characters',
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => _obscurePw = !_obscurePw),
                        child: Icon(
                          _obscurePw
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textHint,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('Confirm Password', style: AppTextStyles.inputLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _confirm,
                    obscureText: _obscureConfirm,
                    style: AppTextStyles.inputText,
                    decoration: InputDecoration(
                      hintText: 'Re-enter password',
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        child: Icon(
                          _obscureConfirm
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
                    label: 'Create Account',
                    onPressed: () => Navigator.pushReplacementNamed(
                        context, AppRoutes.OnboardingFlow),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Already have an account? ',
                            style: AppTextStyles.smallText),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.login),
                          child: Text('Sign in', style: AppTextStyles.linkText),
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

class _RoleTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16,
                  color: selected ? Colors.white : AppColors.textMedium),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}