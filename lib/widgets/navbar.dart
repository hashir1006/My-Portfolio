import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';
import 'glass_button.dart';

class NavbarItem {
  final String label;
  final String sectionId;

  const NavbarItem({required this.label, required this.sectionId});
}

class NavigationBarWidget extends StatefulWidget {
  final String activeSectionId;
  final Function(String sectionId) onSectionSelected;
  final ThemeController themeController;

  const NavigationBarWidget({
    super.key,
    required this.activeSectionId,
    required this.onSectionSelected,
    required this.themeController,
  });

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  bool _isMobileMenuOpen = false;

  static const List<NavbarItem> navItems = [
    NavbarItem(label: 'Home', sectionId: 'home'),
    NavbarItem(label: 'About', sectionId: 'about'),
    NavbarItem(label: 'Projects', sectionId: 'projects'),
    NavbarItem(label: 'Skills', sectionId: 'skills'),
    NavbarItem(label: 'Experience', sectionId: 'experience'),
    NavbarItem(label: 'Contact', sectionId: 'contact'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 960;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: isDesktop ? 24 : 16,
              vertical: 12,
            ),
            constraints: const BoxConstraints(maxWidth: 1180),
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.navCapsuleLight.withValues(alpha: 0.90),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(
                color: AppColors.goldMuted.withValues(alpha: 0.45),
                width: 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.32),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: AppColors.goldPrimary.withValues(alpha: 0.15),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Monogram & Brand Name
                      _buildBrand(context),

                      if (isDesktop) ...[
                        // Centered Navigation Links
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: navItems.map((item) {
                              final isActive = widget.activeSectionId == item.sectionId;
                              return _buildNavLink(context, item, isActive);
                            }).toList(),
                          ),
                        ),

                        // Action Buttons: "Let's Connect ->" + Theme Selector
                        _buildDesktopActions(context),
                      ] else ...[
                        const Spacer(),
                        // Mobile Theme Toggle
                        _buildThemeButton(context),
                        const SizedBox(width: 8),
                        // Mobile Menu Toggle
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isMobileMenuOpen = !_isMobileMenuOpen;
                            });
                          },
                          icon: Icon(
                            _isMobileMenuOpen ? Icons.close_rounded : Icons.menu_rounded,
                            color: const Color(0xFFF7F2E8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Mobile dropdown drawer
        if (!isDesktop && _isMobileMenuOpen) _buildMobileDrawer(context),
      ],
    );
  }

  Widget _buildBrand(BuildContext context) {
    return InkWell(
      onTap: () => widget.onSectionSelected('home'),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Monogram "H"
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.goldPrimary, width: 1.4),
                color: AppColors.goldPrimary.withValues(alpha: 0.12),
              ),
              child: Center(
                child: Text(
                  'H',
                  style: AppTypography.headingSerif(
                    context: context,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.goldPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'HASHIR SHAIKH',
              style: AppTypography.labelSpaced(
                context: context,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFF7F2E8),
                letterSpacing: 2.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavLink(BuildContext context, NavbarItem item, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () => widget.onSectionSelected(item.sectionId),
        borderRadius: BorderRadius.circular(16),
        hoverColor: Colors.white.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.label,
                style: AppTypography.bodySans(
                  context: context,
                  fontSize: 13.5,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? const Color(0xFFF7F2E8)
                      : const Color(0xFFACA79D),
                ),
              ),
              const SizedBox(height: 3),
              // Golden active dot indicator matching reference image
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isActive ? 5 : 0,
                height: isActive ? 5 : 0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldPrimary,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.goldPrimary.withValues(alpha: 0.8),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // "Let's Connect ->" Glass Pill Button
        GlassButton(
          label: "Let's Connect",
          icon: Icons.mail_outline_rounded,
          trailingIcon: Icons.arrow_forward_rounded,
          variant: GlassButtonVariant.navConnect,
          height: 38,
          borderRadius: 20,
          onPressed: () => widget.onSectionSelected('contact'),
        ),
        const SizedBox(width: 10),

        // Theme Selector
        _buildThemeButton(context),
      ],
    );
  }

  Widget _buildThemeButton(BuildContext context) {
    final mode = widget.themeController.themeMode;
    IconData icon;
    String tooltip;

    switch (mode) {
      case ThemeMode.light:
        icon = Icons.wb_sunny_outlined;
        tooltip = 'Current: Light Mode (Click to change)';
        break;
      case ThemeMode.dark:
        icon = Icons.nightlight_round_outlined;
        tooltip = 'Current: Dark Mode (Click to change)';
        break;
      case ThemeMode.system:
        icon = Icons.brightness_auto_outlined;
        tooltip = 'Current: System Mode (Click to change)';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => widget.themeController.cycleTheme(),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.goldMuted.withValues(alpha: 0.35),
              width: 1.0,
            ),
            color: Colors.white.withValues(alpha: 0.05),
          ),
          child: Icon(
            icon,
            size: 17,
            color: AppColors.goldMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navCapsuleLight.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.goldMuted.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...navItems.map((item) {
            final isActive = widget.activeSectionId == item.sectionId;
            return ListTile(
              title: Text(
                item.label,
                style: AppTypography.bodySans(
                  context: context,
                  fontSize: 15,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  color: isActive ? AppColors.goldPrimary : const Color(0xFFF7F2E8),
                ),
              ),
              trailing: isActive
                  ? const Icon(Icons.check_circle_rounded, color: AppColors.goldPrimary, size: 18)
                  : null,
              onTap: () {
                setState(() => _isMobileMenuOpen = false);
                widget.onSectionSelected(item.sectionId);
              },
            );
          }),
          const SizedBox(height: 12),
          GlassButton(
            label: "Let's Connect",
            icon: Icons.mail_outline_rounded,
            trailingIcon: Icons.arrow_forward_rounded,
            variant: GlassButtonVariant.primaryGold,
            width: double.infinity,
            onPressed: () {
              setState(() => _isMobileMenuOpen = false);
              widget.onSectionSelected('contact');
            },
          ),
        ],
      ),
    );
  }
}
