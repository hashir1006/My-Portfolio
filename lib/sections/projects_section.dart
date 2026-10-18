import 'package:flutter/material.dart';
import '../data/projects_data.dart';
import '../theme/app_theme.dart';
import '../widgets/project_card.dart';
import '../widgets/section_heading.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 960;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredProjects = _selectedCategory == 'All'
        ? ProjectsData.projects
        : ProjectsData.projects
            .where((p) => p.category == _selectedCategory)
            .toList();

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
                kicker: 'PORTFOLIO OF WORKS',
                title: 'Selected Works',
                subtitle:
                    'A collection of ideas, experiments, and solutions built through code.',
              ),
              const SizedBox(height: 36),

              // Category Filter Pills
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: ProjectsData.categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.goldPrimary
                            : (isDark
                                ? AppColors.surfaceDark
                                : AppColors.surfaceLightAlt),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.goldPrimary
                              : (isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight),
                          width: 1.2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.goldPrimary.withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        category,
                        style: AppTypography.bodySans(
                          context: context,
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                  ? AppColors.textDark
                                  : AppColors.textLight),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 48),

              // Responsive Project Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 980
                      ? 3
                      : (constraints.maxWidth >= 640 ? 2 : 1);
                  const spacing = 24.0;
                  final itemWidth = (constraints.maxWidth -
                          (crossAxisCount - 1) * spacing) /
                      crossAxisCount;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: filteredProjects.map((project) {
                      return SizedBox(
                        width: itemWidth,
                        child: ProjectCard(project: project),
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
