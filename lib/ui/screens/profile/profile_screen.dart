import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/user_role.dart';
import '../../../state/profile_provider.dart';
import '../../../state/locale_provider.dart';
import '../../../state/auth_provider.dart';
import '../../common/uzhavan_button.dart';
import '../../common/voice_speaker_button.dart';
import '../onboarding/village_selection_screen.dart';
import '../onboarding/role_selection_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final bool isTab;

  const ProfileScreen({super.key, this.isTab = false});

  void _handleLogout(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.logout();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final localeProv = Provider.of<LocaleProvider>(context);
    final phone = StorageService.getPhoneNumber() ?? '+91 98421 00000';
    final lang = Localizations.localeOf(context).languageCode;
    final village = lang == 'ta' ? profile.selectedVillageTa : profile.selectedVillage;
    final taluk = lang == 'ta' ? profile.selectedTalukTa : profile.selectedTaluk;
    final district = lang == 'ta' ? profile.selectedDistrictTa : profile.selectedDistrict;
    final userName = profile.fullName.isNotEmpty ? profile.fullName : context.tr('farmer_default');

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: isTab
          ? null
          : AppBar(
              title: Text(context.tr('profile_title')),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: VoiceSpeakerButton(
                    textToSpeak: context.tr('profile_voice_instruction'),
                  ),
                ),
              ],
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Avatar and Name Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.greenLightBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 38),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreenDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            phone,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Current Role Card with switcher
              Card(
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
                          Text(
                            context.tr('current_role'),
                            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                              );
                            },
                            child: Text(
                              context.tr('change_btn'),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(profile.selectedRole.icon, color: AppColors.primaryGreen, size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              profile.selectedRole.localizedTitle(context),
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Village Card with switcher
              Card(
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
                          Text(
                            context.tr('village_location'),
                            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const VillageSelectionScreen()),
                              );
                            },
                            child: Text(
                              context.tr('change_btn'),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: AppColors.primaryGreen, size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  village,
                                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '$taluk ${context.tr('taluk_suffix')}, $district ${context.tr('district_suffix')}',
                                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Language Setting
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.borderSubtle),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.language, color: AppColors.primaryGreen, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            context.tr('app_language'),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      DropdownButton<String>(
                        value: localeProv.locale.languageCode,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'ta', child: Text('தமிழ்')),
                          DropdownMenuItem(value: 'en', child: Text('English')),
                        ],
                        onChanged: (val) {
                          if (val != null) localeProv.setLocale(val);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Privacy & Data Security Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarmWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: AppColors.primaryGreen, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        context.tr('privacy_statement'),
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Logout Button
              UzhavanButton(
                label: context.tr('logout_btn'),
                icon: Icons.logout,
                isSecondary: true,
                onPressed: () => _handleLogout(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
