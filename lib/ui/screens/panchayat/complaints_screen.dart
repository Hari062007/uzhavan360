import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/panchayat_provider.dart';
import '../../common/empty_state_view.dart';
import '../../common/voice_speaker_button.dart';
import 'submit_complaint_screen.dart';

class ComplaintsScreen extends StatelessWidget {
  const ComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final panchayat = Provider.of<PanchayatProvider>(context);

    const voiceText =
        'கிராமப் பொது பிரச்சனைகள், குடிநீர், தெருவிளக்கு மற்றும் சாலை குறைகளை இங்கே பதிவு செய்து அதன் நிலவரத்தைக் கண்காணிக்கலாம்.';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('கிராமக் குறைகள் & புகார்கள்'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: VoiceSpeakerButton(textToSpeak: voiceText),
          ),
        ],
      ),
      body: panchayat.complaints.isEmpty
          ? const EmptyStateView(
              title: 'புகார்கள் எதுவும் இல்லை',
              subtitle: 'உங்கள் பகுதியில் குடிநீர், தெருவிளக்கு அல்லது சாலை பிரச்சனைகள் இருந்தால் கீழே உள்ள பட்டனைத் தொட்டு புகார் அளிக்கலாம்.',
              icon: Icons.checklist_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: panchayat.complaints.length,
              itemBuilder: (context, index) {
                final complaint = panchayat.complaints[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                complaint.categoryLabelTa,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: complaint.status == 'action_taken' || complaint.status == 'resolved'
                                    ? AppColors.greenLightBg
                                    : const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                complaint.status == 'action_taken'
                                    ? 'நடவடிக்கை எடுக்கப்பட்டது'
                                    : complaint.status == 'resolved'
                                        ? 'தீர்க்கப்பட்டது'
                                        : 'பரிசீலனையில்',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: complaint.status == 'action_taken' || complaint.status == 'resolved'
                                      ? AppColors.primaryGreen
                                      : const Color(0xFF1D4ED8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          complaint.description,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            height: 1.35,
                          ),
                        ),
                        if (complaint.officialResponse != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceWarmWhite,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.admin_panel_settings, size: 18, color: AppColors.primaryGreen),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'பஞ்சாயத்து அலுவலக பதில்:',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryGreenDark,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        complaint.officialResponse!,
                                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_comment_outlined),
        label: const Text('புதிய புகார் அளிக்க', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SubmitComplaintScreen()),
          );
        },
      ),
    );
  }
}
