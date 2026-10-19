import 'package:flutter/material.dart';
import '../data/experience_data.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_box.dart';
import '../widgets/section_heading.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 960;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final experiences = ExperienceData.activeExperiences;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 36 : 24,
        vertical: 72,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              const SectionHeading(
                kicker: 'EXPERIENCE & LEADERSHIP',
                title: 'Experience & Practical Roles',
                subtitle:
                    'Hands-on technical leadership, collaborative engineering sprints, and project architecture.',
              ),
              const SizedBox(height: 52),

              // Timeline of Verified Roles
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: experiences.length,
                separatorBuilder: (context, index) => const SizedBox(height: 24),
                itemBuilder: (context, index) {
                  final item = experiences[index];
                  return GlassBox(
                    borderRadius: 20,
                    padding: EdgeInsets.all(isDesktop ? 36 : 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row with Role & Period
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.goldPrimary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.goldPrimary.withValues(alpha: 0.35),
                                ),
                              ),
                              child: const Icon(
                                Icons.workspace_premium_rounded,
                                color: AppColors.goldPrimary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.spaceBetween,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 12,
                                    runSpacing: 6,
                                    children: [
                                      Text(
                                        item.role,
                                        style: AppTypography.headingSerif(
                                          context: context,
                                          fontSize: isDesktop ? 22 : 19,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? AppColors.textDark
                                              : AppColors.textLight,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.goldPrimary
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          item.period,
                                          style: AppTypography.bodySans(
                                            context: context,
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.goldPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.organization} • ${item.location}',
                                    style: AppTypography.bodySans(
                                      context: context,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? AppColors.goldMuted
                                          : AppColors.goldDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.type,
                                    style: AppTypography.labelSpaced(
                                      context: context,
                                      fontSize: 11,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Responsibilities
                        ...item.responsibilities.map((resp) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 7, right: 10),
                                  child: Icon(
                                    Icons.arrow_right_rounded,
                                    size: 16,
                                    color: AppColors.goldPrimary,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    resp,
                                    style: AppTypography.bodySans(
                                      context: context,
                                      fontSize: 14.5,
                                      height: 1.6,
                                      color: isDark
                                          ? AppColors.textDark
                                          : AppColors.textLight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 14),

                        // Technologies
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: item.technologies.map((t) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.surfaceDarkElevated
                                    : AppColors.surfaceLightAlt,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.borderDark
                                      : AppColors.borderLight,
                                ),
                              ),
                              child: Text(
                                t,
                                style: AppTypography.bodySans(
                                  context: context,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? AppColors.textDark
                                      : AppColors.textLight,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
