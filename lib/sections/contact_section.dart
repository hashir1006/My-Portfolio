import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_box.dart';
import '../widgets/glass_button.dart';
import '../widgets/section_heading.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;
  String? _statusMessage;
  bool _isSuccess = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _statusMessage = null;
    });

    final name = _nameController.text.trim();
    final senderEmail = _emailController.text.trim();
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();

    // Honest Email Client Fallback
    // Prefill mailto URI so user can directly dispatch without fake delivery simulation
    final emailBody =
        'Hello Hashir,\n\n$message\n\nBest regards,\n$name\nEmail: $senderEmail';
    final mailtoUri = Uri(
      scheme: 'mailto',
      path: PortfolioData.contactEmail,
      queryParameters: {
        'subject': subject.isEmpty ? 'Collaboration Inquiry: $name' : subject,
        'body': emailBody,
      },
    );

    try {
      if (await canLaunchUrl(mailtoUri)) {
        await launchUrl(mailtoUri);
        setState(() {
          _isSubmitting = false;
          _isSuccess = true;
          _statusMessage =
              'Opening your email client with the prefilled message. Thank you for connecting!';
        });
      } else {
        setState(() {
          _isSubmitting = false;
          _isSuccess = true;
          _statusMessage =
              'Ready to send! Please write directly to ${PortfolioData.contactEmail}.';
        });
      }
    } catch (_) {
      setState(() {
        _isSubmitting = false;
        _isSuccess = false;
        _statusMessage =
            'Unable to launch email client automatically. Please email Hashir at ${PortfolioData.contactEmail}.';
      });
    }
  }

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
              const SectionHeading(
                kicker: 'GET IN TOUCH',
                title: "Let's Build Something Meaningful",
                subtitle:
                    "Have an idea, a project, or an opportunity to collaborate? I'd love to connect.",
              ),
              const SizedBox(height: 52),

              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Direct contact cards & social links
                        Expanded(
                          flex: 5,
                          child: _buildContactInfo(context, isDark),
                        ),
                        const SizedBox(width: 48),
                        // Right: Contact Form
                        Expanded(
                          flex: 7,
                          child: _buildContactForm(context, isDark),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildContactInfo(context, isDark),
                        const SizedBox(height: 36),
                        _buildContactForm(context, isDark),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Direct Inquiries',
          style: AppTypography.headingSerif(
            context: context,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Feel free to reach out for hackathon collaborations, full-stack & AI development projects, or academic discussions.',
          style: AppTypography.bodySans(
            context: context,
            fontSize: 14.5,
            height: 1.6,
            color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
          ),
        ),
        const SizedBox(height: 28),

        // Email info card
        _buildInfoCard(
          context: context,
          isDark: isDark,
          icon: Icons.alternate_email_rounded,
          title: 'Email Address',
          value: PortfolioData.contactEmail,
          onTap: () => _launchUrl('mailto:${PortfolioData.contactEmail}'),
        ),
        const SizedBox(height: 16),

        // LinkedIn info card
        _buildInfoCard(
          context: context,
          isDark: isDark,
          icon: Icons.work_outline_rounded,
          title: 'LinkedIn',
          value: 'linkedin.com/in/hashir1006',
          onTap: () => _launchUrl(PortfolioData.linkedinUrl),
        ),
        const SizedBox(height: 16),

        // GitHub info card
        _buildInfoCard(
          context: context,
          isDark: isDark,
          icon: Icons.code_rounded,
          title: 'GitHub',
          value: 'github.com/hashir1006',
          onTap: () => _launchUrl(PortfolioData.githubUrl),
        ),
        const SizedBox(height: 16),

        // Location info card
        _buildInfoCard(
          context: context,
          isDark: isDark,
          icon: Icons.location_on_outlined,
          title: 'Location',
          value: PortfolioData.location,
          onTap: null,
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback? onTap,
  }) {
    return GlassBox(
      onTap: onTap,
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.goldPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.goldPrimary.withValues(alpha: 0.4),
              ),
            ),
            child: Icon(icon, color: AppColors.goldPrimary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelSpaced(
                    context: context,
                    fontSize: 11,
                    letterSpacing: 1.5,
                    color: isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: AppTypography.bodySans(
                    context: context,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(
              Icons.arrow_forward_rounded,
              size: 16,
              color: AppColors.goldPrimary,
            ),
        ],
      ),
    );
  }

  Widget _buildContactForm(BuildContext context, bool isDark) {
    return GlassBox(
      borderRadius: 24,
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a Message',
              style: AppTypography.headingSerif(
                context: context,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
            const SizedBox(height: 20),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name *',
                hintText: 'e.g. Sarah Khan',
                prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // Email Field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Your Email *',
                hintText: 'e.g. sarah@example.com',
                prefixIcon: Icon(Icons.mail_outline_rounded, size: 20),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter your email address';
                }
                final emailRegex =
                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(val.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // Subject Field
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject *',
                hintText: 'e.g. Hackathon Project Collaboration',
                prefixIcon: Icon(Icons.title_rounded, size: 20),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please specify a subject';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // Message Field
            TextFormField(
              controller: _messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Message *',
                hintText: 'Write your project thoughts or collaboration idea...',
                alignLabelWithHint: true,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter your message';
                }
                if (val.trim().length < 10) {
                  return 'Message must be at least 10 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Status notification banner if any
            if (_statusMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isSuccess
                      ? const Color(0xFF2E7D32).withValues(alpha: 0.12)
                      : Colors.redAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _isSuccess
                        ? const Color(0xFF2E7D32)
                        : Colors.redAccent,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isSuccess
                          ? Icons.check_circle_outline_rounded
                          : Icons.error_outline_rounded,
                      color: _isSuccess
                          ? const Color(0xFF2E7D32)
                          : Colors.redAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _statusMessage!,
                        style: AppTypography.bodySans(
                          context: context,
                          fontSize: 13,
                          color: isDark ? AppColors.textDark : AppColors.textLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Submit Button
            GlassButton(
              label: _isSubmitting ? 'Preparing...' : 'Send Message',
              icon: Icons.send_rounded,
              variant: GlassButtonVariant.primaryGold,
              width: double.infinity,
              height: 50,
              onPressed: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
