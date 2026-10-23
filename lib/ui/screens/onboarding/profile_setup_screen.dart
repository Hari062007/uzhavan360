import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/services/storage_service.dart';
import '../../../state/profile_provider.dart';
import '../../common/uzhavan_button.dart';
import '../../common/uzhavan_text_field.dart';
import '../../common/voice_speaker_button.dart';
import 'village_selection_screen.dart';
import 'role_selection_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    _nameController.text = profile.fullName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _proceed(ProfileProvider profile) {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('தயவுசெய்து உங்கள் பெயரை உள்ளிடவும்'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    profile.setFullName(_nameController.text.trim());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final verifiedPhone = StorageService.getPhoneNumber() ?? '+91 98421 00000';
    const voiceInstruction = 'உங்கள் பெயர் மற்றும் கிராம விவரங்களை உள்ளிட்டு சேமிக்கவும்.';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(context.tr('profile_setup_title')),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: VoiceSpeakerButton(textToSpeak: voiceInstruction),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.tr('profile_setup_sub'),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),

              // Verified Phone (Read-Only)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarmWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user, color: AppColors.primaryGreen, size: 24),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'சரிபார்க்கப்பட்ட மொபைல் எண்',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          verifiedPhone,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Full Name
              UzhavanTextField(
                label: context.tr('full_name_label'),
                hint: 'எ.கா: வேலுச்சாமி',
                controller: _nameController,
                prefix: const Icon(Icons.person_outline, color: AppColors.primaryGreen),
              ),
              const SizedBox(height: 24),

              // Village Card with hierarchy
              const Text(
                'கிராமம் மற்றும் இருப்பிடம்',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.greenLightBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.primaryGreen, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${profile.selectedVillageTa} (${profile.selectedVillage})',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreenDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${profile.selectedTalukTa} வட்டம், ${profile.selectedDistrictTa} மாவட்டம்',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Auto-detect button
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: AppColors.primaryGreen),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.my_location, size: 18, color: AppColors.primaryGreen),
                            label: const Text(
                              'தானாகக் கண்டறி',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                            ),
                            onPressed: () => profile.autoDetectLocation(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Manual selection button
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.edit_location_alt, size: 18),
                            label: const Text(
                              'நேரடியாகத் தேர்வு',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const VillageSelectionScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Continue to role selection
              UzhavanButton(
                label: 'அடுத்த பகுதி: பணித் தேர்வு',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => _proceed(profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
