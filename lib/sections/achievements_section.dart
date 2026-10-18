import 'package:flutter/material.dart';
import '../data/achievements_data.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_box.dart';
import '../widgets/section_heading.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

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
          constraints: const BoxConstraints(maxWidth: 1140),
          child: Column(
            children: [
              SectionHeading(
                kicker: 'HACKATHONS & MILESTONES',
                title: AchievementsData.heading,
                subtitle: AchievementsData.intro,
              ),
              const SizedBox(height: 44),

              // Achievement Cards Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 800 ? 2 : 1;
                  const spacing = 20.0;
                  final itemWidth = (constraints.maxWidth -
                          (crossAxisCount - 1) * spacing) /
                      crossAxisCount;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: AchievementsData.achievements.map((item) {
                      return SizedBox(
                        width: itemWidth,
                        child: _AchievementCard(item: item, isDark: isDark),
                      );
                    }).toList(),
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

class _AchievementCard extends StatelessWidget {
  final AchievementItem item;
  final bool isDark;

  const _AchievementCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      borderRadius: 20,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Metric & Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.goldPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.goldPrimary.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Icon(
                      item.icon,
                      color: AppColors.goldPrimary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    item.metric,
                    style: AppTypography.headingSerif(
                      context: context,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.goldPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.goldPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.goldPrimary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  item.badge,
                  style: AppTypography.labelSpaced(
                    context: context,
                    fontSize: 10.5,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            item.title,
            style: AppTypography.headingSerif(
              context: context,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            item.description,
            style: AppTypography.bodySans(
              context: context,
              fontSize: 14,
              height: 1.6,
              color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
            ),
          ),
        ],
      ),
    );
  }
}
