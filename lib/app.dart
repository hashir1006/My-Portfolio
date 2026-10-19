import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'widgets/navbar.dart';
import 'widgets/footer.dart';
import 'sections/hero_section.dart';
import 'sections/about_section.dart';
import 'sections/education_section.dart';
import 'sections/skills_section.dart';
import 'sections/projects_section.dart';
import 'sections/experience_section.dart';
import 'sections/achievements_section.dart';
import 'sections/contact_section.dart';

class HashirPortfolioApp extends StatelessWidget {
  final ThemeController themeController;

  const HashirPortfolioApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Hashir Shaikh | Computer Science & AI/ML Portfolio',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.trackpad,
            },
          ),
          home: PortfolioHomePage(themeController: themeController),
        );
      },
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  final ThemeController themeController;

  const PortfolioHomePage({super.key, required this.themeController});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _achievementsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  String _activeSectionId = 'home';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateActiveSectionOnScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateActiveSectionOnScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateActiveSectionOnScroll() {
    if (!mounted) return;

    final scrollOffset = _scrollController.offset;
    // Section key mappings
    final sectionKeys = [
      {'id': 'contact', 'key': _contactKey},
      {'id': 'experience', 'key': _experienceKey},
      {'id': 'skills', 'key': _skillsKey},
      {'id': 'projects', 'key': _projectsKey},
      {'id': 'education', 'key': _educationKey},
      {'id': 'about', 'key': _aboutKey},
      {'id': 'home', 'key': _homeKey},
    ];

    for (final item in sectionKeys) {
      final key = item['key'] as GlobalKey;
      final ctx = key.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize) {
          final pos = box.localToGlobal(Offset.zero);
          // If the section top is near the top of the viewport
          if (pos.dy <= 160) {
            final targetId = item['id'] as String;
            if (_activeSectionId != targetId) {
              setState(() {
                _activeSectionId = targetId;
              });
            }
            break;
          }
        }
      }
    }

    if (scrollOffset < 200 && _activeSectionId != 'home') {
      setState(() {
        _activeSectionId = 'home';
      });
    }
  }

  void _scrollToSection(String sectionId) {
    GlobalKey? targetKey;
    switch (sectionId) {
      case 'home':
        targetKey = _homeKey;
        break;
      case 'about':
        targetKey = _aboutKey;
        break;
      case 'education':
        targetKey = _educationKey;
        break;
      case 'skills':
        targetKey = _skillsKey;
        break;
      case 'projects':
        targetKey = _projectsKey;
        break;
      case 'experience':
        targetKey = _experienceKey;
        break;
      case 'achievements':
        targetKey = _achievementsKey;
        break;
      case 'contact':
        targetKey = _contactKey;
        break;
    }

    if (targetKey != null && targetKey.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey.currentContext!,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
        alignment: 0.05,
      );
      setState(() {
        _activeSectionId = sectionId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgImagePath = isDark ? 'assets/images/bg_dark.png' : 'assets/images/bg_light.png';

    return Scaffold(
      body: Stack(
        children: [
          // 0. Fixed Background Image with Progressive Scroll-Driven Blur
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _scrollController,
              builder: (context, _) {
                final offset =
                    _scrollController.hasClients ? _scrollController.offset : 0.0;
                // Progress from 0.0 at top of hero landing page to 1.0 down the page
                final progress = (offset / 1800.0).clamp(0.0, 1.0);
                // Blur: 0.0px on landing page (crystal clear) up to 22.0px at lower pages
                final blurAmount = progress * 22.0;

                return ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: blurAmount,
                    sigmaY: blurAmount,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 700),
                    switchInCurve: Curves.easeInOutCubic,
                    switchOutCurve: Curves.easeInOutCubic,
                    child: Image.asset(
                      bgImagePath,
                      key: ValueKey(bgImagePath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: isDark ? AppColors.bgDark : AppColors.bgLight,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 0.1 Dynamic Veil: High Visibility at Landing Page, Gradually Becoming More Opaque
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _scrollController,
              builder: (context, _) {
                final offset =
                    _scrollController.hasClients ? _scrollController.offset : 0.0;
                final progress = (offset / 1800.0).clamp(0.0, 1.0);

                // High visibility on landing page (low alpha); increases as you scroll down
                final topAlpha = isDark
                    ? (0.16 + (progress * 0.72)).clamp(0.0, 0.92)
                    : (0.12 + (progress * 0.74)).clamp(0.0, 0.90);
                final midAlpha = isDark
                    ? (0.08 + (progress * 0.68)).clamp(0.0, 0.82)
                    : (0.05 + (progress * 0.70)).clamp(0.0, 0.80);
                final btmAlpha = isDark
                    ? (0.22 + (progress * 0.70)).clamp(0.0, 0.94)
                    : (0.18 + (progress * 0.72)).clamp(0.0, 0.92);

                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDark
                          ? [
                              const Color(0xFF0F1014).withValues(alpha: topAlpha),
                              const Color(0xFF13151A).withValues(alpha: midAlpha),
                              const Color(0xFF0C0D11).withValues(alpha: btmAlpha),
                            ]
                          : [
                              const Color(0xFFF7F2E8).withValues(alpha: topAlpha),
                              const Color(0xFFFAF6EE).withValues(alpha: midAlpha),
                              const Color(0xFFF4EDE2).withValues(alpha: btmAlpha),
                            ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 1. Normal vertical scrollable content
          SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                // Top padding to account for floating sticky navbar and mobile notch/status bar
                SizedBox(height: 76 + MediaQuery.of(context).padding.top),

                // Hero Section
                Container(
                  key: _homeKey,
                  child: HeroSection(
                    onKnowMorePressed: () => _scrollToSection('about'),
                    onScrollIndicatorPressed: () => _scrollToSection('about'),
                  ),
                ),

                // About Section
                Container(
                  key: _aboutKey,
                  child: const AboutSection(),
                ),

                // Education Section
                Container(
                  key: _educationKey,
                  child: const EducationSection(),
                ),

                // Technical Skills Section (Compact 5-column Glass Box layout)
                Container(
                  key: _skillsKey,
                  child: const SkillsSection(),
                ),

                // Selected Works / Projects Section
                Container(
                  key: _projectsKey,
                  child: const ProjectsSection(),
                ),

                // Experience & Practical Roles Section
                Container(
                  key: _experienceKey,
                  child: const ExperienceSection(),
                ),

                // Hackathons & Achievements Section
                Container(
                  key: _achievementsKey,
                  child: const AchievementsSection(),
                ),

                // Contact Section
                Container(
                  key: _contactKey,
                  child: const ContactSection(),
                ),

                // Footer
                FooterWidget(
                  onSectionSelected: _scrollToSection,
                ),
              ],
            ),
          ),

          // 2. Sticky Floating Navigation Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: NavigationBarWidget(
                activeSectionId: _activeSectionId,
                onSectionSelected: _scrollToSection,
                themeController: widget.themeController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
