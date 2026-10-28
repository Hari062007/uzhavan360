import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../data/models/user_role.dart';
import '../../../state/profile_provider.dart';
import '../../common/voice_speaker_button.dart';
import 'worker_dashboard.dart';
import 'owner_dashboard.dart';
import 'trader_dashboard.dart';
import '../jobs/job_listings_screen.dart';
import '../market/crop_prices_screen.dart';
import '../profile/profile_screen.dart';
import '../onboarding/village_selection_screen.dart';

class MainDashboardShell extends StatefulWidget {
  const MainDashboardShell({super.key});

  @override
  State<MainDashboardShell> createState() => _MainDashboardShellState();
}

class _MainDashboardShellState extends State<MainDashboardShell> {
  int _currentIndex = 0;

  Widget _getRoleBasedHome(AppRole role) {
    switch (role) {
      case AppRole.owner:
      case AppRole.workerLandowner:
      case AppRole.landownerTrader:
        return const OwnerDashboard();
      case AppRole.trader:
        return const TraderDashboard();
      case AppRole.worker:
      case AppRole.panchayatOfficial:
        return const WorkerDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final lang = Localizations.localeOf(context).languageCode;
    final village = lang == 'ta' ? profile.selectedVillageTa : profile.selectedVillage;

    final List<Widget> pages = [
      _getRoleBasedHome(profile.selectedRole),
      const JobListingsScreen(isTab: true),
      const CropPricesScreen(isTab: true),
      const ProfileScreen(isTab: true),
    ];

    final voiceWelcome = lang == 'ta'
        ? 'UZHAVAN360 செயலிற்கு நல்வரவு. வேலைகள், சந்தை விலை மற்றும் உங்கள் சுயவிவரத்தைக் கீழேயுள்ள பட்டியலைத் தொட்டுப் பார்க்கலாம்.'
        : 'Welcome to UZHAVAN360. Explore jobs, crop market prices, and manage your profile using the navigation tabs below.';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Image.asset(
            'assets/images/uzhavan360_logo.jpg',
            fit: BoxFit.contain,
          ),
        ),
        title: Column(
          children: [
            const Text(
              'UZHAVAN360',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
                color: AppColors.primaryGreenDark,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VillageSelectionScreen()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, size: 12, color: AppColors.primaryGreen),
                  const SizedBox(width: 3),
                  Text(
                    '$village ▼',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: VoiceSpeakerButton(textToSpeak: voiceWelcome),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryGreen.withValues(alpha: 0.16),
        elevation: 8,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home, color: AppColors.primaryGreen),
            label: context.tr('nav_home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.work_outline),
            selectedIcon: const Icon(Icons.work, color: AppColors.primaryGreen),
            label: context.tr('nav_jobs'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.storefront_outlined),
            selectedIcon: const Icon(Icons.storefront, color: AppColors.primaryGreen),
            label: context.tr('nav_market'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person, color: AppColors.primaryGreen),
            label: context.tr('nav_profile'),
          ),
        ],
      ),
    );
  }
}
