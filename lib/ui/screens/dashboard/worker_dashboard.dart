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
import '../weather/weather_screen.dart';

class WorkerDashboard extends StatelessWidget {
  const WorkerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final job = Provider.of<JobProvider>(context);
    final weatherProv = Provider.of<WeatherProvider>(context);
    final weather = weatherProv.weather;
    final lang = Localizations.localeOf(context).languageCode;
    final village = lang == 'ta' ? profile.selectedVillageTa : profile.selectedVillage;
    final taluk = lang == 'ta' ? profile.selectedTalukTa : profile.selectedTaluk;
    final userName = profile.fullName.isNotEmpty ? profile.fullName : context.tr('farmer_default');

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
                        '${context.tr('dashboard_greeting')}$userName',
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
                            '$village, $taluk',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                VoiceSpeakerButton(
                  textToSpeak: context.tr('worker_voice_welcome'),
                ),
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
                              '${weather.temperature.toStringAsFixed(1)}°C - ${lang == 'ta' ? weather.conditionTa : weather.conditionEn}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A8A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${context.tr('rain_chance')}: ${weather.rainProbability}% | ${context.tr('humidity')}: ${weather.humidity}%',
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

          Text(
            context.tr('quick_services'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // 4 Focused Service Cards for Worker
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StatCard(
                title: context.tr('find_jobs'),
                subtitle: '${job.jobs.length} ${context.tr('jobs_ready')}',
                icon: Icons.work_outline,
                badgeText: context.tr('badge_new'),
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
                subtitle: context.tr('mandi_daily_price'),
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
                title: context.tr('my_applications'),
                subtitle: '${job.myApplications.length} ${context.tr('my_applications_count')}',
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
                title: context.tr('weather_title'),
                subtitle: context.tr('weather_summary'),
                icon: Icons.cloud_outlined,
                color: const Color(0xFF2563EB),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WeatherScreen()),
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
