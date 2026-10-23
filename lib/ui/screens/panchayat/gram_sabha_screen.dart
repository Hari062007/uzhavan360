import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/panchayat_provider.dart';
import '../../common/empty_state_view.dart';
import '../../common/voice_speaker_button.dart';

class GramSabhaScreen extends StatelessWidget {
  const GramSabhaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final panchayat = Provider.of<PanchayatProvider>(context);

    const voiceText =
        'கிராம சபை கூட்டங்கள் பற்றிய விபரங்கள், நடைபெறும் இடம், நாள் மற்றும் நிகழ்ச்சி நிரல் இங்கே கொடுக்கப்பட்டுள்ளன.';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('கிராம சபை கூட்டங்கள்'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: VoiceSpeakerButton(textToSpeak: voiceText),
          ),
        ],
      ),
      body: panchayat.gramSabhas.isEmpty
          ? const EmptyStateView(
              title: 'கிராம சபை அறிவிப்புகள் இல்லை',
              subtitle: 'அடுத்த கிராம சபை கூட்டம் அறிவிக்கப்படும்போது இங்கே விபரம் தோன்றும்.',
              icon: Icons.event_busy_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: panchayat.gramSabhas.length,
              itemBuilder: (context, index) {
                final meeting = panchayat.gramSabhas[index];
                final dateStr = '${meeting.meetingDate.day}/${meeting.meetingDate.month}/${meeting.meetingDate.year}';

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                meeting.village,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1D4ED8),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.greenLightBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                meeting.status == 'scheduled' ? 'திட்டமிடப்பட்டுள்ளது' : 'நிறைவுற்றது',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'கிராம சபை பொதுக்கூட்டம்',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Date & Venue highlights
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceWarmWhite,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.primaryGreen),
                                  const SizedBox(width: 8),
                                  Text(
                                    'நாள்: $dateStr | நேரம்: ${meeting.meetingTime}',
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.place_outlined, size: 18, color: AppColors.primaryGreen),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'இடம்: ${meeting.venue}',
                                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Agenda
                        const Text(
                          'நிகழ்ச்சி நிரல் (Meeting Agenda):',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          meeting.agendaTa,
                          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.45),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            VoiceSpeakerButton(
                              textToSpeak:
                                  'கிராம சபை கூட்டம் $dateStr அன்று ${meeting.meetingTime} மணிக்கு ${meeting.venue} இடத்தில் நடைபெறும். நிகழ்ச்சி நிரல்: ${meeting.agendaTa}',
                              size: 20,
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
