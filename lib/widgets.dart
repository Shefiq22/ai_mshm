import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_textstyles.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(label, style: AppTextStyles.buttonText),
        ),
      ),
    );
  }
}

class BackRow extends StatelessWidget {
  final String label;
  const BackRow({super.key, this.label = 'Back'});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.textMedium),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.backArrow),
        ],
      ),
    );
  }
}

class BrandBadge extends StatelessWidget {
  const BrandBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('MSHM', style: AppTextStyles.brandSmall);
  }
}

class DashCard extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsets? padding;

  const DashCard({
    super.key,
    required this.title,
    this.trailing,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.cardTitle),
              if (trailing != null) trailing!,
            ],
          ),
          child,
        ],
      ),
    );
  }
}

class LayerProgress extends StatelessWidget {
  final String label;
  final double percent;

  const LayerProgress({
    super.key,
    required this.label,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.sectionLabel),
            Text('${(percent * 100).toInt()}%', style: AppTextStyles.percentage),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 6,
            backgroundColor: AppColors.progressBg,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.progressFill),
          ),
        ),
      ],
    );
  }
}

class RiskBadge extends StatelessWidget {
  final String tier;
  const RiskBadge({super.key, required this.tier});

  Color get _color {
    switch (tier.toLowerCase()) {
      case 'low':
        return AppColors.riskLow;
      case 'moderate':
        return AppColors.riskModerate;
      case 'high':
        return AppColors.riskHigh;
      case 'critical':
        return AppColors.riskCritical;
      default:
        return AppColors.textLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tier,
        style: AppTextStyles.badgeText.copyWith(color: _color),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.sectionHeader),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: AppTextStyles.screenSubtitle),
        ],
      ],
    );
  }
}

class IconCircle extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double size;

  const IconCircle({super.key, required this.icon, this.color, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: c, size: size * 0.45),
    );
  }
}

class StepProgress extends StatelessWidget {
  final int current;
  final int total;

  const StepProgress({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(
            total,
            (i) => Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: i < current ? AppColors.primary : AppColors.progressBg,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text('Step $current of $total', style: AppTextStyles.stepLabel),
      ],
    );
  }
}

class VasCard extends StatefulWidget {
  final String label;
  final String leftLabel;
  final String rightLabel;
  final double initialValue;
  final ValueChanged<double> onChanged;

  const VasCard({
    super.key,
    required this.label,
    required this.leftLabel,
    required this.rightLabel,
    this.initialValue = 5,
    required this.onChanged,
  });

  @override
  State<VasCard> createState() => _VasCardState();
}

class _VasCardState extends State<VasCard> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: AppTextStyles.cardTitle),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.progressBg,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.1),
              trackHeight: 6,
            ),
            child: Slider(
              value: _value,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v) {
                setState(() => _value = v);
                widget.onChanged(v);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.leftLabel, style: AppTextStyles.smallText),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _value.toInt().toString(),
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(widget.rightLabel, style: AppTextStyles.smallText),
            ],
          ),
        ],
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value;
  final Color color;

  GaugePainter({required this.value, this.color = AppColors.riskModerate});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.65);
    final radius = size.width * 0.42;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159,
      3.14159,
      false,
      Paint()
        ..color = AppColors.progressBg
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159,
      3.14159 * value,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class WaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final wave1 = Paint()
      ..color = AppColors.primary.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    final wave2 = Paint()
      ..color = AppColors.primary.withOpacity(0.22)
      ..style = PaintingStyle.fill;
    final line = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final p1 = Path()
      ..moveTo(0, size.height * 0.6)
      ..cubicTo(
        size.width * .2, size.height * .3,
        size.width * .4, size.height * .8,
        size.width * .6, size.height * .4,
      )
      ..cubicTo(
        size.width * .8, size.height * .1,
        size.width * .9, size.height * .5,
        size.width, size.height * .45,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(p1, wave1);

    final p2 = Path()
      ..moveTo(0, size.height * 0.75)
      ..cubicTo(
        size.width * .25, size.height * .55,
        size.width * .5, size.height * .9,
        size.width * .7, size.height * .6,
      )
      ..cubicTo(
        size.width * .85, size.height * .4,
        size.width * .95, size.height * .65,
        size.width, size.height * .6,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(p2, wave2);

    final ecg = Path()
      ..moveTo(0, size.height * .5)
      ..lineTo(size.width * .25, size.height * .5)
      ..lineTo(size.width * .35, size.height * .5 - size.height * .25)
      ..lineTo(size.width * .4, size.height * .5 + size.height * .15)
      ..lineTo(size.width * .45, size.height * .5 - size.height * .05)
      ..lineTo(size.width * .5, size.height * .5);
    ecg.cubicTo(
      size.width * .6, size.height * .4,
      size.width * .75, size.height * .58,
      size.width, size.height * .5,
    );
    canvas.drawPath(ecg, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}