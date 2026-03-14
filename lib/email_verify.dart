import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_textstyles.dart';
import 'routes.dart';
import 'widgets.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen>
    with SingleTickerProviderStateMixin {
  // ── Animation (mirrors SignupScreen) ──────────────────────────────────
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 600));
  late final Animation<double> _fade =
      CurvedAnimation(parent: _c, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.08),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));

  // ── OTP state ─────────────────────────────────────────────────────────
  static const int _otpLength = 6;
  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  bool _isVerifying = false;
  bool _hasError = false;
  int _resendSeconds = 30;
  bool _canResend = false;

  // Ticker for resend countdown
  late final _resendNotifier = ValueNotifier<int>(_resendSeconds);

  @override
  void initState() {
    super.initState();
    _c.forward();
    _startResendTimer();
    // Auto-focus first box
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(_focusNodes[0]));
  }

  void _startResendTimer() {
    _canResend = false;
    _resendSeconds = 30;
    _resendNotifier.value = _resendSeconds;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      _resendSeconds--;
      _resendNotifier.value = _resendSeconds;
      if (_resendSeconds <= 0) {
        setState(() => _canResend = true);
        return false;
      }
      return true;
    });
  }

  @override
  void dispose() {
    _c.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _resendNotifier.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────

  String get _otpValue =>
      _controllers.map((c) => c.text).join();

  bool get _otpComplete => _otpValue.length == _otpLength;

  void _onOtpChanged(int index, String value) {
    setState(() => _hasError = false);

    if (value.length == 1 && index < _otpLength - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
    setState(() {});
  }

  Future<void> _verify() async {
    if (!_otpComplete) return;
    setState(() {
      _isVerifying = true;
      _hasError = false;
    });

    // TODO: replace with real verification call
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    // Simulate success — swap condition when wiring real API
    const bool success = true;
    if (success) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.OnboardingFlow, (_) => false);
    } else {
      setState(() {
        _isVerifying = false;
        _hasError = true;
      });
      for (final c in _controllers) {
        c.clear();
      }
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    }
  }

  void _resend() {
    if (!_canResend) return;
    for (final c in _controllers) {
      c.clear();
    }
    FocusScope.of(context).requestFocus(_focusNodes[0]);
    setState(() {
      _hasError = false;
      _canResend = false;
    });
    _startResendTimer();
    // TODO: trigger resend API call
  }

  // ── Build ─────────────────────────────────────────────────────────────

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

                  // ── Header ───────────────────────────────────────────
                  Text('Verify your email', style: AppTextStyles.screenTitle),
                  const SizedBox(height: 6),
                  Text(
                    'Enter the 6-digit code we sent to your email address.',
                    style: AppTextStyles.screenSubtitle,
                  ),
                  const SizedBox(height: 36),

                  // ── OTP boxes ────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_otpLength, (i) {
                      return _OtpBox(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        hasError: _hasError,
                        onChanged: (v) => _onOtpChanged(i, v),
                        onBackspace: () {
                          if (_controllers[i].text.isEmpty && i > 0) {
                            _controllers[i - 1].clear();
                            FocusScope.of(context)
                                .requestFocus(_focusNodes[i - 1]);
                          }
                        },
                      );
                    }),
                  ),

                  // ── Error message ─────────────────────────────────────
                  AnimatedOpacity(
                    opacity: _hasError ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'Incorrect code. Please try again.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.riskCritical,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Verify button ────────────────────────────────────
                  PrimaryButton(
                    label: _isVerifying ? 'Verifying…' : 'Verify Email',
                    onPressed: (_otpComplete && !_isVerifying) ? _verify : null,
                  ),

                  const SizedBox(height: 28),

                  // ── Resend row ───────────────────────────────────────
                  Center(
                    child: ValueListenableBuilder<int>(
                      valueListenable: _resendNotifier,
                      builder: (_, seconds, __) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Didn't receive the code? ",
                              style: AppTextStyles.smallText,
                            ),
                            GestureDetector(
                              onTap: _canResend ? _resend : null,
                              child: Text(
                                _canResend
                                    ? 'Resend'
                                    : 'Resend in ${seconds}s',
                                style: _canResend
                                    ? AppTextStyles.linkText
                                    : AppTextStyles.smallText?.copyWith(
                                        color: AppColors.textHint,
                                      ),
                              ),
                            ),
                          ],
                        );
                      },
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

// ── Single OTP digit box ────────────────────────────────────────────────

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 56,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              controller.text.isEmpty) {
            onBackspace();
          }
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          obscureText: false,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError
                    ? AppColors.riskCritical
                    : controller.text.isNotEmpty
                        ? AppColors.primary
                        : AppColors.cardBorder,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? AppColors.riskCritical : AppColors.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: AppColors.surfaceLight,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}