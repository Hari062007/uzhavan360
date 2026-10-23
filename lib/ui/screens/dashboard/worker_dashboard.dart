import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../state/profile_provider.dart';
import '../../../state/job_provider.dart';
import '../../../state/weather_provider.dart';
import '../../common/stat_card.dart';
import '../../common/voice_speaker_button.dart';
import '../jobs/job_listings_screen.dart';
import '../jobs/my_applications_screen.dart';
import '../market/crop_prices_screen.dart';
import '../schemes/schemes_screen.dart';
import '../panchayat/announcements_screen.dart';
import '../weather/weather_screen.dart';
import '../adviser/adviser_screen.dart';

class WorkerDashboard extends StatelessWidget {
  const WorkerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final job = Provider.of<JobProvider>(context);
    final weatherProv = Provider.of<WeatherProvider>(context);
    final weather = weatherProv.weather;

    final voiceInstruction =
        'வணக்கம் ${profile.fullName.isNotEmpty ? profile.fullName : ""}! உங்கள் ஊரில் உள்ள வேளாண் வேலைகள், சந்தை விலை மற்றும் அரசு திட்டங்களை இங்கே காணலாம்.';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Greeting & Voice Header
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
                  child: const Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${context.tr('dashboard_greeting')}${profile.fullName.isNotEmpty ? profile.fullName : "விவசாயி"}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreenDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${profile.selectedVillageTa}, ${profile.selectedTalukTa}',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                VoiceSpeakerButton(textToSpeak: voiceInstruction),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Weather Summary Banner
          if (weather != null)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: const Color(0xFFF0F7FF),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WeatherScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.wb_sunny_outlined, color: Color(0xFFE67E22), size: 36),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weather.temperature.toStringAsFixed(1)}°C - ${weather.conditionTa}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A8A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'மழை வாய்ப்பு: ${weather.rainProbability}% | ஈரப்பதம்: ${weather.humidity}%',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFF1E3A8A)),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Section Title
          Text(
            context.tr('quick_services'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Main Service Grid
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StatCard(
                title: context.tr('find_jobs'),
                subtitle: '${job.jobs.length} வேலைகள் தயார்',
                icon: Icons.work_outline,
                badgeText: 'புதியது',
                color: AppColors.primaryGreen,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const JobListingsScreen()),
                  );
                },
              ),
              StatCard(
                title: context.tr('crop_market_prices'),
                subtitle: 'மண்டி தினசரி விலை',
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
                subtitle: 'மானியங்கள் & உதவிகள்',
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
                subtitle: 'பஞ்சாயத்து செய்திகள்',
                icon: Icons.campaign_outlined,
                color: const Color(0xFFDC2626),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AnnouncementsScreen()),
                  );
                },
              ),
              StatCard(
                title: context.tr('farmer_adviser_title'),
                subtitle: 'முன்னோடி உழவர் உதவி',
                icon: Icons.people_outline,
                color: const Color(0xFF7C3AED),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdviserScreen()),
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
