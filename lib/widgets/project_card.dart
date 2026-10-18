import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/projects_data.dart';
import '../theme/app_theme.dart';
import 'glass_button.dart';

class ProjectCard extends StatefulWidget {
  final ProjectItem project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showProjectModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark
              ? const Color(0xFF1B1D26).withValues(alpha: 0.95)
              : Colors.white.withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(color: AppColors.goldPrimary.withValues(alpha: 0.6), width: 1.2),
          ),
          title: Row(
            children: [
              Icon(widget.project.icon, color: AppColors.goldPrimary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.project.title,
                  style: AppTypography.headingSerif(
                    context: context,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.goldPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.goldPrimary.withValues(alpha: 0.4)),
                ),
                child: Text(
                  widget.project.status,
                  style: AppTypography.labelSpaced(
                    context: context,
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.project.description,
                style: AppTypography.bodySans(
                  context: context,
                  fontSize: 14.5,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Technologies Utilized:',
                style: AppTypography.bodySans(
                  context: context,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.project.technologies.map((t) {
                  return Chip(
                    label: Text(t),
                    labelStyle: AppTypography.bodySans(
                      context: context,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                    backgroundColor: isDark
                        ? const Color(0xFF262933).withValues(alpha: 0.8)
                        : Colors.white.withValues(alpha: 0.8),
                    side: BorderSide(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: isDark ? AppColors.goldMuted : AppColors.goldPrimary),
              ),
            ),
            if (widget.project.githubUrl != null)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _launchUrl(widget.project.githubUrl!);
                },
                icon: const Icon(Icons.code_rounded, size: 16),
                label: const Text('View GitHub Repository'),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -5 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? AppColors.goldPrimary
                : AppColors.goldMuted.withValues(alpha: isDark ? 0.35 : 0.4),
            width: _isHovered ? 1.4 : 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : const Color(0xFF907D5D))
                  .withValues(alpha: _isHovered ? 0.24 : 0.08),
              blurRadius: _isHovered ? 24 : 12,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
            if (_isHovered)
              BoxShadow(
                color: AppColors.goldPrimary.withValues(alpha: 0.20),
                blurRadius: 18,
                spreadRadius: 1,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              color: isDark
                  ? const Color(0xFF161820).withValues(alpha: _isHovered ? 0.82 : 0.70)
                  : Colors.white.withValues(alpha: _isHovered ? 0.85 : 0.72),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // Visual header banner / thumbnail placeholder
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            const Color(0xFF21242D),
                            const Color(0xFF18191E),
                          ]
                        : [
                            const Color(0xFFF3ECE0),
                            const Color(0xFFE8DDCA),
                          ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Subtle geometric watermark
                    Positioned(
                      right: -15,
                      bottom: -20,
                      child: Icon(
                        widget.project.icon,
                        size: 130,
                        color: (isDark ? Colors.white : AppColors.navySecondary)
                            .withValues(alpha: 0.05),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Category Pill
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.goldPrimary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.goldPrimary.withValues(alpha: 0.4),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    widget.project.category.toUpperCase(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.labelSpaced(
                                      context: context,
                                      fontSize: 9.5,
                                      letterSpacing: 1.2,
                                      color: AppColors.goldPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Status Indicator
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (isDark ? Colors.black : Colors.white)
                                        .withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    widget.project.status,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.bodySans(
                                      context: context,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.goldMuted : AppColors.goldDark,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Project Main Icon Badge
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDarkElevated : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.goldMuted.withValues(alpha: 0.5),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.project.icon,
                              color: AppColors.goldPrimary,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content Body
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.project.title,
                      style: AppTypography.headingSerif(
                        context: context,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.project.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySans(
                        context: context,
                        fontSize: 13.5,
                        color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Technology Tags
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.project.technologies.take(3).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.surfaceDarkElevated
                                : AppColors.surfaceLightAlt,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: AppTypography.bodySans(
                              context: context,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.textDark : AppColors.textLight,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons: Details + GitHub
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: AppColors.goldMuted.withValues(alpha: 0.6),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () => _showProjectModal(context),
                            child: Text(
                              'View Details',
                              style: AppTypography.bodySans(
                                context: context,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.goldMuted : AppColors.goldDark,
                              ),
                            ),
                          ),
                        ),
                        if (widget.project.githubUrl != null) ...[
                          const SizedBox(width: 8),
                          GlassIconButton(
                            icon: Icons.code_rounded,
                            tooltip: 'View on GitHub',
                            size: 38,
                            onPressed: () => _launchUrl(widget.project.githubUrl!),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);
}
}
