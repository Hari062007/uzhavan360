import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../data/models/user_role.dart';
import '../../../state/profile_provider.dart';
import '../../common/voice_speaker_button.dart';
import 'worker_dashboard.dart';
import 'worker_landowner_dashboard.dart';
import 'landowner_trader_dashboard.dart';
import 'trader_dashboard.dart';
import 'panchayat_dashboard.dart';
import '../jobs/job_listings_screen.dart';
import '../market/crop_prices_screen.dart';
import '../schemes/schemes_screen.dart';
import '../panchayat/announcements_screen.dart';
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
      case AppRole.workerLandowner:
        return const WorkerLandownerDashboard();
      case AppRole.landownerTrader:
        return const LandownerTraderDashboard();
      case AppRole.trader:
        return const TraderDashboard();
      case AppRole.panchayatOfficial:
        return const PanchayatDashboard();
      case AppRole.worker:
        return const WorkerDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);

    final List<Widget> pages = [
      _getRoleBasedHome(profile.selectedRole),
      const JobListingsScreen(isTab: true),
      const CropPricesScreen(isTab: true),
      const SchemesScreen(isTab: true),
      const AnnouncementsScreen(isTab: true),
      const ProfileScreen(isTab: true),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    '${profile.selectedVillageTa} ▼',
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14.0),
            child: VoiceSpeakerButton(
              textToSpeak: 'UZHAVAN360 செயலியின் முதன்மைப் பக்கம். கீழேயுள்ள பட்டியலைத் தொட்டு வேலைகள், சந்தை விலை மற்றும் அரசு திட்டங்களைப் பார்க்கலாம்.',
            ),
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
            icon: const Icon(Icons.account_balance_outlined),
            selectedIcon: const Icon(Icons.account_balance, color: AppColors.primaryGreen),
            label: context.tr('nav_schemes'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.campaign_outlined),
            selectedIcon: const Icon(Icons.campaign, color: AppColors.primaryGreen),
            label: context.tr('nav_panchayat'),
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
