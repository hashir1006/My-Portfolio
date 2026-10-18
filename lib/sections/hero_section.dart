import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
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
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: isDesktop ? (size.height - 70).clamp(620.0, 900.0) : 600,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Left Persian Architectural curved side border (matching reference image)
          if (size.width >= 720)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 52,
              child: CustomPaint(
                painter: PersianSideBorderPainter(
                  goldColor: AppColors.goldPrimary,
                  darkColor: isDark ? const Color(0xFF1B1D24) : AppColors.navySecondary,
                  isDark: isDark,
                ),
              ),
            ),

          // 2. Faint Mosque Silhouettes in the distant background
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            height: 180,
            child: Opacity(
              opacity: isDark ? 0.08 : 0.12,
              child: CustomPaint(
                painter: MosqueSilhouettePainter(
                  tintColor: isDark ? AppColors.goldMuted : AppColors.goldPrimary,
                  opacity: 0.8,
                ),
              ),
            ),
          ),

          // 3. Main Content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1140),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 36 : 24,
                  vertical: isDesktop ? 48 : 32,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Left Column: Text, CTAs, Socials
                              Expanded(
                                flex: 6,
                                child: _buildLeftHeroContent(context),
                              ),
                              const SizedBox(width: 40),
                              // Right Column: Faceless Portrait Placeholder
                              Expanded(
                                flex: 5,
                                child: Center(
                                  child: HeroPortraitPlaceholder(),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 16),
                              // Right Column shown prominently on tablet/mobile
                              Center(
                                child: HeroPortraitPlaceholder(
                                  width: isTablet ? 300 : 250,
                                ),
                              ),
                              const SizedBox(height: 36),
                              _buildLeftHeroContent(
                                context,
                                centerOnMobile: true,
                              ),
                            ],
                          ),
                  ),
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

    return Column(
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
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textDark : AppColors.textLight,
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
                  fontSize: 64,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                  letterSpacing: -1.0,
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                ),
              ),
              TextSpan(
                text: PortfolioData.surname,
                style: AppTypography.headingSerif(
                  context: context,
                  fontSize: 64,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                  letterSpacing: -1.0,
                  color: AppColors.goldPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 4. Professional Subtitle: "── COMPUTER SCIENCE & AI/ML STUDENT ──"
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 1,
              color: AppColors.goldPrimary.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                PortfolioData.heroTitle,
                textAlign: centerOnMobile ? TextAlign.center : TextAlign.start,
                style: AppTypography.labelSpaced(
                  context: context,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                  letterSpacing: 2.4,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 24,
              height: 1,
              color: AppColors.goldPrimary.withValues(alpha: 0.6),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // 5. Introduction Paragraphs
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
                  fontSize: 15,
                  height: 1.6,
                  color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                PortfolioData.heroBio2,
                textAlign: centerOnMobile ? TextAlign.center : TextAlign.start,
                style: AppTypography.bodySans(
                  context: context,
                  fontSize: 15,
                  height: 1.6,
                  color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
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
    );
  }
}
