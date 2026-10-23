import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../state/scheme_provider.dart';
import '../../common/empty_state_view.dart';
import '../../common/voice_speaker_button.dart';
import 'scheme_detail_screen.dart';

class SchemesScreen extends StatelessWidget {
  final bool isTab;

  const SchemesScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final schemeProv = Provider.of<SchemeProvider>(context);

    const voiceText =
        'தமிழ்நாடு அரசு மற்றும் மத்திய அரசின் விவசாய மானியத் திட்டங்கள் இங்கே உள்ளன. உங்களுக்குப் பொருத்தமான திட்டங்களைத் தேர்வு செய்து விவரங்களைப் பார்க்கலாம்.';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: isTab
          ? null
          : AppBar(
              title: Text(context.tr('government_schemes_title')),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: VoiceSpeakerButton(textToSpeak: voiceText),
                ),
              ],
            ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'திட்டங்களை அல்லது துறையைத் தேடுக...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
                fillColor: AppColors.surfaceWarmWhite,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.borderSubtle),
                ),
              ),
              onChanged: (val) => schemeProv.setSearchQuery(val),
            ),
          ),

          // Schemes List
          Expanded(
            child: schemeProv.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
                : schemeProv.schemes.isEmpty
                    ? const EmptyStateView(
                        title: 'திட்டங்கள் எதுவும் காணப்படவில்லை',
                        subtitle: 'வேறு வார்த்தைகளை உள்ளிட்டு மீண்டும் முயற்சிக்கவும்.',
                        icon: Icons.account_balance_outlined,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: schemeProv.schemes.length,
                        itemBuilder: (context, index) {
                          final scheme = schemeProv.schemes[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: AppColors.borderSubtle),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SchemeDetailScreen(scheme: scheme),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        scheme.department,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E40AF),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      scheme.titleTa,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      scheme.titleEn,
                                      style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      scheme.summaryTa,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.35),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.greenLightBg,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'அரசு மானியம் உண்டு',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryGreen,
                                            ),
                                          ),
                                        ),
                                        const Row(
                                          children: [
                                            Text(
                                              'விவரம் காண்க',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryGreen,
                                              ),
                                            ),
                                            Icon(Icons.chevron_right, size: 18, color: AppColors.primaryGreen),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
