import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_box.dart';
import '../widgets/section_heading.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 960;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget buildCapIcon(double iconBoxSize, double iconSize, double radius) {
      return Container(
        width: iconBoxSize,
        height: iconBoxSize,
        decoration: BoxDecoration(
          color: AppColors.goldPrimary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: AppColors.goldPrimary.withValues(alpha: 0.4),
            width: 1.2,
          ),
        ),
        child: Icon(
          Icons.school_rounded,
          color: AppColors.goldPrimary,
          size: iconSize,
        ),
      );
    }

    Widget buildDurationBadge() {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: AppColors.goldPrimary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.goldPrimary.withValues(alpha: 0.35),
          ),
        ),
        child: Text(
          PortfolioData.studyDuration,
          style: AppTypography.bodySans(
            context: context,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColors.goldPrimary,
          ),
        ),
      );
    }

    Widget buildAcademicDetails() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            PortfolioData.degree,
            style: AppTypography.bodySans(
              context: context,
              fontSize: isDesktop ? 16 : 14.5,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.goldMuted : AppColors.goldDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Specialization: ${PortfolioData.department}',
            style: AppTypography.bodySans(
              context: context,
              fontSize: 14,
              color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
            ),
          ),
          const SizedBox(height: 8),

          // Location Pin
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 15,
                color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  PortfolioData.location,
                  style: AppTypography.bodySans(
                    context: context,
                    fontSize: 12.5,
                    color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Key Subjects / Focus Areas
          Text(
            'Core Academic Focus:',
            style: AppTypography.bodySans(
              context: context,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PortfolioData.relevantCoursework.map((course) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDarkElevated
                      : AppColors.surfaceLightAlt,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
                child: Text(
                  course,
                  style: AppTypography.bodySans(
                    context: context,
                    fontSize: 12,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 36 : (size.width < 400 ? 16 : 24),
        vertical: 64,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              const SectionHeading(
                kicker: 'ACADEMIC PATHWAY',
                title: 'Education',
                subtitle: 'Formative engineering foundation in Computer Science and Artificial Intelligence.',
              ),
              const SizedBox(height: 48),

              // Education Timeline / Card
              GlassBox(
                borderRadius: 24,
                padding: EdgeInsets.all(isDesktop ? 38 : (size.width < 400 ? 18 : 22)),
                child: size.width < 580
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildCapIcon(46, 24, 14),
                              buildDurationBadge(),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            PortfolioData.institution,
                            style: AppTypography.headingSerif(
                              context: context,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textDark : AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          buildAcademicDetails(),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildCapIcon(56, 28, 16),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 12,
                                  runSpacing: 8,
                                  children: [
                                    Text(
                                      PortfolioData.institution,
                                      style: AppTypography.headingSerif(
                                        context: context,
                                        fontSize: isDesktop ? 26 : 21,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? AppColors.textDark : AppColors.textLight,
                                      ),
                                    ),
                                    buildDurationBadge(),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                buildAcademicDetails(),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
