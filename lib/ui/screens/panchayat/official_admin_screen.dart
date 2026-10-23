import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/panchayat_provider.dart';
import '../../../state/profile_provider.dart';
import '../../common/uzhavan_button.dart';
import '../../common/uzhavan_text_field.dart';

class OfficialAdminScreen extends StatefulWidget {
  const OfficialAdminScreen({super.key});

  @override
  State<OfficialAdminScreen> createState() => _OfficialAdminScreenState();
}

class _OfficialAdminScreenState extends State<OfficialAdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Announcement Form
  final _annTitleController = TextEditingController();
  final _annContentController = TextEditingController();
  bool _isUrgent = false;

  // Fund Record Form
  final _fundProjectController = TextEditingController();
  final _fundSourceController = TextEditingController(text: '15-வது நிதி ஆணைய மானியம்');
  final _fundAllocatedController = TextEditingController();
  final _fundSpentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _annTitleController.dispose();
    _annContentController.dispose();
    _fundProjectController.dispose();
    _fundSourceController.dispose();
    _fundAllocatedController.dispose();
    _fundSpentController.dispose();
    super.dispose();
  }

  void _postAnnouncement(PanchayatProvider prov) async {
    if (_annTitleController.text.trim().isEmpty || _annContentController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    final success = await prov.postAnnouncement(
      titleTa: _annTitleController.text.trim(),
      titleEn: _annTitleController.text.trim(),
      contentTa: _annContentController.text.trim(),
      contentEn: _annContentController.text.trim(),
      category: _isUrgent ? 'urgent' : 'general',
      isUrgent: _isUrgent,
    );
    setState(() => _isLoading = false);

    if (success && mounted) {
      _annTitleController.clear();
      _annContentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('அறிவிப்பு வெளியிடப்பட்டது!'), backgroundColor: AppColors.primaryGreen),
      );
    }
  }

  void _postFundRecord(PanchayatProvider prov) async {
    if (_fundProjectController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    final success = await prov.postFundRecord(
      financialYear: '2025-2026',
      projectNameTa: _fundProjectController.text.trim(),
      projectNameEn: _fundProjectController.text.trim(),
      fundingSource: _fundSourceController.text.trim(),
      allocatedAmount: double.tryParse(_fundAllocatedController.text.trim()) ?? 0.0,
      spentAmount: double.tryParse(_fundSpentController.text.trim()) ?? 0.0,
      projectStatus: 'in_progress',
    );
    setState(() => _isLoading = false);

    if (success && mounted) {
      _fundProjectController.clear();
      _fundAllocatedController.clear();
      _fundSpentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('நிதி கணக்கு சேர்க்கப்பட்டது!'), backgroundColor: AppColors.primaryGreen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final panchayat = Provider.of<PanchayatProvider>(context);

    if (!profile.isOfficialVerified) {
      return Scaffold(
        appBar: AppBar(title: const Text('நிர்வாக அனுமதி மறுக்கப்பட்டது')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 60, color: AppColors.error),
                const SizedBox(height: 16),
                const Text(
                  'அங்கீகரிக்கப்படாத கணக்கு',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'பஞ்சாயத்து அலுவலக அதிகாரப்பூர்வ பணிகளை மேற்கொள்ள அரசு ஒப்புதல் தேவை.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                UzhavanButton(
                  label: 'டெமோ: சரிபார்ப்பை அனுமதி',
                  onPressed: () {
                    profile.toggleOfficialVerification(true);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('பஞ்சாயத்து நிர்வாகப் பிரிவு'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryGreen,
          labelColor: AppColors.primaryGreen,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'அறிவிப்பு வெளியிட'),
            Tab(text: 'நிதி பதிவேடு'),
            Tab(text: 'குறைதீர்ப்பு'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: Announcement Publishing
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('புதிய கிராம அறிவிப்பு', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                UzhavanTextField(
                  label: 'அறிவிப்பு தலைப்பு',
                  hint: 'எ.கா: குடிநீர் விநியோக பராமரிப்பு',
                  controller: _annTitleController,
                ),
                const SizedBox(height: 16),
                UzhavanTextField(
                  label: 'அறிவிப்பு விபரம்',
                  hint: 'விபரங்களை உள்ளிடவும்',
                  controller: _annContentController,
                  maxLines: 4,
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('அவசர அறிவிப்பாக அறிவிக்க (Urgent Alert)', style: TextStyle(fontWeight: FontWeight.w600)),
                  value: _isUrgent,
                  activeThumbColor: AppColors.error,
                  onChanged: (val) => setState(() => _isUrgent = val),
                ),
                const SizedBox(height: 20),
                UzhavanButton(
                  label: 'அறிவிப்பை வெளியிட',
                  icon: Icons.campaign,
                  isLoading: _isLoading,
                  onPressed: () => _postAnnouncement(panchayat),
                ),
              ],
            ),
          ),

          // TAB 2: Fund Record
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('புதிய திட்ட நிதி ஒதுக்கீடு பதிவு', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                UzhavanTextField(
                  label: 'திட்டத்தின் பெயர்',
                  hint: 'எ.கா: தெற்கு தெரு தார் சாலை அமைத்தல்',
                  controller: _fundProjectController,
                ),
                const SizedBox(height: 16),
                UzhavanTextField(
                  label: 'நிதி ஆதாரம் / திட்டம்',
                  hint: '15-வது நிதி ஆணைய மானியம்',
                  controller: _fundSourceController,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: UzhavanTextField(
                        label: 'ஒதுக்கப்பட்ட நிதி (₹)',
                        hint: '500000',
                        controller: _fundAllocatedController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: UzhavanTextField(
                        label: 'செலவான தொகை (₹)',
                        hint: '320000',
                        controller: _fundSpentController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                UzhavanButton(
                  label: 'நிதிப் பதிவேட்டை சேர்க்க',
                  icon: Icons.save,
                  isLoading: _isLoading,
                  onPressed: () => _postFundRecord(panchayat),
                ),
              ],
            ),
          ),

          // TAB 3: Grievance Resolution
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: panchayat.complaints.length,
            itemBuilder: (_, index) {
              final comp = panchayat.complaints[index];
              final responseCtrl = TextEditingController(text: comp.officialResponse ?? '');

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
                          Text(comp.categoryLabelTa, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(comp.status, style: const TextStyle(fontSize: 12, color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(comp.description, style: const TextStyle(fontSize: 15, height: 1.3)),
                      const SizedBox(height: 14),
                      TextField(
                        controller: responseCtrl,
                        decoration: const InputDecoration(
                          hintText: 'பஞ்சாயத்து அலுவலக பதில் உள்ளிடவும்...',
                          labelText: 'அதிகாரப்பூர்வ பதில்',
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 44),
                        ),
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          await panchayat.resolveComplaint(
                            complaintId: comp.id,
                            newStatus: 'action_taken',
                            officialResponse: responseCtrl.text.trim(),
                          );
                          if (mounted) {
                            messenger.showSnackBar(
                              const SnackBar(content: Text('பதில் பதிவு செய்யப்பட்டது!')),
                            );
                          }
                        },
                        child: const Text('நடவடிக்கை எடுத்ததாக பதிவு செய்'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
