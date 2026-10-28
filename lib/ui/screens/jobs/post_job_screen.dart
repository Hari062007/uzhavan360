import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
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
  final TextEditingController _descController = TextEditingController();
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
        SnackBar(
          content: Text(context.tr('post_job_success')),
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
        title: Text(context.tr('post_job_title')),
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
                Text(context.tr('work_type_label'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                      items: [
                        DropdownMenuItem(value: 'harvesting', child: Text(context.tr('harvesting_opt'))),
                        DropdownMenuItem(value: 'weeding', child: Text(context.tr('weeding_opt'))),
                        DropdownMenuItem(value: 'plowing', child: Text(context.tr('plowing_opt'))),
                        DropdownMenuItem(value: 'machinery', child: Text(context.tr('machinery_opt'))),
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
                  label: context.tr('job_title_ta_label'),
                  hint: context.tr('job_title_ta_hint'),
                  controller: _titleTaController,
                  validator: (v) => v!.isEmpty ? context.tr('job_title_required') : null,
                ),
                const SizedBox(height: 16),
                UzhavanTextField(
                  label: context.tr('job_title_en_label'),
                  hint: 'e.g. Paddy Harvesting',
                  controller: _titleEnController,
                ),
                const SizedBox(height: 18),

                // Date Picker
                Text(context.tr('work_date_label'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                        label: context.tr('daily_wage_label'),
                        hint: '650',
                        controller: _wageController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: UzhavanTextField(
                        label: context.tr('workers_count_label'),
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
                  label: context.tr('working_hours_label'),
                  hint: '7:30 AM - 1:30 PM',
                  controller: _hoursController,
                ),
                const SizedBox(height: 18),

                // Additional description
                UzhavanTextField(
                  label: context.tr('additional_notes_label'),
                  hint: context.tr('enter_notes_hint'),
                  controller: _descController,
                  maxLines: 2,
                ),
                const SizedBox(height: 28),

                UzhavanButton(
                  label: context.tr('publish_job_btn'),
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
