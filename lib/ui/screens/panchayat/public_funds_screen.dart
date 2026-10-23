import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/panchayat_provider.dart';
import '../../common/empty_state_view.dart';
import '../../common/voice_speaker_button.dart';

class PublicFundsScreen extends StatelessWidget {
  const PublicFundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final panchayat = Provider.of<PanchayatProvider>(context);

    const voiceText =
        'ஊராட்சி மன்றத்தின் பொது நிதி ஒதுக்கீடு மற்றும் மக்கள் நல திட்டங்களுக்கான செலவு விபரங்கள் வெளிப்படைத்தன்மையுடன் இங்கே காட்டப்பட்டுள்ளன.';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('பஞ்சாயத்து பொது நிதி கணக்கு'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: VoiceSpeakerButton(textToSpeak: voiceText),
          ),
        ],
      ),
      body: panchayat.fundRecords.isEmpty
          ? const EmptyStateView(
              title: 'நிதி கணக்கு விபரங்கள் இல்லை',
              subtitle: 'அரசு நிதி பதிவேடுகள் இங்கே சரிபார்க்கப்பட்டு பதிவேற்றப்படும்.',
              icon: Icons.account_balance_wallet_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: panchayat.fundRecords.length,
              itemBuilder: (context, index) {
                final record = panchayat.fundRecords[index];
                final percentSpent = record.allocatedAmount > 0
                    ? (record.spentAmount / record.allocatedAmount).clamp(0.0, 1.0)
                    : 0.0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AppColors.borderSubtle),
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
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'நிதியாண்டு: ${record.financialYear}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1D4ED8),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: record.isVerified ? AppColors.greenLightBg : const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    record.isVerified ? Icons.verified : Icons.help_outline,
                                    size: 13,
                                    color: record.isVerified ? AppColors.primaryGreen : const Color(0xFFB45309),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    record.isVerified ? 'அரசு தணிக்கை பெற்றது' : 'சரிபார்க்கப்படாதது',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: record.isVerified ? AppColors.primaryGreen : const Color(0xFFB45309),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          record.projectNameTa,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          record.projectNameEn,
                          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'நிதி ஆதாரம்: ${record.fundingSource}',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 14),

                        // Financial Progress Bar
                        LinearProgressIndicator(
                          value: percentSpent,
                          minHeight: 8,
                          backgroundColor: AppColors.borderSubtle,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 12),

                        // Financial Numbers
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('ஒதுக்கீடு', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                Text(
                                  '₹${record.allocatedAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('செலவிடப்பட்டது', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                Text(
                                  '₹${record.spentAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('மீதம்', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                Text(
                                  '₹${record.remainingAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: record.projectStatus == 'completed'
                                    ? AppColors.greenLightBg
                                    : const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                record.projectStatus == 'completed' ? 'பணி முடிந்தது' : 'பணி நடைபெறுகிறது',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: record.projectStatus == 'completed'
                                      ? AppColors.primaryGreen
                                      : const Color(0xFF1D4ED8),
                                ),
                              ),
                            ),
                            VoiceSpeakerButton(
                              textToSpeak:
                                  '${record.projectNameTa}. ஒதுக்கப்பட்ட தொகை ரூபாய் ${record.allocatedAmount.toStringAsFixed(0)}. செலவான தொகை ரூபாய் ${record.spentAmount.toStringAsFixed(0)}. மீதமுள்ள தொகை ரூபாய் ${record.remainingAmount.toStringAsFixed(0)}.',
                              size: 18,
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
