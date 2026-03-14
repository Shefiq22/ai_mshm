import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle splashBrand = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w700,
    letterSpacing: 3.0, color: AppColors.brandLabel,
  );
  static const TextStyle splashTitle = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w800,
    letterSpacing: 1.5, color: AppColors.textDark,
  );
  static const TextStyle splashSubtitle = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w400,
    letterSpacing: 0.5, color: AppColors.textMedium,
  );
  static const TextStyle welcomeHeadline = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w800,
    color: AppColors.textDark, height: 1.2,
  );
  static const TextStyle welcomeAccent = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w800,
    color: AppColors.primary, height: 1.2,
  );
  static const TextStyle welcomeBody = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w400,
    color: AppColors.textMedium, height: 1.6,
  );
  static const TextStyle screenTitle = TextStyle(
    fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textDark,
  );
  static const TextStyle screenSubtitle = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textMedium, height: 1.5,
  );
  static const TextStyle brandSmall = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w800,
    letterSpacing: 2.0, color: AppColors.brandLabel,
  );
  static const TextStyle backArrow = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textMedium,
  );
  static const TextStyle inputLabel = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark,
  );
  static const TextStyle inputText = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark,
  );
  static const TextStyle linkText = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary,
  );
  static const TextStyle smallText = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textMedium,
  );
  static const TextStyle buttonText = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w700,
    color: Colors.white, letterSpacing: 0.3,
  );
  static const TextStyle featureTitle = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark,
  );
  static const TextStyle featureSubtitle = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textMedium,
  );
  static const TextStyle greeting = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textMedium,
  );
  static const TextStyle greetingName = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark,
  );
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark,
  );
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textMedium,
  );
  static const TextStyle riskScore = TextStyle(
    fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.riskModerate,
  );
  static const TextStyle riskLabel = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.riskModerate,
  );
  static const TextStyle percentage = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textMedium,
  );
  static const TextStyle percentagePrimary = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary,
  );
  static const TextStyle sectionLabel = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textMedium,
  );
  static const TextStyle detailsLink = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary,
  );
  static const TextStyle activityTitle = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark,
  );
  static const TextStyle activityTime = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textLight,
  );
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark,
  );
  // Alias so DashboardScreen compiles without changes
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark,
  );
  static const TextStyle bodyText = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textMedium, height: 1.6,
  );
  static const TextStyle tabLabel = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w600,
  );
  static const TextStyle stepLabel = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textLight,
  );
  static const TextStyle biomarkerValue = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark,
  );
  static const TextStyle biomarkerUnit = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textMedium,
  );
  static const TextStyle badgeText = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w700,
    color: Colors.white, letterSpacing: 0.3,
  );
  static const TextStyle inputHint = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textHint,
  );
}