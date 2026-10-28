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
    final current = Provider.of<ProfileProvider>(context, listen: false).selectedRole;
    if (current == AppRole.worker || current == AppRole.owner || current == AppRole.trader) {
      _selectedRole = current;
    } else {
      _selectedRole = AppRole.worker;
    }
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

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(context.tr('role_selection_title')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: VoiceSpeakerButton(
              textToSpeak: context.tr('role_voice_instruction'),
            ),
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
              const SizedBox(height: 20),

              // Exclusively 3 Citizen Roles for First Release
              Expanded(
                child: ListView(
                  children: [
                    _buildRoleCard(
                      role: AppRole.worker,
                      title: context.tr('role_worker'),
                      tag: context.tr('role_worker_tag'),
                      desc: context.tr('role_worker_desc'),
                      icon: Icons.agriculture,
                    ),
                    const SizedBox(height: 14),
                    _buildRoleCard(
                      role: AppRole.owner,
                      title: context.tr('role_owner'),
                      tag: context.tr('role_owner_tag'),
                      desc: context.tr('role_owner_desc'),
                      icon: Icons.nature_people,
                    ),
                    const SizedBox(height: 14),
                    _buildRoleCard(
                      role: AppRole.trader,
                      title: context.tr('role_trader'),
                      tag: context.tr('role_trader_tag'),
                      desc: context.tr('role_trader_desc'),
                      icon: Icons.shopping_basket,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              UzhavanButton(
                label: context.tr('role_finish_btn'),
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
    required String title,
    required String tag,
    required String desc,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == role;

    return InkWell(
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
                              title,
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
              desc,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
