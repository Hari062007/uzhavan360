import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/job_provider.dart';
import '../../common/empty_state_view.dart';
import '../../common/voice_speaker_button.dart';

class MyApplicationsScreen extends StatelessWidget {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobProv = Provider.of<JobProvider>(context);
    final apps = jobProv.myApplications;

    const voiceText =
        'நீங்கள் இதுவரை விண்ணப்பித்த விவசாய வேலைகளின் விபரம் மற்றும் முதலாளியின் பதில் நிலவரம் இங்கே உள்ளது.';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('என் விண்ணப்பங்கள்'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: VoiceSpeakerButton(textToSpeak: voiceText),
          ),
        ],
      ),
      body: apps.isEmpty
          ? const EmptyStateView(
              title: 'விண்ணப்பங்கள் எதுவும் இல்லை',
              subtitle: 'நீங்கள் ஏதேனும் வேலைக்கு விண்ணப்பித்தால் அதன் நிலை இங்கே தெரியும்.',
              icon: Icons.assignment_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: apps.length,
              itemBuilder: (context, index) {
                final app = apps[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
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
                                'விண்ணப்ப எண்: ${app.id.substring(app.id.length - 6)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: app.status == 'accepted'
                                    ? AppColors.greenLightBg
                                    : const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                app.status == 'accepted'
                                    ? 'ஏற்றுக்கொள்ளப்பட்டது'
                                    : 'பரிசீலனையில் உள்ளது',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: app.status == 'accepted'
                                      ? AppColors.primaryGreen
                                      : const Color(0xFF1D4ED8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'வேளாண் அறுவடை / பண்ணை வேலை',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              app.shareContactConsent ? Icons.check_circle : Icons.remove_circle_outline,
                              size: 16,
                              color: app.shareContactConsent ? AppColors.primaryGreen : AppColors.textMuted,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              app.shareContactConsent
                                  ? 'தொலைபேசி எண் முதலாளியுடன் பகிரப்பட்டுள்ளது'
                                  : 'தொலைபேசி எண் பகிரப்படவில்லை (பாதுகாப்பானது)',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
