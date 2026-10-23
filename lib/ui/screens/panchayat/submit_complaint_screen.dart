import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../../state/panchayat_provider.dart';
import '../../common/uzhavan_button.dart';
import '../../common/uzhavan_text_field.dart';

class SubmitComplaintScreen extends StatefulWidget {
  const SubmitComplaintScreen({super.key});

  @override
  State<SubmitComplaintScreen> createState() => _SubmitComplaintScreenState();
}

class _SubmitComplaintScreenState extends State<SubmitComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  String _category = 'drinking_water';
  final TextEditingController _descController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, String>> _categories = [
    {'code': 'drinking_water', 'name': 'குடிநீர் விநியோக பிரச்சனை'},
    {'code': 'street_light', 'name': 'தெருவிளக்கு பழுது'},
    {'code': 'drainage', 'name': 'சாக்கடை / கழிவுநீர் வடிகால்'},
    {'code': 'road', 'name': 'சாலை சேதம் / பள்ளம்'},
    {'code': 'sanitation', 'name': 'தூய்மைப் பணி / குப்பை தேக்கம்'},
    {'code': 'agriculture', 'name': 'விவசாய பாசன வாய்க்கால் அடைப்பு'},
    {'code': 'other', 'name': 'பிற பொதுக் குறைபாடு'},
  ];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final panchayat = Provider.of<PanchayatProvider>(context, listen: false);

    final success = await panchayat.submitComplaint(
      category: _category,
      description: _descController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('உங்கள் புகார் ஊராட்சி மன்ற அலுவலகத்தில் பதிவு செய்யப்பட்டது!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final village = StorageService.getVillageTa();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('புதிய குறைபாடு பதிவு'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Privacy Protection Assurance Notice
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_outline, color: AppColors.primaryGreen, size: 22),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'உங்கள் பெயர் மற்றும் தொடர்பு விபரங்கள் பொதுவெளியில் காட்டப்படாது. பஞ்சாயத்து அதிகாரிகள் மட்டுமே பார்வையிட முடியும்.',
                          style: TextStyle(fontSize: 12, color: AppColors.primaryGreenDark, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Village Tag
                Text('கிராமம்: $village ஊராட்சி', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // Category Dropdown
                const Text('குறைபாட்டின் வகை', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWarmWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _category,
                      isExpanded: true,
                      items: _categories.map((c) {
                        return DropdownMenuItem(
                          value: c['code'],
                          child: Text(c['name']!, style: const TextStyle(fontSize: 15)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _category = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Description
                UzhavanTextField(
                  label: 'குறைபாட்டின் விரிவான விபரம் (இடம், பிரச்சனை)',
                  hint: 'எ.கா: கிழக்கு தெருவில் 3 நாட்களாக குடிநீர் குழாயில் உடைப்பு ஏற்பட்டுள்ளது.',
                  controller: _descController,
                  maxLines: 4,
                  validator: (v) => v!.isEmpty ? 'விபரம் உள்ளிடவும்' : null,
                ),
                const SizedBox(height: 28),

                UzhavanButton(
                  label: 'புகாரை சமர்ப்பிக்க',
                  icon: Icons.send_outlined,
                  isLoading: _isLoading,
                  onPressed: _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
