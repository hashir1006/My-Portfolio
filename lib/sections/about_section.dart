import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/section_heading.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

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
              // Section Heading
              SectionHeading(
                kicker: 'ABOUT ME',
                title: PortfolioData.aboutHeading,
                subtitle: PortfolioData.aboutSubheading,
              ),
              const SizedBox(height: 52),

              // Main Bio Card with Parchment Surface & Decorative Borders
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
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(isDesktop ? 48 : 28),
                child: Column(
                  children: [
                    // Bio Paragraphs
                    ...PortfolioData.aboutParagraphs.map((paragraph) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Text(
                          paragraph,
                          textAlign: TextAlign.start,
                          style: AppTypography.bodySans(
                            context: context,
                            fontSize: 16,
                            height: 1.75,
                            color: isDark ? AppColors.textDark : AppColors.textLight,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),

                    // Divider with subtle gold accent
                    Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.goldPrimary.withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Compact Verified Stats Row
                    isDesktop
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: PortfolioData.stats.map((stat) {
                              return _buildStatCard(context, stat, isDark);
                            }).toList(),
                          )
                        : Column(
                            children: PortfolioData.stats.map((stat) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: _buildStatCard(context, stat, isDark),
                              );
                            }).toList(),
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

  Widget _buildStatCard(
    BuildContext context,
    Map<String, String> stat,
    bool isDark,
  ) {
    return Container(
      constraints: const BoxConstraints(minWidth: 220),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkElevated : AppColors.surfaceLightAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stat['value']!,
            style: AppTypography.headingSerif(
              context: context,
              fontSize: 42,
              fontWeight: FontWeight.w700,
              color: AppColors.goldPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stat['label']!,
            textAlign: TextAlign.center,
            style: AppTypography.bodySans(
              context: context,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat['sub']!,
            textAlign: TextAlign.center,
            style: AppTypography.bodySans(
              context: context,
              fontSize: 12,
              color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
            ),
          ),
        ],
      ),
    );
  }
}
