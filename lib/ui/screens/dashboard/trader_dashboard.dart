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
import '../market/record_transaction_screen.dart';

class TraderDashboard extends StatelessWidget {
  const TraderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final cropProv = Provider.of<CropPriceProvider>(context);

    const voiceText =
        'வணக்கம்! நீங்கள் தினசரி விளைபொருள் கொள்முதல் விலையை 3 தரநிலைகளில் பதிவிடலாம் மற்றும் முடிக்கப்பட்ட விற்பனை விலையைப் பதிவு செய்யலாம்.';

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
                    color: Color(0xFFD97706),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shopping_basket, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${profile.fullName} (கொள்முதல் வியாபாரி)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreenDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'மண்டி: ${profile.selectedVillageTa}, ${profile.selectedDistrictTa}',
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

          // Trader Primary Callout: Upload 3-Tier Prices
          Card(
            color: const Color(0xFFB45309),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.rate_review_outlined, color: Colors.white, size: 26),
                      SizedBox(width: 10),
                      Text(
                        'இன்றைய பயிர் விலை பதிவிட',
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
                    'முதல் தரம், இரண்டாம் தரம் மற்றும் மூன்றாம் தரத்திற்கான கொள்முதல் விலையை விவசாயிகளுக்கு தெரிவிக்கவும்.',
                    style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.3),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFB45309),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UploadCropPriceScreen()),
                      );
                    },
                    child: const Text(
                      'விலைப்பட்டியல் சேர்க்க',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Mandatory Separation Callout: Record Actual Transaction
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF16A34A).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_outlined, color: Color(0xFF16A34A), size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'முடிக்கப்பட்ட விற்பனை பதிவு',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF14532D),
                        ),
                      ),
                      Text(
                        'உண்மையான விற்பனை விலையை தனிப் பதிவேட்டில் சேர்க்க',
                        style: TextStyle(fontSize: 12, color: Color(0xFF166534)),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RecordTransactionScreen()),
                    );
                  },
                  child: const Text('பதிவு செய்', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
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
                title: 'சந்தை விலை விவரம்',
                subtitle: '${cropProv.traderOffers.length} விலை அறிவிப்புகள்',
                icon: Icons.price_change_outlined,
                color: const Color(0xFFD97706),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CropPricesScreen()),
                  );
                },
              ),
              StatCard(
                title: 'உண்மையான விற்பனை',
                subtitle: '${cropProv.actualTransactions.length} பதிவுகள்',
                icon: Icons.receipt_long_outlined,
                color: const Color(0xFF059669),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CropPricesScreen()),
                  );
                },
              ),
              StatCard(
                title: 'மண்டி அறிவிப்புகள்',
                subtitle: 'ஒழுங்குமுறை கூடம்',
                icon: Icons.campaign_outlined,
                color: const Color(0xFF2563EB),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CropPricesScreen()),
                  );
                },
              ),
              StatCard(
                title: 'பயிர்களின் வரலாறு',
                subtitle: 'கடந்த மாத விலைகள்',
                icon: Icons.timeline_outlined,
                color: const Color(0xFF7C3AED),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CropPricesScreen()),
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
