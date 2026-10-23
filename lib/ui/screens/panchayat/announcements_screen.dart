import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/panchayat_provider.dart';
import '../../common/empty_state_view.dart';
import '../../common/voice_speaker_button.dart';
import 'gram_sabha_screen.dart';
import 'public_funds_screen.dart';
import 'complaints_screen.dart';

class AnnouncementsScreen extends StatelessWidget {
  final bool isTab;

  const AnnouncementsScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final panchayat = Provider.of<PanchayatProvider>(context);

    const voiceText =
        'உங்கள் கிராம ஊராட்சி மன்றத்தின் முக்கிய அறிவிப்புகள், குடிநீர் பராமரிப்பு மற்றும் விவசாய செய்திகள் இங்கே உள்ளன.';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: isTab
          ? null
          : AppBar(
              title: const Text('ஊராட்சி மன்ற அறிவிப்புகள்'),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: VoiceSpeakerButton(textToSpeak: voiceText),
                ),
              ],
            ),
      body: Column(
        children: [
          // Quick navigation strip for Gram Sabha, Funds & Complaints
          Container(
            color: AppColors.surfaceWarmWhite,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      side: const BorderSide(color: AppColors.primaryGreen),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.event_note, size: 16, color: AppColors.primaryGreen),
                    label: const Text('கிராம சபை', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GramSabhaScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      side: const BorderSide(color: Color(0xFF059669)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.account_balance_wallet, size: 16, color: Color(0xFF059669)),
                    label: const Text('நிதி கணக்கு', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PublicFundsScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      side: const BorderSide(color: Color(0xFFD97706)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.report_problem_outlined, size: 16, color: Color(0xFFD97706)),
                    label: const Text('புகார்கள்', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFD97706))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ComplaintsScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Village Announcements List
          Expanded(
            child: panchayat.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
                : panchayat.announcements.isEmpty
                    ? const EmptyStateView(
                        title: 'அறிவிப்புகள் எதுவும் இல்லை',
                        subtitle: 'ஊராட்சி மன்றத்தின் புதிய அறிவிப்புகள் இங்கே தோன்றும்.',
                        icon: Icons.campaign_outlined,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: panchayat.announcements.length,
                        itemBuilder: (context, index) {
                          final ann = panchayat.announcements[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: ann.isUrgent ? const Color(0xFFFCA5A5) : AppColors.borderSubtle,
                                width: ann.isUrgent ? 1.5 : 1,
                              ),
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
                                          color: ann.isUrgent ? const Color(0xFFFEE2E2) : AppColors.greenLightBg,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          ann.isUrgent ? 'அவசர அறிவிப்பு' : 'ஊராட்சி அறிவிப்பு',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: ann.isUrgent ? const Color(0xFFDC2626) : AppColors.primaryGreen,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${ann.village} ஊராட்சி',
                                        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    ann.titleTa,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ann.titleEn,
                                    style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    ann.contentTa,
                                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      VoiceSpeakerButton(
                                        textToSpeak: '${ann.titleTa}. ${ann.contentTa}',
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
          ),
        ],
      ),
    );
  }
}
