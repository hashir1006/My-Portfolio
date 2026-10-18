import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassBox extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final bool enableHover;
  final Color? borderColor;
  final Color? customBgColor;
  final VoidCallback? onTap;

  const GlassBox({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.borderRadius = 20,
    this.blur = 16,
    this.enableHover = true,
    this.borderColor,
    this.customBgColor,
    this.onTap,
  });

  @override
  State<GlassBox> createState() => _GlassBoxState();
}

class _GlassBoxState extends State<GlassBox> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseBorderColor = widget.borderColor ??
        (isDark
            ? AppColors.goldMuted.withValues(alpha: _isHovered ? 0.75 : 0.3)
            : AppColors.goldMuted.withValues(alpha: _isHovered ? 0.8 : 0.4));

    final baseBgColor = widget.customBgColor ??
        (isDark
            ? const Color(0xFF16181F).withValues(alpha: _isHovered ? 0.78 : 0.65)
            : Colors.white.withValues(alpha: _isHovered ? 0.82 : 0.68));

    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(
        0,
        (widget.enableHover && _isHovered) ? -4 : 0,
        0,
      ),
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: baseBorderColor,
          width: _isHovered ? 1.5 : 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFF8C795A))
                .withValues(alpha: _isHovered ? 0.24 : 0.10),
            blurRadius: _isHovered ? 24 : 14,
            offset: Offset(0, _isHovered ? 8 : 4),
          ),
          if (_isHovered)
            BoxShadow(
              color: AppColors.goldPrimary.withValues(alpha: 0.22),
              blurRadius: 18,
              spreadRadius: 1,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius - 1),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blur,
            sigmaY: widget.blur,
          ),
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: baseBgColor,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.white.withValues(alpha: _isHovered ? 0.08 : 0.04),
                        Colors.black.withValues(alpha: _isHovered ? 0.25 : 0.35),
                      ]
                    : [
                        Colors.white.withValues(alpha: _isHovered ? 0.75 : 0.55),
                        const Color(0xFFFBF7F0).withValues(alpha: _isHovered ? 0.55 : 0.35),
                      ],
              ),
            ),
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.onTap != null || widget.enableHover) {
      return MouseRegion(
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        onEnter: (_) {
          if (widget.enableHover) setState(() => _isHovered = true);
        },
        onExit: (_) {
          if (widget.enableHover) setState(() => _isHovered = false);
        },
        child: widget.onTap != null
            ? GestureDetector(
                onTap: widget.onTap,
                child: content,
              )
            : content,
      );
    }

    return content;
  }
}
