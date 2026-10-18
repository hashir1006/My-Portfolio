import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import 'glass_button.dart';

class FooterWidget extends StatelessWidget {
  final Function(String sectionId) onSectionSelected;

  const FooterWidget({super.key, required this.onSectionSelected});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentYear = DateTime.now().year;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLightAlt,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1140),
          child: Column(
            children: [
              // Monogram & Name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.goldPrimary, width: 1.5),
                      color: AppColors.goldPrimary.withValues(alpha: 0.1),
                    ),
                    child: Center(
                      child: Text(
                        'H',
                        style: AppTypography.headingSerif(
                          context: context,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.goldPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    PortfolioData.fullName,
                    style: AppTypography.headingSerif(
                      context: context,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Computer Science & AI/ML Student • Mumbai, India',
                style: AppTypography.bodySans(
                  context: context,
                  fontSize: 13.5,
                  color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
                ),
              ),
              const SizedBox(height: 24),

              // Navigation Links
              Wrap(
                spacing: 24,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _footerNavLink(context, 'Home', 'home'),
                  _footerNavLink(context, 'About', 'about'),
                  _footerNavLink(context, 'Projects', 'projects'),
                  _footerNavLink(context, 'Skills', 'skills'),
                  _footerNavLink(context, 'Experience', 'experience'),
                  _footerNavLink(context, 'Contact', 'contact'),
                ],
              ),
              const SizedBox(height: 28),

              // Social Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GlassIconButton(
                    icon: Icons.code_rounded,
                    tooltip: 'GitHub',
                    onPressed: () => _launchUrl(PortfolioData.githubUrl),
                  ),
                  const SizedBox(width: 12),
                  GlassIconButton(
                    icon: Icons.work_outline_rounded,
                    tooltip: 'LinkedIn',
                    onPressed: () => _launchUrl(PortfolioData.linkedinUrl),
                  ),
                  const SizedBox(width: 12),
                  GlassIconButton(
                    icon: Icons.camera_alt_outlined,
                    tooltip: 'Instagram',
                    onPressed: () => _launchUrl(PortfolioData.instagramUrl),
                  ),
                  const SizedBox(width: 12),
                  GlassIconButton(
                    icon: Icons.mail_outline_rounded,
                    tooltip: 'Email',
                    onPressed: () => _launchUrl('mailto:${PortfolioData.contactEmail}'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Divider
              Container(
                width: 120,
                height: 1,
                color: AppColors.goldMuted.withValues(alpha: 0.35),
              ),
              const SizedBox(height: 20),

              // Tagline & Copyright
              Text(
                'Built with purpose and curiosity.',
                style: AppTypography.headingSerif(
                  context: context,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.goldPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '© $currentYear Hashir Shaikh. All rights reserved.',
                style: AppTypography.bodySans(
                  context: context,
                  fontSize: 12,
                  color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footerNavLink(BuildContext context, String title, String sectionId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => onSectionSelected(sectionId),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          title,
          style: AppTypography.bodySans(
            context: context,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
      ),
    );
  }
}
