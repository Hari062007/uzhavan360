import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../../state/job_provider.dart';
import '../../common/uzhavan_button.dart';
import '../../common/uzhavan_text_field.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  String _workType = 'harvesting';
  final TextEditingController _titleTaController = TextEditingController(text: 'நெல் அறுவடை பணி');
  final TextEditingController _titleEnController = TextEditingController(text: 'Paddy Harvesting');
  final TextEditingController _wageController = TextEditingController(text: '650');
  final TextEditingController _workersController = TextEditingController(text: '6');
  final TextEditingController _hoursController = TextEditingController(text: '7:30 AM - 1:30 PM');
  final TextEditingController _descController = TextEditingController(text: 'மதிய உணவு மற்றும் டீ வழங்கப்படும்.');
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  bool _isLoading = false;

  @override
  void dispose() {
    _titleTaController.dispose();
    _titleEnController.dispose();
    _wageController.dispose();
    _workersController.dispose();
    _hoursController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final jobProv = Provider.of<JobProvider>(context, listen: false);
    final phone = StorageService.getPhoneNumber() ?? '+919842100000';

    final success = await jobProv.postJob(
      titleTa: _titleTaController.text.trim(),
      titleEn: _titleEnController.text.trim(),
      workType: _workType,
      workDate: _selectedDate,
      workingHours: _hoursController.text.trim(),
      workersRequired: int.tryParse(_workersController.text.trim()) ?? 1,
      wageAmount: double.tryParse(_wageController.text.trim()) ?? 500.0,
      wageBasis: 'daily',
      description: _descController.text.trim(),
      contactPhone: phone,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('வேலை தேவை அறிவிப்பு வெற்றிகரமாக வெளியிடப்பட்டது!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('வேலை தேவை பதிவிடுதல்'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Work Type Selection
                const Text('பணி வகை', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                      value: _workType,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'harvesting', child: Text('அறுவடை பணி (Harvesting)')),
                        DropdownMenuItem(value: 'weeding', child: Text('நடவு மற்றும் களையெடுத்தல் (Weeding)')),
                        DropdownMenuItem(value: 'plowing', child: Text('உழவு பணி (Plowing)')),
                        DropdownMenuItem(value: 'machinery', child: Text('இயந்திரம் / மரம் ஏறுதல் (Machinery)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _workType = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Title
                UzhavanTextField(
                  label: 'வேலை தலைப்பு (தமிழ்)',
                  hint: 'எ.கா: கரும்பு வெட்டும் பணி',
                  controller: _titleTaController,
                  validator: (v) => v!.isEmpty ? 'தலைப்பு தேவை' : null,
                ),
                const SizedBox(height: 18),

                // Date Picker
                const Text('வேலை நாள்', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 60)),
                    );
                    if (picked != null) setState(() => _selectedDate = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWarmWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.calendar_today, color: AppColors.primaryGreen, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Wage & Workers Row
                Row(
                  children: [
                    Expanded(
                      child: UzhavanTextField(
                        label: 'தினக்கூலி (₹)',
                        hint: '650',
                        controller: _wageController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: UzhavanTextField(
                        label: 'ஆட்கள் எண்ணிக்கை',
                        hint: '6',
                        controller: _workersController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Working Hours
                UzhavanTextField(
                  label: 'பணி நேரம்',
                  hint: '7:30 AM - 1:30 PM',
                  controller: _hoursController,
                ),
                const SizedBox(height: 18),

                // Additional description
                UzhavanTextField(
                  label: 'கூடுதல் குறிப்பு (மதிய உணவு, வசதிகள் போன்றவை)',
                  hint: 'குறிப்பு உள்ளிடவும்',
                  controller: _descController,
                  maxLines: 2,
                ),
                const SizedBox(height: 28),

                UzhavanButton(
                  label: 'வேலை தேவையை வெளியிடு',
                  icon: Icons.check,
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
