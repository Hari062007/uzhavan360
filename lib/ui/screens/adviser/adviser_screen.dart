import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/adviser_model.dart';
import '../../../data/repositories/adviser_repository.dart';
import '../../common/voice_speaker_button.dart';

class AdviserScreen extends StatefulWidget {
  const AdviserScreen({super.key});

  @override
  State<AdviserScreen> createState() => _AdviserScreenState();
}

class _AdviserScreenState extends State<AdviserScreen> {
  final AdviserRepository _repo = AdviserRepository();
  List<AdviserModel> _advisers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final list = await _repo.fetchAdvisers();
    if (mounted) {
      setState(() {
        _advisers = list;
        _isLoading = false;
      });
    }
  }

  void _callAdviser(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    const voiceText =
        'அனுபவம் வாய்ந்த முன்னோடி விவசாயிகளிடம் பயிர் நோய், பூச்சி மேலாண்மை மற்றும் சாகுபடி ஆலோசனைகளை நேரடியாகப் பெறலாம்.';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('முன்னோடி உழவர் வழிகாட்டல்'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: VoiceSpeakerButton(textToSpeak: voiceText),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _advisers.length,
              itemBuilder: (context, index) {
                final adv = _advisers[index];

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
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.greenLightBg,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                              ),
                              child: const Icon(Icons.person, color: AppColors.primaryGreen, size: 30),
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
                                          adv.fullName,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      if (adv.isVerified) ...[
                                        const SizedBox(width: 4),
                                        const Icon(Icons.verified, color: AppColors.primaryGreen, size: 18),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${adv.village}, ${adv.district} • ${adv.experienceYears} வருட அனுபவம்',
                                    style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Specializations Chips
                        const Text(
                          'ஆலோசனை வழங்கும் துறைகள்:',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: adv.specializationsTa.map((spec) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceWarmWhite,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.borderSubtle),
                              ),
                              child: Text(
                                spec,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryGreenDark),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 14),

                        // Timing and Call Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16, color: AppColors.textMuted),
                                const SizedBox(width: 6),
                                Text(
                                  'நேரம்: ${adv.availableHours}',
                                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.call, size: 16),
                              label: const Text('அழைக்க', style: TextStyle(fontWeight: FontWeight.bold)),
                              onPressed: () => _callAdviser(adv.contactPhone),
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
