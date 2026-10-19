import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_box.dart';
import '../widgets/glass_button.dart';
import '../widgets/image_placeholder.dart';
import '../widgets/persian_decorations.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onKnowMorePressed;
  final VoidCallback onScrollIndicatorPressed;

  const HeroSection({
    super.key,
    required this.onKnowMorePressed,
    required this.onScrollIndicatorPressed,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _leftFadeAnimation;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<double> _rightFadeAnimation;
  late Animation<Offset> _rightSlideAnimation;

  @override
  void initState() {
    super.initState();
    // Snappy, fast and smooth entrance animation (~680ms)
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 680),
    );

    // Left description box: Slides in fast from left (-0.45, 0) to center
    _leftFadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.85, curve: Curves.easeOut),
    );

    _leftSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.45, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    // Right portrait cutout: Slides in fast from right (0.45, 0) to center
    _rightFadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.85, curve: Curves.easeOut),
    );

    _rightSlideAnimation = Tween<Offset>(
      begin: const Offset(0.45, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _handleResumeDownload(BuildContext context) async {
    final resumeUri = Uri.parse(PortfolioData.resumeWebUrl);
    try {
      if (await canLaunchUrl(resumeUri)) {
        await launchUrl(resumeUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    // Fallback: Show accessible dialog with direct link & information
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.goldPrimary),
        ),
        title: Row(
          children: const [
            Icon(Icons.description_outlined, color: AppColors.goldPrimary),
            SizedBox(width: 10),
            Text('Curriculum Vitae / Resume'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hashir Shaikh — Computer Science & AI/ML Student\nM. H. Saboo Siddik College of Engineering, Mumbai.',
            ),
            const SizedBox(height: 12),
            const Text(
              'The resume asset is configured at assets/resume/Hashir_Shaikh_Resume.pdf. You can also view GitHub or LinkedIn for up-to-date project records.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.goldPrimary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _launchUrl(PortfolioData.githubUrl);
            },
            child: const Text('Visit GitHub'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 960;
    final isTablet = size.width >= 650 && size.width < 960;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: isDesktop ? (size.height - 70).clamp(620.0, 900.0) : 600,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main Hero Content with Fast Split Slide Animations
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1140),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 36 : 24,
                  vertical: isDesktop ? 48 : 32,
                ),
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left Column: Description Box (Slides from Left to Center)
                          Expanded(
                            flex: 6,
                            child: SlideTransition(
                              position: _leftSlideAnimation,
                              child: FadeTransition(
                                opacity: _leftFadeAnimation,
                                child: _buildLeftHeroContent(context),
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                          // Right Column: Authentic Cutout Portrait (Slides from Right to Center)
                          Expanded(
                            flex: 5,
                            child: SlideTransition(
                              position: _rightSlideAnimation,
                              child: FadeTransition(
                                opacity: _rightFadeAnimation,
                                child: const Center(
                                  child: HeroPortraitCutout(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          // Cutout Portrait slides smoothly from Right to Center on Mobile/Tablet
                          SlideTransition(
                            position: _rightSlideAnimation,
                            child: FadeTransition(
                              opacity: _rightFadeAnimation,
                              child: Center(
                                child: HeroPortraitCutout(
                                  width: isTablet ? 320 : 270,
                                  height: isTablet ? 440 : 380,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Description Box slides smoothly from Left to Center
                          SlideTransition(
                            position: _leftSlideAnimation,
                            child: FadeTransition(
                              opacity: _leftFadeAnimation,
                              child: _buildLeftHeroContent(
                                context,
                                centerOnMobile: true,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          // 4. Center bottom mouse scroll indicator matching reference image
          if (isDesktop)
            Positioned(
              bottom: 16,
              child: InkWell(
                onTap: widget.onScrollIndicatorPressed,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.goldMuted.withValues(alpha: 0.6),
                            width: 1.4,
                          ),
                        ),
                        child: Align(
                          alignment: const Alignment(0, -0.4),
                          child: Container(
                            width: 3.5,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.goldPrimary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 1,
                        height: 12,
                        color: AppColors.goldMuted.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLeftHeroContent(BuildContext context, {bool centerOnMobile = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 960;

    return GlassBox(
      borderRadius: 28,
      blur: 24,
      enableHover: false,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 36 : 24,
        vertical: isDesktop ? 36 : 26,
      ),
      child: Column(
        crossAxisAlignment:
            centerOnMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Small Decorative Label: "✦ BISMILLAH ────────"
          PersianStarOrnament(
            text: PortfolioData.bismillah,
            color: AppColors.goldPrimary,
            showDivider: true,
          ),
          const SizedBox(height: 18),

          // 2. Greeting: "Assalamualaikum, I'm"
          Text(
            PortfolioData.greeting,
            style: AppTypography.headingSerif(
              context: context,
              fontSize: 26,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFFF7F2E8) : AppColors.textLight,
            ).copyWith(
              shadows: isDark
                  ? [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        blurRadius: 10,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(height: 4),

          // 3. Main Heading: "Hashir" in dark charcoal, "Shaikh" in gold (Reference Image)
          RichText(
            textAlign: centerOnMobile ? TextAlign.center : TextAlign.start,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${PortfolioData.name}\n',
                  style: AppTypography.headingSerif(
                    context: context,
                    fontSize: isDesktop ? 62 : 46,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    letterSpacing: -1.0,
                    color: isDark ? Colors.white : AppColors.textLight,
                  ).copyWith(
                    shadows: [
                      Shadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.85)
                            : Colors.white.withValues(alpha: 0.8),
                        blurRadius: 14,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                TextSpan(
                  text: PortfolioData.surname,
                  style: AppTypography.headingSerif(
                    context: context,
                    fontSize: isDesktop ? 62 : 46,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    letterSpacing: -1.0,
                    color: isDark ? const Color(0xFFE5B96E) : AppColors.goldPrimary,
                  ).copyWith(
                    shadows: [
                      Shadow(
                        color: AppColors.goldPrimary.withValues(alpha: 0.65),
                        blurRadius: 18,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4. Professional Subtitle: Highlighted Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.goldPrimary.withValues(alpha: isDark ? 0.20 : 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.goldPrimary.withValues(alpha: 0.45),
                width: 1.1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.goldPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    PortfolioData.heroTitle,
                    textAlign: centerOnMobile ? TextAlign.center : TextAlign.start,
                    style: AppTypography.labelSpaced(
                      context: context,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFFF7F2E8) : AppColors.navySecondary,
                      letterSpacing: 2.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 5. Introduction Paragraphs with High Contrast & Soft Text Glow
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: centerOnMobile
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  PortfolioData.heroBio1,
                  textAlign: centerOnMobile ? TextAlign.center : TextAlign.start,
                  style: AppTypography.bodySans(
                    context: context,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    height: 1.65,
                    color: isDark ? const Color(0xFFF5EFE6) : const Color(0xFF222222),
                  ).copyWith(
                    shadows: isDark
                        ? [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.7),
                              blurRadius: 6,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  PortfolioData.heroBio2,
                  textAlign: centerOnMobile ? TextAlign.center : TextAlign.start,
                  style: AppTypography.bodySans(
                    context: context,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    height: 1.65,
                    color: isDark ? const Color(0xFFE8E0D5) : const Color(0xFF333333),
                  ).copyWith(
                    shadows: isDark
                        ? [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.7),
                              blurRadius: 6,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // 6. Action Buttons: "Download Resume ->" & "Know More v"
          Wrap(
            spacing: 16,
            runSpacing: 14,
            alignment: centerOnMobile ? WrapAlignment.center : WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              GlassButton(
                label: 'Download Resume',
                icon: Icons.download_rounded,
                trailingIcon: Icons.arrow_forward_rounded,
                variant: GlassButtonVariant.primaryGold,
                onPressed: () => _handleResumeDownload(context),
              ),
              GlassButton(
                label: 'Know More',
                trailingIcon: Icons.arrow_downward_rounded,
                variant: GlassButtonVariant.frostedGlass,
                onPressed: widget.onKnowMorePressed,
              ),
            ],
          ),
          const SizedBox(height: 28),

          // 7. Circular Social Links: GitHub, LinkedIn, Instagram, Email
          Row(
            mainAxisSize: MainAxisSize.min,
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
                tooltip: 'Email Hashir',
                onPressed: () => _launchUrl('mailto:${PortfolioData.contactEmail}'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
