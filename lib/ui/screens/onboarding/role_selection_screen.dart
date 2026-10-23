import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../data/models/user_role.dart';
import '../../../state/profile_provider.dart';
import '../../common/uzhavan_button.dart';
import '../../common/voice_speaker_button.dart';
import '../dashboard/main_dashboard_shell.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  AppRole _selectedRole = AppRole.worker;

  @override
  void initState() {
    super.initState();
    _selectedRole = Provider.of<ProfileProvider>(context, listen: false).selectedRole;
  }

  void _finishSetup(ProfileProvider profile) async {
    profile.setRole(_selectedRole);
    final success = await profile.saveProfileSetup();

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainDashboardShell()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    const voiceText =
        'உங்களுக்குப் பொருத்தமான முதன்மைப் பணியைத் தேர்வு செய்யவும். பின்னர் தேவையான மற்ற பணிகளையும் சேர்த்துக்கொள்ளலாம்.';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(context.tr('role_selection_title')),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: VoiceSpeakerButton(textToSpeak: voiceText),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.tr('role_selection_sub'),
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // 5 Roles List
              Expanded(
                child: ListView(
                  children: [
                    _buildRoleCard(
                      role: AppRole.worker,
                      titleTa: context.tr('role_worker'),
                      descTa: context.tr('role_worker_desc'),
                      icon: Icons.agriculture,
                      tag: 'வேலை தேடுவோர்',
                    ),
                    _buildRoleCard(
                      role: AppRole.workerLandowner,
                      titleTa: context.tr('role_worker_landowner'),
                      descTa: context.tr('role_worker_landowner_desc'),
                      icon: Icons.nature_people,
                      tag: 'பண்ணை உரிமையாளர்',
                    ),
                    _buildRoleCard(
                      role: AppRole.landownerTrader,
                      titleTa: context.tr('role_landowner_trader'),
                      descTa: context.tr('role_landowner_trader_desc'),
                      icon: Icons.storefront,
                      tag: 'சாகுபடி & வியாபாரம்',
                    ),
                    _buildRoleCard(
                      role: AppRole.trader,
                      titleTa: context.tr('role_trader'),
                      descTa: context.tr('role_trader_desc'),
                      icon: Icons.shopping_basket,
                      tag: 'மண்டி கொள்முதல்',
                    ),
                    _buildRoleCard(
                      role: AppRole.panchayatOfficial,
                      titleTa: context.tr('role_official'),
                      descTa: context.tr('role_official_desc'),
                      icon: Icons.account_balance,
                      tag: 'அரசு நிர்வாகம்',
                      requiresVerification: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              UzhavanButton(
                label: 'முடித்து முகப்புக்குச் செல்க',
                icon: Icons.done_all,
                isLoading: profile.isLoading,
                onPressed: () => _finishSetup(profile),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required AppRole role,
    required String titleTa,
    required String descTa,
    required IconData icon,
    required String tag,
    bool requiresVerification = false,
  }) {
    final isSelected = _selectedRole == role;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() => _selectedRole = role);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.greenLightBg : AppColors.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primaryGreen : AppColors.borderSubtle,
              width: isSelected ? 2.5 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryGreen : AppColors.primaryGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.white : AppColors.primaryGreen,
                      size: 26,
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
                                titleTa,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? AppColors.primaryGreenDark : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 22),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentGoldLight.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreenDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                descTa,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
              if (requiresVerification) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.5)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.shield_outlined, color: AppColors.accentGold, size: 16),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'பாதுகாப்பு: அதிகாரப்பூர்வ சரிபார்ப்புக்குப் பிறகே பஞ்சாயத்து அதிகாரங்கள் செயல்படும்.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7B5E1E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
