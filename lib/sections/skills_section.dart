import 'package:flutter/material.dart';
import '../data/skills_data.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_box.dart';
import '../widgets/section_heading.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  int? _activeFilterIndex; // null = all visible at once

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktopLarge = size.width >= 1150;
    final isDesktop = size.width >= 900 && size.width < 1150;
    final isTablet = size.width >= 600 && size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final displayedGroups = _activeFilterIndex == null
        ? SkillsData.skillGroups
        : [SkillsData.skillGroups[_activeFilterIndex!]];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktopLarge ? 32 : 20,
        vertical: 48,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Section Heading (Compact & Refined)
              const SectionHeading(
                kicker: 'TECHNICAL TOOLSET',
                title: 'Skills & Capabilities',
                subtitle:
                    'Modular overview of core engineering stacks, machine learning tools, and workflows.',
              ),
              const SizedBox(height: 24),

              // Filter Tabs (Allows quick switching or "All at Once")
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _buildFilterTab(
                    context: context,
                    label: 'All at a Glance',
                    isSelected: _activeFilterIndex == null,
                    onTap: () => setState(() => _activeFilterIndex = null),
                    isDark: isDark,
                  ),
                  ...List.generate(SkillsData.skillGroups.length, (idx) {
                    final group = SkillsData.skillGroups[idx];
                    return _buildFilterTab(
                      context: context,
                      label: group.title.replaceAll(' Development', '').replaceAll(' & Workflows', ''),
                      isSelected: _activeFilterIndex == idx,
                      onTap: () => setState(() => _activeFilterIndex = idx),
                      isDark: isDark,
                    );
                  }),
                ],
              ),
              const SizedBox(height: 28),

              // Compact Layout: All Cards visible at once!
              LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;

                  // If filtered down to 1 group, give it a centered comfortable container
                  if (_activeFilterIndex != null) {
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: _CompactSkillCard(
                          group: displayedGroups.first,
                          isDark: isDark,
                          isFullWidth: true,
                        ),
                      ),
                    );
                  }

                  // 5-Column Grid on large desktop: All 5 cards fit horizontally side-by-side!
                  if (isDesktopLarge) {
                    const spacing = 14.0;
                    final itemWidth = (totalWidth - (4 * spacing)) / 5;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: SkillsData.skillGroups.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final group = entry.value;
                        final isLast = idx == SkillsData.skillGroups.length - 1;
                        return Padding(
                          padding: EdgeInsets.only(right: isLast ? 0 : spacing),
                          child: SizedBox(
                            width: itemWidth,
                            child: _CompactSkillCard(
                              group: group,
                              isDark: isDark,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }

                  // Desktop (900-1149px): 3 top / 2 bottom compact layout
                  if (isDesktop) {

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: SkillsData.skillGroups.take(3).map((group) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: _CompactSkillCard(
                                  group: group,
                                  isDark: isDark,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: SkillsData.skillGroups.skip(3).map((group) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: _CompactSkillCard(
                                  group: group,
                                  isDark: isDark,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }

                  // Tablet (600-899px): 2 columns compact grid
                  if (isTablet) {
                    const spacing = 14.0;
                    final itemWidth = (totalWidth - spacing) / 2;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: SkillsData.skillGroups.map((group) {
                        return SizedBox(
                          width: itemWidth,
                          child: _CompactSkillCard(
                            group: group,
                            isDark: isDark,
                          ),
                        );
                      }).toList(),
                    );
                  }

                  // Mobile (<600px): Compact stacked cards
                  return Column(
                    children: SkillsData.skillGroups.map((group) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _CompactSkillCard(
                          group: group,
                          isDark: isDark,
                          isFullWidth: true,
                        ),
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

  Widget _buildFilterTab({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.goldPrimary
              : (isDark
                  ? const Color(0xFF1E212A).withValues(alpha: 0.65)
                  : Colors.white.withValues(alpha: 0.65)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.goldPrimary
                : AppColors.goldMuted.withValues(alpha: 0.35),
            width: 1.1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.goldPrimary.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.bodySans(
            context: context,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.textDark : AppColors.textLight),
          ),
        ),
      ),
    );
  }
}

/// Compact Glass Box Skill Card
class _CompactSkillCard extends StatefulWidget {
  final SkillGroup group;
  final bool isDark;
  final bool isFullWidth;

  const _CompactSkillCard({
    required this.group,
    required this.isDark,
    this.isFullWidth = false,
  });

  @override
  State<_CompactSkillCard> createState() => _CompactSkillCardState();
}

class _CompactSkillCardState extends State<_CompactSkillCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? AppColors.goldPrimary
                : AppColors.goldMuted.withValues(alpha: widget.isDark ? 0.35 : 0.4),
            width: _isHovered ? 1.4 : 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: (widget.isDark ? Colors.black : const Color(0xFF8C795A))
                  .withValues(alpha: _isHovered ? 0.22 : 0.08),
              blurRadius: _isHovered ? 20 : 10,
              offset: Offset(0, _isHovered ? 6 : 3),
            ),
            if (_isHovered)
              BoxShadow(
                color: AppColors.goldPrimary.withValues(alpha: 0.2),
                blurRadius: 14,
                spreadRadius: 1,
              ),
          ],
        ),
        child: GlassBox(
          enableHover: false, // already handling hover on outer container
          borderRadius: 16,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header: Icon + Category Name
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.goldPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.goldPrimary.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      widget.group.icon,
                      color: AppColors.goldPrimary,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.group.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headingSerif(
                        context: context,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: widget.isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Thin Golden Accent Line
              Container(
                height: 1,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.goldPrimary.withValues(alpha: 0.5),
                      AppColors.goldPrimary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Compact Skill Chips
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.group.skills.map((skill) {
                  return _CompactSkillChip(
                    skill: skill,
                    isDark: widget.isDark,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactSkillChip extends StatefulWidget {
  final String skill;
  final bool isDark;

  const _CompactSkillChip({required this.skill, required this.isDark});

  @override
  State<_CompactSkillChip> createState() => _CompactSkillChipState();
}

class _CompactSkillChipState extends State<_CompactSkillChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.5),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.goldPrimary.withValues(alpha: widget.isDark ? 0.28 : 0.16)
              : (widget.isDark
                  ? const Color(0xFF1E2129).withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.7)),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: _isHovered
                ? AppColors.goldPrimary
                : (widget.isDark
                    ? AppColors.borderDark
                    : AppColors.borderLight),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.goldPrimary.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          widget.skill,
          style: AppTypography.bodySans(
            context: context,
            fontSize: 11,
            fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
            color: _isHovered
                ? AppColors.goldPrimary
                : (widget.isDark ? AppColors.textDark : AppColors.textLight),
          ),
        ),
      ),
    );
  }
}
