import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'persian_decorations.dart';

class HeroPortraitPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final String? imageAssetPath; // For easy replacement with a real portrait photo later

  const HeroPortraitPlaceholder({
    super.key,
    this.width,
    this.height,
    this.imageAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive sizing
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        // Target 340-440px on desktop, scaling down on smaller screens
        final cardWidth = (width ?? availableWidth.clamp(260.0, 420.0)).toDouble();
        final cardHeight = (height ?? cardWidth * 1.34).toDouble();
        final archWidth = cardWidth * 1.08;
        final archHeight = cardHeight * 1.15;

        return SizedBox(
          width: archWidth,
          height: archHeight,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // 1. Persian Pointed Arch (Mihrab) in the background with lattice
              Positioned(
                top: 0,
                child: CustomPaint(
                  size: Size(archWidth, archHeight * 0.95),
                  painter: PersianArchPainter(
                    borderColor: AppColors.goldMuted,
                    fillColor: const Color(0xFF1B202A),
                    borderWidth: 1.5,
                    drawLattice: true,
                  ),
                ),
              ),

              // 2. Corner Star Ornaments flanking the frame
              Positioned(
                top: 18,
                right: -6,
                child: const PersianStarOrnament(size: 14, showDivider: false),
              ),
              Positioned(
                bottom: 24,
                left: -8,
                child: const PersianStarOrnament(size: 14, showDivider: false),
              ),

              // 3. Foreground Portrait Frame (Dark charcoal rounded rectangle with double gold border)
              Positioned(
                bottom: 12,
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    color: AppColors.placeholderBg,
                    borderRadius: BorderRadius.circular(28),
                    // Outer fine gold border
                    border: Border.all(
                      color: AppColors.goldPrimary.withValues(alpha: 0.9),
                      width: 1.8,
                    ),
                    boxShadow: [
                      // Soft luminous edge glow matching reference image
                      BoxShadow(
                        color: AppColors.goldPrimary.withValues(alpha: 0.35),
                        blurRadius: 28,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 35,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: AppColors.placeholderBg,
                      borderRadius: BorderRadius.circular(22),
                      // Inner fine gold accent border (creates double-border effect)
                      border: Border.all(
                        color: AppColors.goldMuted.withValues(alpha: 0.45),
                        width: 1.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: imageAssetPath != null
                          ? Image.asset(
                              imageAssetPath!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const _FacelessSilhouette(),
                            )
                          : const _FacelessSilhouette(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Generic, elegant faceless profile silhouette (head & shoulders)
class _FacelessSilhouette extends StatelessWidget {
  const _FacelessSilhouette();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF23252E),
      child: CustomPaint(
        painter: _SilhouetteCustomPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _SilhouetteCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final silhouettePaint = Paint()
      ..color = const Color(0xFF3B404D) // Clean minimalist neutral silhouette
      ..style = PaintingStyle.fill;

    // Draw Head Circle
    final headRadius = w * 0.22;
    final headCenter = Offset(w * 0.5, h * 0.44);
    canvas.drawCircle(headCenter, headRadius, silhouettePaint);

    // Draw Shoulders & Chest Curve
    final bodyPath = Path();
    final shoulderTop = h * 0.58;

    bodyPath.moveTo(w * 0.12, h);
    bodyPath.cubicTo(
      w * 0.12,
      shoulderTop + h * 0.08,
      w * 0.25,
      shoulderTop,
      w * 0.5,
      shoulderTop,
    );
    bodyPath.cubicTo(
      w * 0.75,
      shoulderTop,
      w * 0.88,
      shoulderTop + h * 0.08,
      w * 0.88,
      h,
    );
    bodyPath.close();

    canvas.drawPath(bodyPath, silhouettePaint);

    // Subtle soft gradient overlay from bottom
    final overlayPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFF1E2028).withValues(alpha: 0.5),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), overlayPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
