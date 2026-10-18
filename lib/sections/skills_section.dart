import 'package:flutter/material.dart';
import '../data/skills_data.dart';
import '../theme/app_theme.dart';
import '../widgets/section_heading.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

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
              const SectionHeading(
                kicker: 'TECHNICAL CAPABILITIES',
                title: 'Skills & Toolset',
                subtitle:
                    'Technologies and frameworks employed across full-stack development, mobile architecture, and machine learning pipelines.',
              ),
              const SizedBox(height: 52),

              // Responsive Grid of Skill Groups
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 960
                      ? 3
                      : (constraints.maxWidth >= 640 ? 2 : 1);

                  return Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: SkillsData.skillGroups.map((group) {
                      final itemWidth = (constraints.maxWidth -
                              (crossAxisCount - 1) * 24) /
                          crossAxisCount;
                      return SizedBox(
                        width: itemWidth,
                        child: _SkillGroupCard(group: group, isDark: isDark),
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

class _SkillGroupCard extends StatefulWidget {
  final SkillGroup group;
  final bool isDark;

  const _SkillGroupCard({required this.group, required this.isDark});

  @override
  State<_SkillGroupCard> createState() => _SkillGroupCardState();
}

class _SkillGroupCardState extends State<_SkillGroupCard> {
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
        padding: const EdgeInsets.all(24),
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
                  .withValues(alpha: _isHovered ? 0.14 : 0.05),
              blurRadius: _isHovered ? 18 : 8,
              offset: Offset(0, _isHovered ? 6 : 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Header Icon & Title
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.goldPrimary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.goldPrimary.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Icon(
                    widget.group.icon,
                    color: AppColors.goldPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.group.title,
                    style: AppTypography.headingSerif(
                      context: context,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: widget.isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Skill Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.group.skills.map((skill) {
                return _SkillChip(skill: skill, isDark: widget.isDark);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillChip extends StatefulWidget {
  final String skill;
  final bool isDark;

  const _SkillChip({required this.skill, required this.isDark});

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.goldPrimary.withValues(alpha: widget.isDark ? 0.25 : 0.12)
              : (widget.isDark
                  ? AppColors.surfaceDarkElevated
                  : AppColors.surfaceLightAlt),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isHovered
                ? AppColors.goldPrimary
                : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
            width: 1,
          ),
        ),
        child: Text(
          widget.skill,
          style: AppTypography.bodySans(
            context: context,
            fontSize: 13,
            fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w400,
            color: _isHovered
                ? AppColors.goldPrimary
                : (widget.isDark ? AppColors.textDark : AppColors.textLight),
          ),
        ),
      ),
    );
  }
}
