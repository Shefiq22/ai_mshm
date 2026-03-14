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

    int _role = 0;
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
                    Text('Email Address', style: AppTextStyles.inputLabel),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      style: AppTextStyles.inputText,
                      decoration: InputDecoration(
                        hintText: _role == 0
                            ? 'you@example.com'
                            : 'doctor@clinic.com',
                        prefixIcon: const Icon(Icons.mail_outline,
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
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Demo Credentials:',
                              style: AppTextStyles.smallText.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Patient: patient@demo.com / demo1234',
                                style: AppTextStyles.smallText),
                            Text('Clinician: clinician@demo.com / demo1234',
                                style: AppTextStyles.smallText),
                          ],
                        ),
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
                Icon(icon,
                    size: 16,
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