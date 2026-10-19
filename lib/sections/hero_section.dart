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
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _zoomController;
  late Animation<double> _leftFadeAnimation;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<double> _rightFadeAnimation;
  late Animation<Offset> _rightSlideAnimation;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();
    // 1. Entrance animation (rapid, smooth split slide-in from left & right, ~650ms)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    // Left description box: Slides in fast from left (-0.45, 0) to center
    _leftFadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.85, curve: Curves.easeOut),
    );

    _leftSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.45, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    ));

    // Right portrait cutout: Slides in fast from right (0.45, 0) to center at normal scale (while loading)
    _rightFadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.85, curve: Curves.easeOut),
    );

    _rightSlideAnimation = Tween<Offset>(
      begin: const Offset(0.45, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    ));

    // 2. Post-loading Zoom Transition: Smooth and fast zoom (scale up to focused bust portrait, ~600ms)
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _zoomAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _zoomController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Sequence:
    // 1. First slide-in at 1.0x (full image while loading)
    // 2. Remain full image for 3 seconds after homepage completely loads
    // 3. Smoothly and quickly crop & scale simultaneously into the bust portrait
    _entranceController.forward().then((_) async {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        _zoomController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _zoomController.dispose();
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
        clipBehavior: Clip.hardEdge,
        children: [
          // Main Hero Content with Fast Split Slide Animations
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1140),
              child: Padding(
                padding: EdgeInsets.only(
                  left: isDesktop ? 36 : 24,
                  right: isDesktop ? 36 : 24,
                  top: isDesktop ? 8 : 12,
                  bottom: isDesktop ? 28 : 20,
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
                          // Right Column: Authentic Cutout Portrait (Slides from Right to Center, then Zooms in)
                          Expanded(
                            flex: 5,
                            child: SlideTransition(
                              position: _rightSlideAnimation,
                              child: FadeTransition(
                                opacity: _rightFadeAnimation,
                                child: Center(
                                  child: AnimatedBuilder(
                                    animation: _zoomAnimation,
                                    builder: (context, _) => HeroPortraitCutout(
                                      zoomProgress: _zoomAnimation.value,
                                      onTap: () {
                                        if (_zoomController.isCompleted) {
                                          _zoomController.reverse();
                                        } else {
                                          _zoomController.forward();
                                        }
                                      },
                                    ),
                                  ),
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
                          // Cutout Portrait slides smoothly from Right to Center on Mobile/Tablet, then Zooms in
                          SlideTransition(
                            position: _rightSlideAnimation,
                            child: FadeTransition(
                              opacity: _rightFadeAnimation,
                              child: Center(
                                child: AnimatedBuilder(
                                  animation: _zoomAnimation,
                                  builder: (context, _) => HeroPortraitCutout(
                                    zoomProgress: _zoomAnimation.value,
                                    width: isTablet ? 320 : 270,
                                    height: isTablet ? 440 : 380,
                                    onTap: () {
                                      if (_zoomController.isCompleted) {
                                        _zoomController.reverse();
                                      } else {
                                        _zoomController.forward();
                                      }
                                    },
                                  ),
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
      borderRadius: 26,
      blur: 24,
      enableHover: false,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 30 : 20,
        vertical: isDesktop ? 22 : 18,
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
          const SizedBox(height: 10),

          // 2. Greeting: "Assalamualaikum, I'm"
          Text(
            PortfolioData.greeting,
            style: AppTypography.headingSerif(
              context: context,
              fontSize: isDesktop ? 22 : 20,
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
          const SizedBox(height: 2),

          // 3. Main Heading: "Hashir" in dark charcoal, "Shaikh" in gold (Reference Image)
          RichText(
            textAlign: centerOnMobile ? TextAlign.center : TextAlign.start,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${PortfolioData.name}\n',
                  style: AppTypography.headingSerif(
                    context: context,
                    fontSize: isDesktop ? 54 : 42,
                    fontWeight: FontWeight.w700,
                    height: 1.02,
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
                    fontSize: isDesktop ? 54 : 42,
                    fontWeight: FontWeight.w700,
                    height: 1.02,
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
          const SizedBox(height: 12),

          // 4. Professional Status Badges (AI & ML Developer + MHSSCE Mumbai + CS B.E.)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: centerOnMobile ? WrapAlignment.center : WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Badge 1: AI & ML Developer with pulsing emerald indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.18 : 0.10),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.5),
                    width: 1.1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF10B981),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withValues(alpha: 0.8),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'AI & ML Developer',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                        color: isDark ? Colors.white : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Badge 2: MHSSCE • Mumbai
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                    const Icon(
                      Icons.auto_awesome_rounded,
                      size: 13,
                      color: AppColors.goldPrimary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'MHSSCE • Mumbai',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        color: isDark ? const Color(0xFFE5B96E) : AppColors.goldPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // Badge 3: Computer Science & AI/ML
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColors.goldMuted.withValues(alpha: 0.35)
                        : AppColors.goldMuted.withValues(alpha: 0.4),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  'CS (AI & ML) B.E.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                    color: isDark ? const Color(0xFFF7F2E8) : AppColors.navySecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 5. Introduction Paragraphs with High Contrast & Soft Text Glow
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
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
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    height: 1.55,
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
                const SizedBox(height: 8),
                Text(
                  PortfolioData.heroBio2,
                  textAlign: centerOnMobile ? TextAlign.center : TextAlign.start,
                  style: AppTypography.bodySans(
                    context: context,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    height: 1.55,
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
          const SizedBox(height: 20),

          // 6. Action Buttons: "Download Resume ->" & "Know More v"
          Wrap(
            spacing: 14,
            runSpacing: 12,
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
          const SizedBox(height: 20),

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
