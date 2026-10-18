import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum GlassButtonVariant {
  primaryGold, // Solid gold gradient with luminous border
  frostedGlass, // Translucent glass with fine gold border
  navConnect, // Dark translucent pill with gold highlight
}

class GlassButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final GlassButtonVariant variant;
  final double? width;
  final double height;
  final double borderRadius;
  final String? tooltip;

  const GlassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.variant = GlassButtonVariant.primaryGold,
    this.width,
    this.height = 46,
    this.borderRadius = 28,
    this.tooltip,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Define colors according to variant
    List<Color> gradientColors;
    Color borderColor;
    Color textColor;
    List<BoxShadow> shadows;

    switch (widget.variant) {
      case GlassButtonVariant.primaryGold:
        gradientColors = _isHovered
            ? [
                const Color(0xFFC79854),
                const Color(0xFFA57736),
              ]
            : [
                const Color(0xFFBA8B49),
                const Color(0xFF986B2C),
              ];
        borderColor = _isHovered ? const Color(0xFFFFE3A3) : const Color(0xFFE2C48E);
        textColor = Colors.white;
        shadows = [
          BoxShadow(
            color: const Color(0xFFB88946).withValues(alpha: _isHovered ? 0.45 : 0.25),
            blurRadius: _isHovered ? 16 : 10,
            offset: Offset(0, _isHovered ? 6 : 3),
          ),
        ];
        break;

      case GlassButtonVariant.frostedGlass:
        final baseColor = isDark ? const Color(0xFF22242B) : const Color(0xFFFFFFFF);
        gradientColors = [
          baseColor.withValues(alpha: _isHovered ? 0.85 : 0.60),
          baseColor.withValues(alpha: _isHovered ? 0.70 : 0.40),
        ];
        borderColor = _isHovered ? AppColors.goldPrimary : AppColors.goldMuted.withValues(alpha: 0.65);
        textColor = isDark ? AppColors.textDark : AppColors.textLight;
        shadows = [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFF8A7758)).withValues(alpha: _isHovered ? 0.16 : 0.08),
            blurRadius: _isHovered ? 14 : 8,
            offset: Offset(0, _isHovered ? 5 : 2),
          ),
        ];
        break;

      case GlassButtonVariant.navConnect:
        gradientColors = [
          Colors.white.withValues(alpha: _isHovered ? 0.16 : 0.08),
          Colors.white.withValues(alpha: _isHovered ? 0.08 : 0.02),
        ];
        borderColor = _isHovered ? AppColors.goldLight : AppColors.goldMuted.withValues(alpha: 0.5);
        textColor = const Color(0xFFF7F2E8);
        shadows = [
          BoxShadow(
            color: AppColors.goldPrimary.withValues(alpha: _isHovered ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ];
        break;
    }

    final buttonWidget = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(
            0,
            _isPressed ? 1 : (_isHovered ? -3 : 0),
            0,
          ),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            border: Border.all(
              color: borderColor,
              width: 1.2,
            ),
            boxShadow: shadows,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        size: 17,
                        color: textColor,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: AppTypography.bodySans(
                        context: context,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                    if (widget.trailingIcon != null) ...[
                      const SizedBox(width: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        transform: Matrix4.translationValues(
                          _isHovered ? 2 : 0,
                          0,
                          0,
                        ),
                        child: Icon(
                          widget.trailingIcon,
                          size: 15,
                          color: textColor,
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
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}

/// Circular Social Icon Button matching reference image (Github, Linkedin, Instagram, Email)
class GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final double size;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.size = 40,
  });

  @override
  State<GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<GlassIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutQuad,
            transform: Matrix4.translationValues(0, _isHovered ? -2.5 : 0, 0),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? (_isHovered
                      ? AppColors.surfaceDarkElevated
                      : AppColors.surfaceDark)
                  : (_isHovered
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.8)),
              border: Border.all(
                color: _isHovered
                    ? AppColors.goldPrimary
                    : (isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.goldPrimary.withValues(alpha: _isHovered ? 0.25 : 0.05),
                  blurRadius: _isHovered ? 10 : 4,
                  offset: Offset(0, _isHovered ? 4 : 2),
                ),
              ],
            ),
            child: Icon(
              widget.icon,
              size: widget.size * 0.46,
              color: _isHovered
                  ? AppColors.goldPrimary
                  : (isDark ? AppColors.textDark : AppColors.textLight),
            ),
          ),
        ),
      ),
    );
  }
}
