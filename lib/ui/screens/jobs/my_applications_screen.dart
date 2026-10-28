import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../state/job_provider.dart';
import '../../common/empty_state_view.dart';
import '../../common/voice_speaker_button.dart';

class MyApplicationsScreen extends StatelessWidget {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobProv = Provider.of<JobProvider>(context);
    final apps = jobProv.myApplications;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(context.tr('my_apps_title')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: VoiceSpeakerButton(textToSpeak: context.tr('my_apps_voice')),
          ),
        ],
      ),
      body: apps.isEmpty
          ? EmptyStateView(
              title: context.tr('no_apps_title'),
              subtitle: context.tr('no_apps_sub'),
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
                                '${context.tr('app_id_prefix')}${app.id.substring(app.id.length - 6)}',
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
                                    ? context.tr('status_accepted')
                                    : context.tr('status_pending'),
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
                        Text(
                          context.tr('farm_work_default'),
                          style: const TextStyle(
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
                                  ? context.tr('phone_shared_note')
                                  : context.tr('phone_not_shared_note'),
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
