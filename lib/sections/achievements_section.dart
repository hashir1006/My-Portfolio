import 'package:flutter/material.dart';
import '../data/achievements_data.dart';
import '../theme/app_theme.dart';
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
        vertical: 72,
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
              const SizedBox(height: 52),

              // Achievement Cards Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 800 ? 2 : 1;
                  const spacing = 24.0;
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

class _AchievementCard extends StatefulWidget {
  final AchievementItem item;
  final bool isDark;

  const _AchievementCard({required this.item, required this.isDark});

  @override
  State<_AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<_AchievementCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? AppColors.goldPrimary
                : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
            width: _isHovered ? 1.4 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: (widget.isDark ? Colors.black : const Color(0xFF8A7758))
                  .withValues(alpha: _isHovered ? 0.12 : 0.05),
              blurRadius: _isHovered ? 18 : 8,
              offset: Offset(0, _isHovered ? 6 : 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(28),
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
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.goldPrimary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.goldPrimary.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Icon(
                        widget.item.icon,
                        color: AppColors.goldPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      widget.item.metric,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.goldPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.goldPrimary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    widget.item.badge,
                    style: AppTypography.labelSpaced(
                      context: context,
                      fontSize: 10.5,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Title
            Text(
              widget.item.title,
              style: AppTypography.headingSerif(
                context: context,
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: widget.isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              widget.item.description,
              style: AppTypography.bodySans(
                context: context,
                fontSize: 14.5,
                height: 1.6,
                color: widget.isDark
                    ? AppColors.mutedTextDark
                    : AppColors.mutedTextLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
