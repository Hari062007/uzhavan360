import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/profile_provider.dart';
import '../../../state/panchayat_provider.dart';
import '../../common/stat_card.dart';
import '../../common/voice_speaker_button.dart';
import '../panchayat/announcements_screen.dart';
import '../panchayat/gram_sabha_screen.dart';
import '../panchayat/public_funds_screen.dart';
import '../panchayat/complaints_screen.dart';
import '../panchayat/official_admin_screen.dart';

class PanchayatDashboard extends StatelessWidget {
  const PanchayatDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final panchayat = Provider.of<PanchayatProvider>(context);
    final isVerified = profile.isOfficialVerified;

    final voiceText = isVerified
        ? 'வணக்கம் பஞ்சாயத்து அதிகாரி அவர்களே! கிராம சபை, நிதி ஒதுக்கீடு மற்றும் மக்கள் குறைதீர்ப்பு பணிகளை இங்கே நிர்வகிக்கலாம்.'
        : 'பஞ்சாயத்து கணக்கு சரிபார்ப்பு நிலுவையில் உள்ளது. நீங்கள் கிராம பொது அறிவிப்புகளைப் பார்வையிடலாம்.';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isVerified ? AppColors.greenLightBg : const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isVerified ? AppColors.primaryGreen.withValues(alpha: 0.3) : const Color(0xFFF59E0B),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isVerified ? AppColors.primaryGreen : const Color(0xFFD97706),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isVerified ? Icons.verified : Icons.admin_panel_settings_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              profile.fullName.isNotEmpty ? profile.fullName : 'பஞ்சாயத்து நிர்வாகி',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified, color: AppColors.primaryGreen, size: 18),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${profile.selectedVillageTa} ஊராட்சி மன்றம்',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                VoiceSpeakerButton(textToSpeak: voiceText),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Security Verification Warning Banner for Unverified Officials
          if (!isVerified) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.gpp_maybe, color: Color(0xFFDC2626), size: 22),
                      SizedBox(width: 8),
                      Text(
                        'கணக்கு சரிபார்ப்பு நிலுவையில் உள்ளது',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF991B1B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'பஞ்சாயத்து அலுவலக அதிகாரப்பூர்வ அறிவிப்புகள் வெளியிட மற்றும் நிதி பதிவேடுகளை மாற்ற அரசு நிர்வாக ஒப்புதல் தேவை. பொது தகவல்களை மட்டும் தற்போது பார்வையிடலாம்.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF7F1D1D), height: 1.3),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    icon: const Icon(Icons.verified_user_outlined, size: 18),
                    label: const Text('டெமோ: சரிபார்ப்பை ஒப்புதல் செய்க (Verify)'),
                    onPressed: () {
                      profile.toggleOfficialVerification(true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('பஞ்சாயத்து அதிகாரி கணக்கு சரிபார்க்கப்பட்டு அங்கீகரிக்கப்பட்டது!'),
                          backgroundColor: AppColors.primaryGreen,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ] else ...[
            // Verified Official Quick Administrative Action
            Card(
              color: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.security, color: Colors.white, size: 32),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'அதிகாரப்பூர்வ நிர்வாக தளம்',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'அறிவிப்புகள், கிராம சபை & நிதி மேலாண்மை',
                            style: TextStyle(fontSize: 13, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OfficialAdminScreen()),
                        );
                      },
                      child: const Text('நிர்வாகம்', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          const Text(
            'ஊராட்சி மன்ற பொது விபரங்கள்',
            style: TextStyle(
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
                title: 'கிராம சபை கூட்டங்கள்',
                subtitle: '${panchayat.gramSabhas.length} கூட்ட விபரம்',
                icon: Icons.event_note_outlined,
                color: const Color(0xFF2563EB),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GramSabhaScreen()),
                  );
                },
              ),
              StatCard(
                title: 'பஞ்சாயத்து நிதி கணக்கு',
                subtitle: 'வெளிப்படைத்தன்மை',
                icon: Icons.account_balance_wallet_outlined,
                color: const Color(0xFF059669),
                badgeText: 'வெளிப்படை',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PublicFundsScreen()),
                  );
                },
              ),
              StatCard(
                title: 'கிராம அறிவிப்புகள்',
                subtitle: '${panchayat.announcements.length} அறிவிப்புகள்',
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
                title: 'மக்கள் குறைதீர்ப்பு',
                subtitle: '${panchayat.complaints.length} புகார்கள்',
                icon: Icons.report_problem_outlined,
                color: const Color(0xFFD97706),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ComplaintsScreen()),
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
