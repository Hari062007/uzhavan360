import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/government_scheme_model.dart';
import '../../common/uzhavan_button.dart';
import '../../common/voice_speaker_button.dart';

class SchemeDetailScreen extends StatelessWidget {
  final GovernmentSchemeModel scheme;

  const SchemeDetailScreen({super.key, required this.scheme});

  void _callHelpline(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openPortal(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final voiceText =
        '${scheme.titleTa}. ${scheme.summaryTa}. தகுதி: ${scheme.eligibilityTa}. பயன்கள்: ${scheme.benefitsTa}.';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('திட்ட விவரம்'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: VoiceSpeakerButton(textToSpeak: voiceText),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Department Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  scheme.department,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D4ED8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                scheme.titleTa,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                scheme.titleEn,
                style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),

              // Summary Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.greenLightBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
                ),
                child: Text(
                  scheme.summaryTa,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryGreenDark,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Eligibility Section
              _buildSectionCard(
                icon: Icons.checklist_rtl_rounded,
                iconColor: const Color(0xFF2563EB),
                title: 'யாருக்கு தகுதி? (Eligibility)',
                content: scheme.eligibilityTa,
              ),
              const SizedBox(height: 14),

              // Benefits Section
              _buildSectionCard(
                icon: Icons.card_giftcard_outlined,
                iconColor: const Color(0xFF16A34A),
                title: 'என்னென்ன பயன்கள் கிடைக்கும்? (Benefits)',
                content: scheme.benefitsTa,
              ),
              const SizedBox(height: 14),

              // Documents Required
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.borderSubtle),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.folder_shared_outlined, color: Color(0xFFD97706), size: 22),
                          SizedBox(width: 10),
                          Text(
                            'தேவையான ஆவணங்கள் (Documents)',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...scheme.documentsRequiredTa.map(
                        (doc) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, color: AppColors.primaryGreen, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(doc, style: const TextStyle(fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Application Process
              _buildSectionCard(
                icon: Icons.how_to_reg_outlined,
                iconColor: const Color(0xFF7C3AED),
                title: 'விண்ணப்பிக்கும் முறை (How to Apply)',
                content: scheme.applicationProcessTa,
              ),
              const SizedBox(height: 24),

              // Helpline & Action Buttons
              if (scheme.helplineNumber != null) ...[
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: AppColors.primaryGreen, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.phone, color: AppColors.primaryGreen),
                  label: Text(
                    'உதவி எண்: ${scheme.helplineNumber} (அழைக்க தொடவும்)',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  onPressed: () => _callHelpline(scheme.helplineNumber!),
                ),
                const SizedBox(height: 12),
              ],

              if (scheme.officialPortalUrl != null) ...[
                UzhavanButton(
                  label: 'அரசு அதிகாரப்பூர்வ தளம் செல்ல',
                  icon: Icons.open_in_new,
                  onPressed: () => _openPortal(scheme.officialPortalUrl!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
