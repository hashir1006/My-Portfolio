import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/section_heading.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 960;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 36 : 24,
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
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? Colors.black : const Color(0xFF8A7758))
                          .withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(isDesktop ? 40 : 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Graduation Cap Icon Badge
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.goldPrimary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.goldPrimary.withValues(alpha: 0.4),
                          width: 1.2,
                        ),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: AppColors.goldPrimary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 24),

                    // Academic Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  PortfolioData.institution,
                                  style: AppTypography.headingSerif(
                                    context: context,
                                    fontSize: isDesktop ? 26 : 21,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.textDark : AppColors.textLight,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
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
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.goldPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Degree & Specialization
                          Text(
                            PortfolioData.degree,
                            style: AppTypography.bodySans(
                              context: context,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.goldMuted : AppColors.goldDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Specialization: ${PortfolioData.department}',
                            style: AppTypography.bodySans(
                              context: context,
                              fontSize: 14.5,
                              color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Location Pin
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                PortfolioData.location,
                                style: AppTypography.bodySans(
                                  context: context,
                                  fontSize: 13,
                                  color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

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
                                  horizontal: 12,
                                  vertical: 6,
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
                                    fontSize: 12.5,
                                    color: isDark ? AppColors.textDark : AppColors.textLight,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
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
