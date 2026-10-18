import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Paints an authentic Persian pointed arch (mihrab / ogee arch) with double gold borders
class PersianArchPainter extends CustomPainter {
  final Color borderColor;
  final Color fillColor;
  final bool drawLattice;
  final double borderWidth;

  PersianArchPainter({
    this.borderColor = AppColors.goldMuted,
    this.fillColor = const Color(0xFF1B202A),
    this.drawLattice = true,
    this.borderWidth = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Create the Persian pointed arch path
    final path = Path();
    path.moveTo(0, h);
    path.lineTo(0, h * 0.35);

    // Left curved rise towards pointed apex
    path.cubicTo(
      0,
      h * 0.15,
      w * 0.25,
      h * 0.05,
      w * 0.5,
      0,
    );

    // Right curved descent from pointed apex
    path.cubicTo(
      w * 0.75,
      h * 0.05,
      w,
      h * 0.15,
      w,
      h * 0.35,
    );
    path.lineTo(w, h);
    path.close();

    // Fill interior
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Draw internal delicate geometric lattice clipped to arch
    if (drawLattice) {
      canvas.save();
      canvas.clipPath(path);
      _drawGeometricLattice(canvas, size);
      canvas.restore();
    }

    // Outer luminous glow
    final glowPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 2.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(path, glowPaint);

    // Main sharp gold border
    final strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawPath(path, strokePaint);

    // Inner fine accent line
    final innerPath = Path();
    const inset = 6.0;
    innerPath.moveTo(inset, h);
    innerPath.lineTo(inset, h * 0.35 + 2);
    innerPath.cubicTo(
      inset,
      h * 0.15 + 4,
      w * 0.25 + 2,
      h * 0.05 + 5,
      w * 0.5,
      inset + 2,
    );
    innerPath.cubicTo(
      w * 0.75 - 2,
      h * 0.05 + 5,
      w - inset,
      h * 0.15 + 4,
      w - inset,
      h * 0.35 + 2,
    );
    innerPath.lineTo(w - inset, h);

    final innerStrokePaint = Paint()
      ..color = borderColor.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(innerPath, innerStrokePaint);
  }

  void _drawGeometricLattice(Canvas canvas, Size size) {
    final latticePaint = Paint()
      ..color = borderColor.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const step = 28.0;
    for (double x = -step; x < size.width + step; x += step) {
      for (double y = -step; y < size.height + step; y += step) {
        // Draw 8-point star / octagonal lattice lines
        canvas.drawLine(
          Offset(x, y - step / 2),
          Offset(x + step / 2, y),
          latticePaint,
        );
        canvas.drawLine(
          Offset(x + step / 2, y),
          Offset(x, y + step / 2),
          latticePaint,
        );
        canvas.drawLine(
          Offset(x, y + step / 2),
          Offset(x - step / 2, y),
          latticePaint,
        );
        canvas.drawLine(
          Offset(x - step / 2, y),
          Offset(x, y - step / 2),
          latticePaint,
        );

        // Small cross center
        canvas.drawLine(
          Offset(x - step * 0.25, y),
          Offset(x + step * 0.25, y),
          latticePaint,
        );
        canvas.drawLine(
          Offset(x, y - step * 0.25),
          Offset(x, y + step * 0.25),
          latticePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant PersianArchPainter oldDelegate) =>
      oldDelegate.borderColor != borderColor ||
      oldDelegate.fillColor != fillColor ||
      oldDelegate.drawLattice != drawLattice;
}

/// Paints the left-side ornamental Persian architectural border seen in the reference image
class PersianSideBorderPainter extends CustomPainter {
  final Color goldColor;
  final Color darkColor;
  final bool isDark;

  PersianSideBorderPainter({
    required this.goldColor,
    required this.darkColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Curved inward shape along left edge
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(w * 0.65, 0);

    // Decorative top notch
    path.cubicTo(
      w * 0.75,
      h * 0.1,
      w * 0.45,
      h * 0.18,
      w * 0.45,
      h * 0.28,
    );

    // Inward curving bay
    path.cubicTo(
      w * 0.45,
      h * 0.4,
      0,
      h * 0.45,
      0,
      h * 0.55,
    );

    path.cubicTo(
      0,
      h * 0.65,
      w * 0.45,
      h * 0.7,
      w * 0.45,
      h * 0.8,
    );

    path.cubicTo(
      w * 0.45,
      h * 0.9,
      w * 0.75,
      h * 0.95,
      w * 0.65,
      h,
    );

    path.lineTo(0, h);
    path.close();

    // Dark interior with geometric patterns
    final fillPaint = Paint()
      ..color = darkColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Clip and draw Persian geometric pattern
    canvas.save();
    canvas.clipPath(path);
    final patternPaint = Paint()
      ..color = goldColor.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const step = 20.0;
    for (double x = 0; x < w; x += step) {
      for (double y = 0; y < h; y += step) {
        canvas.drawCircle(Offset(x, y), 3, patternPaint);
        canvas.drawLine(
          Offset(x - 5, y),
          Offset(x + 5, y),
          patternPaint,
        );
        canvas.drawLine(
          Offset(x, y - 5),
          Offset(x, y + 5),
          patternPaint,
        );
      }
    }
    canvas.restore();

    // Gold trim line
    final trimPaint = Paint()
      ..color = goldColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path, trimPaint);

    // Fine inner accent line
    final innerTrim = Paint()
      ..color = goldColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, innerTrim);
  }

  @override
  bool shouldRepaint(covariant PersianSideBorderPainter oldDelegate) => true;
}

/// Paints the faint distant skyline of domes & minarets with a gentle mist gradient
class MosqueSilhouettePainter extends CustomPainter {
  final Color tintColor;
  final double opacity;

  MosqueSilhouettePainter({
    this.tintColor = AppColors.goldMuted,
    this.opacity = 0.12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = tintColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, h);

    // Left minaret
    final m1X = w * 0.22;
    path.lineTo(m1X - 6, h);
    path.lineTo(m1X - 6, h * 0.35);
    path.lineTo(m1X - 10, h * 0.35);
    path.lineTo(m1X - 10, h * 0.33);
    path.lineTo(m1X - 4, h * 0.33);
    path.lineTo(m1X - 4, h * 0.18);
    path.lineTo(m1X, h * 0.1); // Spire peak
    path.lineTo(m1X + 4, h * 0.18);
    path.lineTo(m1X + 4, h * 0.33);
    path.lineTo(m1X + 10, h * 0.33);
    path.lineTo(m1X + 10, h * 0.35);
    path.lineTo(m1X + 6, h * 0.35);
    path.lineTo(m1X + 6, h * 0.65);

    // Central Dome Left side
    final cX = w * 0.42;
    path.lineTo(cX - 45, h * 0.65);
    path.cubicTo(
      cX - 45,
      h * 0.42,
      cX - 25,
      h * 0.28,
      cX,
      h * 0.24, // Central dome apex
    );
    path.cubicTo(
      cX + 25,
      h * 0.28,
      cX + 45,
      h * 0.42,
      cX + 45,
      h * 0.65,
    );

    // Right minaret
    final m2X = w * 0.58;
    path.lineTo(m2X - 5, h * 0.65);
    path.lineTo(m2X - 5, h * 0.28);
    path.lineTo(m2X - 8, h * 0.28);
    path.lineTo(m2X, h * 0.14); // Spire peak
    path.lineTo(m2X + 8, h * 0.28);
    path.lineTo(m2X + 5, h * 0.28);
    path.lineTo(m2X + 5, h);

    path.lineTo(w, h);
    path.close();

    canvas.drawPath(path, paint);

    // Small crescent finials
    final finialPaint = Paint()
      ..color = tintColor.withValues(alpha: opacity * 1.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(m1X, h * 0.09), 2.5, finialPaint);
    canvas.drawCircle(Offset(cX, h * 0.23), 3.0, finialPaint);
    canvas.drawCircle(Offset(m2X, h * 0.13), 2.5, finialPaint);
  }

  @override
  bool shouldRepaint(covariant MosqueSilhouettePainter oldDelegate) =>
      oldDelegate.opacity != opacity || oldDelegate.tintColor != tintColor;
}

/// Small Persian ornamental star (✦) with optional horizontal accent line
class PersianStarOrnament extends StatelessWidget {
  final String? text;
  final double size;
  final Color? color;
  final bool showDivider;

  const PersianStarOrnament({
    super.key,
    this.text,
    this.size = 14,
    this.color,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final gold = color ?? AppColors.goldPrimary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(size, size),
          painter: _StarPainter(color: gold),
        ),
        if (text != null) ...[
          const SizedBox(width: 8),
          Text(
            text!,
            style: AppTypography.labelSpaced(
              context: context,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: gold,
              letterSpacing: 2.8,
            ),
          ),
        ],
        if (showDivider) ...[
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 1.2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  gold.withValues(alpha: 0.8),
                  gold.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _StarPainter extends CustomPainter {
  final Color color;
  _StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 8-point geometric star
    final path = Path();
    final cx = w / 2;
    final cy = h / 2;
    final rOuter = w / 2;
    final rInner = w * 0.24;

    for (int i = 0; i < 8; i++) {
      final angleOuter = (i * 45 - 90) * math.pi / 180;
      final angleInner = ((i * 45 + 22.5) - 90) * math.pi / 180;

      final xOuter = cx + rOuter * math.cos(angleOuter);
      final yOuter = cy + rOuter * math.sin(angleOuter);
      final xInner = cx + rInner * math.cos(angleInner);
      final yInner = cy + rInner * math.sin(angleInner);

      if (i == 0) {
        path.moveTo(xOuter, yOuter);
      } else {
        path.lineTo(xOuter, yOuter);
      }
      path.lineTo(xInner, yInner);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) => oldDelegate.color != color;
}
