import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'routes.dart';
import 'splash.dart';
import 'welcome.dart';
import 'login.dart';
import 'signup.dart';
import 'auth.dart';              // ForgotPasswordScreen only
import 'email_verify.dart';      // EmailVerifyScreen (6-digit OTP)
import 'onboard.dart';           // OnboardingFlow
import 'onboarding.dart';        // OnboardingWearable, OnboardingRPPG, OnboardingComplete
import 'dashboard.dart';         // DashboardScreen
import 'checkin.dart';           // MorningCheckinScreen, EveningCheckinScreen
import 'cycle.dart';             // CycleCalendarScreen
import 'weekly_tools.dart';      // WeeklyToolsScreen, MfgScreen, Phq4Screen
import 'clinical_screens.dart';  // LabUploadScreen, UltrasoundUploadScreen, ClinicalStatusScreen
import 'risk_screens.dart';      // RiskScoreScreen, RiskTrendScreen, ShapDetailScreen,
                                 // TriageNoLabsScreen, PeriodLogScreen
import 'referral_pdf.dart';      // ReferralScreen, ClinicalPdfScreen
import 'profile.dart';           // ProfileScreen, NotificationSettingsScreen,
                                 // ConnectedDevicesScreen, DataPrivacyScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI-MSHM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        // ── Splash & Welcome ───────────────────────────────────────────────
        AppRoutes.splash:            (_) => const SplashScreen(),
        AppRoutes.welcome:           (_) => const WelcomeScreen(),

        // ── Auth ───────────────────────────────────────────────────────────
        AppRoutes.login:             (_) => const LoginScreen(),
        AppRoutes.signup:            (_) => const SignupScreen(),
        AppRoutes.forgotPassword:    (_) => const ForgotPasswordScreen(),
        AppRoutes.emailVerify:       (_) => const EmailVerifyScreen(),

        // ── Onboarding ─────────────────────────────────────────────────────
        AppRoutes.OnboardingFlow:    (_) => const OnboardingFlow(),
        AppRoutes.onboarding2:       (_) => const OnboardingWearable(),
        AppRoutes.onboarding5:       (_) => const OnboardingRPPG(),
        AppRoutes.onboardingDone:    (_) => const OnboardingComplete(),

        // ── Dashboard ──────────────────────────────────────────────────────
        AppRoutes.dashboard:         (_) => const DashboardScreen(),

        // ── Check-ins ──────────────────────────────────────────────────────
        AppRoutes.morningCheckin:    (_) => const MorningCheckinScreen(),
        AppRoutes.eveningCheckin:    (_) => const EveningCheckinScreen(),

        // ── Cycle ──────────────────────────────────────────────────────────
        AppRoutes.periodLog:         (_) => const PeriodLogScreen(),
        AppRoutes.cycleCalendar:     (_) => const CycleCalendarScreen(),

        // ── Weekly Tools ───────────────────────────────────────────────────
        AppRoutes.weeklyTools:       (_) => const WeeklyToolsScreen(),
        AppRoutes.mfgScreen:         (_) => const MfgScreen(),
        AppRoutes.phq4Screen:        (_) => const Phq4Screen(),

        // ── Clinical ───────────────────────────────────────────────────────
        AppRoutes.labUpload:         (_) => const LabUploadScreen(),
        AppRoutes.ultrasoundUpload:  (_) => const UltrasoundUploadScreen(),
        AppRoutes.clinicalStatus:    (_) => const ClinicalStatusScreen(),

        // ── Risk ───────────────────────────────────────────────────────────
        AppRoutes.riskScore:         (_) => const RiskScoreScreen(),
        AppRoutes.riskTrend:         (_) => const RiskTrendScreen(),
        AppRoutes.shapDetail:        (_) => const ShapDetailScreen(),
        AppRoutes.triageNoLabs:      (_) => const TriageNoLabsScreen(),

        // ── Referral & PDF ─────────────────────────────────────────────────
        AppRoutes.referral:          (_) => const ReferralScreen(),
        AppRoutes.clinicalPdf:       (_) => const ClinicalPdfScreen(),

        // ── Profile ────────────────────────────────────────────────────────
        AppRoutes.profile:           (_) => const ProfileScreen(),

        // ── Settings ───────────────────────────────────────────────────────
        AppRoutes.notifications:     (_) => const NotificationSettingsScreen(),
        AppRoutes.privacy:           (_) => const DataPrivacyScreen(),
        AppRoutes.devices:           (_) => const ConnectedDevicesScreen(),

        // ── Clinician (stubbed) ────────────────────────────────────────────
        AppRoutes.clinicianLogin:    (_) => const _StubScreen(title: 'Clinician Login'),
        AppRoutes.clinicianPanel:    (_) => const _StubScreen(title: 'Clinician Panel'),
        AppRoutes.patientDetail:     (_) => const _StubScreen(title: 'Patient Detail'),
        AppRoutes.clinicianPdf:      (_) => const _StubScreen(title: 'Clinician PDF'),
        AppRoutes.patientTimeline:   (_) => const _StubScreen(title: 'Patient Timeline'),
      },
    );
  }
}

class _StubScreen extends StatelessWidget {
  final String title;
  const _StubScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF1A2B2B),
        elevation: 0,
      ),
      body: Center(
        child: Text(
          '$title — coming soon',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}