class AppRoutes {
  AppRoutes._();

  static const String splash                  = '/';
  static const String welcome                 = '/welcome';
  static const String login                   = '/login';
  static const String signup                  = '/signup';
  static const String clinicianLogin          = '/clinician-login';
  static const String forgotPassword          = '/forgot-password';
  static const String emailVerify             = '/email-verify';
  static const String OnboardingFlow          = '/onboard';
  static const String onboarding2             = '/onboarding/2';
  static const String onboarding3             = '/onboarding/3';
  static const String onboarding4             = '/onboarding/4';
  static const String onboarding5             = '/onboarding/5';
  static const String onboardingDone          = '/onboarding/done';
  static const String dashboard               = '/dashboard';
  static const String morningCheckin          = '/checkin/morning';
  // afternoonCheckin removed — afternoon slot now shows Morning Check-In
  static const String eveningCheckin          = '/checkin/evening';
  static const String periodLog               = '/cycle/log';
  static const String cycleCalendar           = '/cycle/calendar';
  static const String mfgScreen               = '/tools/mfg';
  static const String phq4Screen              = '/tools/phq4';
  static const String affectGridScreen        = '/tools/affect-grid';
  static const String cognitiveLoadScreen     = '/tools/cognitive-load';
  static const String sleepSatisfactionScreen = '/tools/sleep-satisfaction';
  static const String labUpload               = '/clinical/labs';
  static const String ultrasoundUpload        = '/clinical/ultrasound';
  static const String clinicalStatus          = '/clinical/status';
  static const String riskScore               = '/risk/score';
  static const String riskTrend               = '/risk/trend';
  static const String shapDetail              = '/risk/shap';
  static const String triageNoLabs            = '/risk/triage';
  static const String referral                = '/referral';
  static const String clinicalPdf             = '/referral/pdf';
  static const String profile                 = '/profile';
  static const String notifications           = '/settings/notifications';
  static const String privacy                 = '/settings/privacy';
  static const String devices                 = '/settings/devices';
  static const String clinicianPanel          = '/clinician/panel';
  static const String patientDetail           = '/clinician/patient';
  static const String clinicianPdf            = '/clinician/pdf';
  static const String patientTimeline         = '/clinician/timeline';
  static const String weeklyTools             = '/tools';
}