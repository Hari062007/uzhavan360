import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../state/profile_provider.dart';
import '../../../state/crop_price_provider.dart';
import '../../common/stat_card.dart';
import '../../common/voice_speaker_button.dart';
import '../market/crop_prices_screen.dart';
import '../market/upload_crop_price_screen.dart';
import '../jobs/job_listings_screen.dart';
import '../jobs/post_job_screen.dart';
import '../schemes/schemes_screen.dart';
import '../panchayat/announcements_screen.dart';

class LandownerTraderDashboard extends StatelessWidget {
  const LandownerTraderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final cropProv = Provider.of<CropPriceProvider>(context);

    const voiceText =
        'வணக்கம்! நீங்கள் உங்கள் நிலத்திற்கு ஆட்களைத் தேடலாம் மற்றும் விளைபொருட்களின் தினசரி 3 தர சந்தை விலைகளைப் பதிவிடலாம்.';

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
                  child: const Icon(Icons.storefront, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${profile.fullName} (நில உரிமையாளர் + வியாபாரி)',
                        style: const TextStyle(
                          fontSize: 16,
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

          // Primary Actions in 2-Card Row: Post Crop Price & Post Job
          Row(
            children: [
              Expanded(
                child: Card(
                  color: const Color(0xFFD97706),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UploadCropPriceScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.add_chart_outlined, color: Colors.white, size: 30),
                          SizedBox(height: 10),
                          Text(
                            'சந்தை விலை பதிவேற்றம்',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '3 தரநிலைகளில் விலை நிர்ணயம்',
                            style: TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  color: AppColors.primaryGreen,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PostJobScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.person_add_alt_1, color: Colors.white, size: 30),
                          SizedBox(height: 10),
                          Text(
                            'ஆட்கள் தேவை பதிவு',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'பண்ணை வேலைக்கு ஆட்கள்',
                            style: TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                subtitle: '${cropProv.traderOffers.length} விலை அறிவிப்புகள்',
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
                title: 'வேலை வாய்ப்புகள்',
                subtitle: 'வேலைகளைப் பார்க்க',
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
                title: 'அரசு மானியங்கள்',
                subtitle: 'விவசாயத் திட்டங்கள்',
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
                title: 'பஞ்சாயத்து செய்திகள்',
                subtitle: 'அறிவிப்புகள்',
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
