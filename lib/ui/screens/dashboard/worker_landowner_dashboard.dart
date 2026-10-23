import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../state/profile_provider.dart';
import '../../../state/job_provider.dart';
import '../../common/stat_card.dart';
import '../../common/voice_speaker_button.dart';
import '../jobs/job_listings_screen.dart';
import '../jobs/post_job_screen.dart';
import '../jobs/my_applications_screen.dart';
import '../market/crop_prices_screen.dart';
import '../schemes/schemes_screen.dart';
import '../panchayat/announcements_screen.dart';

class WorkerLandownerDashboard extends StatelessWidget {
  const WorkerLandownerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final job = Provider.of<JobProvider>(context);

    const voiceText =
        'வணக்கம்! நீங்கள் உங்கள் நிலத்திற்கு வேலை ஆட்களைத் தேடலாம் அல்லது மற்ற நிலங்களில் வேலை வாய்ப்புகளைப் பெறலாம்.';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.greenLightBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.nature_people, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${profile.fullName} (நில உரிமையாளர்)',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreenDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${profile.selectedVillageTa}, ${profile.selectedTalukTa}',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const VoiceSpeakerButton(textToSpeak: voiceText),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Primary Landowner Call to Action: Post Job
          Card(
            color: AppColors.primaryGreen,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.add_circle_outline, color: Colors.white, size: 26),
                      SizedBox(width: 10),
                      Text(
                        'பண்ணை வேலைக்கு ஆட்கள் தேவையா?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'உங்கள் கிராமம் மற்றும் அருகிலுள்ள விவசாயத் தொழிலாளர்களுக்கு உடனடியாக அறிவிப்பு அனுப்பலாம்.',
                    style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.3),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PostJobScreen()),
                      );
                    },
                    child: const Text(
                      'ஆட்கள் தேவை என பதிவிட',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            context.tr('quick_services'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StatCard(
                title: context.tr('find_jobs'),
                subtitle: '${job.jobs.length} வேலைகள்',
                icon: Icons.work_outline,
                color: AppColors.primaryGreen,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const JobListingsScreen()),
                  );
                },
              ),
              StatCard(
                title: 'என் நில வேலை பதிவுகள்',
                subtitle: 'விண்ணப்பதாரர்களைப் பார்க்க',
                icon: Icons.assignment_outlined,
                color: const Color(0xFF0D9488),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const JobListingsScreen()),
                  );
                },
              ),
              StatCard(
                title: context.tr('crop_market_prices'),
                subtitle: 'சந்தை விலை நிலவரம்',
                icon: Icons.storefront,
                color: const Color(0xFFD97706),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CropPricesScreen()),
                  );
                },
              ),
              StatCard(
                title: context.tr('government_schemes_title'),
                subtitle: 'வேளாண் மானியங்கள்',
                icon: Icons.account_balance,
                color: const Color(0xFF2563EB),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SchemesScreen()),
                  );
                },
              ),
              StatCard(
                title: context.tr('my_applications'),
                subtitle: '${job.myApplications.length} விண்ணப்பங்கள்',
                icon: Icons.assignment_turned_in_outlined,
                color: const Color(0xFF059669),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyApplicationsScreen()),
                  );
                },
              ),
              StatCard(
                title: context.tr('village_announcements_title'),
                subtitle: 'ஊராட்சி செய்திகள்',
                icon: Icons.campaign_outlined,
                color: const Color(0xFFDC2626),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AnnouncementsScreen()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
