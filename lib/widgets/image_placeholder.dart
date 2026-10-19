import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'glass_box.dart';
import 'persian_decorations.dart';

/// Modern Persian-inspired Hero Portrait featuring the user's authentic cutout image,
/// illuminated with an ambient golden aura, sacred geometry halo, floating glass badges,
/// and smooth bottom gradient grounding.
class HeroPortraitCutout extends StatefulWidget {
  final double? width;
  final double? height;
  final String? imageAssetPath;

  const HeroPortraitCutout({
    super.key,
    this.width,
    this.height,
    this.imageAssetPath,
  });

  @override
  State<HeroPortraitCutout> createState() => _HeroPortraitCutoutState();
}

class _HeroPortraitCutoutState extends State<HeroPortraitCutout>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;
  late Animation<double> _glowPulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _glowPulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final targetWidth =
            (widget.width ?? availableWidth.clamp(280.0, 440.0)).toDouble();
        final targetHeight =
            (widget.height ?? (targetWidth * 1.35).clamp(380.0, 580.0)).toDouble();

        final assetPath =
            widget.imageAssetPath ?? 'assets/images/hashir_portrait.png';

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: SizedBox(
            width: targetWidth,
            height: targetHeight,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // 1. Ambient Golden Glow / Aura behind the cutout
                AnimatedBuilder(
                  animation: _glowPulseAnimation,
                  builder: (context, child) {
                    final pulse = _glowPulseAnimation.value;
                    return Positioned(
                      top: targetHeight * 0.12,
                      child: Container(
                        width: targetWidth * 0.85 * pulse,
                        height: targetWidth * 0.85 * pulse,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.goldPrimary.withValues(
                                alpha: isDark
                                    ? (_isHovered ? 0.35 : 0.24)
                                    : (_isHovered ? 0.28 : 0.18),
                              ),
                              AppColors.goldMuted.withValues(
                                alpha: isDark ? 0.12 : 0.08,
                              ),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.55, 1.0],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // 2. Delicate Persian Geometric Halo (Sacred concentric geometry)
                Positioned(
                  top: targetHeight * 0.08,
                  child: CustomPaint(
                    size: Size(targetWidth * 0.88, targetWidth * 0.88),
                    painter: _IslamicHaloPainter(
                      color: AppColors.goldPrimary.withValues(
                        alpha: isDark ? 0.28 : 0.22,
                      ),
                      isDark: isDark,
                    ),
                  ),
                ),

                // 3. Floating Persian Corner Stars
                Positioned(
                  top: targetHeight * 0.06,
                  right: 12,
                  child: const PersianStarOrnament(
                    size: 16,
                    color: AppColors.goldPrimary,
                    showDivider: false,
                  ),
                ),
                Positioned(
                  top: targetHeight * 0.22,
                  left: 8,
                  child: PersianStarOrnament(
                    size: 12,
                    color: AppColors.goldMuted.withValues(alpha: 0.6),
                    showDivider: false,
                  ),
                ),

                // 4. Authentic Portrait Cutout Image with Smooth Bottom Gradient Grounding
                Positioned.fill(
                  child: AnimatedScale(
                    scale: _isHovered ? 1.025 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.80, 0.98],
                          colors: [
                            Colors.black,
                            Colors.black,
                            Colors.transparent,
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (context, error, stackTrace) =>
                            _FallbackPortrait(width: targetWidth, height: targetHeight),
                      ),
                    ),
                  ),
                ),

                // 5. Floating Glass Badge: Top-Right "✦ AI & ML Developer" with glowing status indicator
                Positioned(
                  top: targetHeight * 0.16,
                  right: -8,
                  child: AnimatedSlide(
                    offset: _isHovered ? const Offset(0, -0.06) : Offset.zero,
                    duration: const Duration(milliseconds: 250),
                    child: GlassBox(
                      borderRadius: 20,
                      blur: 16,
                      enableHover: false,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      borderColor: AppColors.goldPrimary.withValues(
                        alpha: isDark ? 0.55 : 0.45,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF10B981),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withValues(
                                    alpha: 0.7,
                                  ),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'AI & ML Developer',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                              color: isDark ? Colors.white : AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 6. Floating Glass Badge: Bottom-Left "✦ Hashir Shaikh • CS Student"
                Positioned(
                  bottom: targetHeight * 0.08,
                  left: -6,
                  child: AnimatedSlide(
                    offset: _isHovered ? const Offset(0, -0.06) : Offset.zero,
                    duration: const Duration(milliseconds: 250),
                    child: GlassBox(
                      borderRadius: 20,
                      blur: 16,
                      enableHover: false,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      borderColor: AppColors.goldMuted.withValues(
                        alpha: isDark ? 0.5 : 0.35,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            size: 14,
                            color: AppColors.goldPrimary,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'MHSSCE • Mumbai',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              color: isDark ? const Color(0xFFE5B96E) : AppColors.goldPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Fallback widget in case asset fails to load
class _FallbackPortrait extends StatelessWidget {
  final double width;
  final double height;

  const _FallbackPortrait({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: const Icon(
        Icons.person_rounded,
        size: 80,
        color: AppColors.goldPrimary,
      ),
    );
  }
}

/// Painter for delicate Persian circular halo and geometric star accents behind the cutout
class _IslamicHaloPainter extends CustomPainter {
  final Color color;
  final bool isDark;

  const _IslamicHaloPainter({required this.color, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final dashPaint = Paint()
      ..color = color.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Outer subtle ring
    canvas.drawCircle(center, radius * 0.96, ringPaint);

    // Inner subtle ring
    canvas.drawCircle(center, radius * 0.82, ringPaint);

    // Innermost subtle ring
    canvas.drawCircle(center, radius * 0.65, ringPaint);

    // 8-pointed star points or radial ticks
    const points = 16;
    for (int i = 0; i < points; i++) {
      final angle = (i * 2 * math.pi) / points;
      final isMajor = i % 2 == 0;
      final startR = radius * (isMajor ? 0.82 : 0.86);
      final endR = radius * 0.96;

      final p1 = Offset(
        center.dx + startR * math.cos(angle),
        center.dy + startR * math.sin(angle),
      );
      final p2 = Offset(
        center.dx + endR * math.cos(angle),
        center.dy + endR * math.sin(angle),
      );

      canvas.drawLine(p1, p2, dashPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _IslamicHaloPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isDark != isDark;
}

/// Legacy alias for seamless backwards compatibility
typedef HeroPortraitPlaceholder = HeroPortraitCutout;
