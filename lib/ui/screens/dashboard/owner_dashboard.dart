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
import '../market/crop_prices_screen.dart';

class OwnerDashboard extends StatelessWidget {
  const OwnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final job = Provider.of<JobProvider>(context);
    final lang = Localizations.localeOf(context).languageCode;
    final village = lang == 'ta' ? profile.selectedVillageTa : profile.selectedVillage;
    final taluk = lang == 'ta' ? profile.selectedTalukTa : profile.selectedTaluk;
    final userName = profile.fullName.isNotEmpty ? profile.fullName : context.tr('farmer_default');

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
                        '$userName (${context.tr('role_owner')})',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreenDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$village, $taluk',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                VoiceSpeakerButton(
                  textToSpeak: context.tr('owner_voice_welcome'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Primary Owner Callout: Post Job
          Card(
            color: AppColors.primaryGreen,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.add_circle_outline, color: Colors.white, size: 26),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          context.tr('post_job_callout_title'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.tr('post_job_callout_desc'),
                    style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.3),
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
                    child: Text(
                      context.tr('post_job_now_btn'),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                title: context.tr('crop_market_prices'),
                subtitle: context.tr('market_prices_sub'),
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
                title: context.tr('crop_price_tiers_title'),
                subtitle: context.tr('crop_price_tiers_sub'),
                icon: Icons.price_check,
                color: const Color(0xFF2E7D32),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CropPricesScreen()),
                  );
                },
              ),
              StatCard(
                title: context.tr('my_posted_jobs'),
                subtitle: context.tr('view_applicants'),
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
                title: context.tr('find_jobs'),
                subtitle: '${job.jobs.length} ${context.tr('jobs_ready')}',
                icon: Icons.work_outline,
                color: AppColors.primaryGreen,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const JobListingsScreen()),
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
