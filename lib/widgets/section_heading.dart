import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'persian_decorations.dart';

class SectionHeading extends StatelessWidget {
  final String kicker;
  final String title;
  final String? subtitle;
  final bool centerAlign;

  const SectionHeading({
    super.key,
    required this.kicker,
    required this.title,
    this.subtitle,
    this.centerAlign = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          centerAlign ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Persian star ornament & kicker
        PersianStarOrnament(
          text: kicker,
          color: AppColors.goldPrimary,
          showDivider: true,
        ),
        const SizedBox(height: 12),

        // Main serif title
        Text(
          title,
          textAlign: centerAlign ? TextAlign.center : TextAlign.start,
          style: AppTypography.headingSerif(
            context: context,
            fontSize: 38,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),

        // Subtitle
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              subtitle!,
              textAlign: centerAlign ? TextAlign.center : TextAlign.start,
              style: AppTypography.bodySans(
                context: context,
                fontSize: 15.5,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
                height: 1.6,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
