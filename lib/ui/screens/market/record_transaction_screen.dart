import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/services/storage_service.dart';
import '../../../state/crop_price_provider.dart';
import '../../common/uzhavan_button.dart';
import '../../common/uzhavan_text_field.dart';

class RecordTransactionScreen extends StatefulWidget {
  const RecordTransactionScreen({super.key});

  @override
  State<RecordTransactionScreen> createState() => _RecordTransactionScreenState();
}

class _RecordTransactionScreenState extends State<RecordTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cropController = TextEditingController(text: 'நெல் (பொன்னி)');
  final TextEditingController _priceController = TextEditingController(text: '2420');
  final TextEditingController _quantityController = TextEditingController(text: '40');
  final TextEditingController _marketController = TextEditingController();
  String _qualityGrade = 'grade_1';
  final String _priceUnit = 'quintal';
  String _source = 'regulated_market';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final village = StorageService.getVillage();
    _marketController.text = village;
  }

  @override
  void dispose() {
    _cropController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _marketController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final cropProv = Provider.of<CropPriceProvider>(context, listen: false);

    final success = await cropProv.recordTransaction(
      cropName: _cropController.text.trim(),
      qualityGrade: _qualityGrade,
      transactionPrice: double.tryParse(_priceController.text.trim()) ?? 0.0,
      priceUnit: _priceUnit,
      quantitySold: double.tryParse(_quantityController.text.trim()) ?? 1.0,
      marketOrVillage: _marketController.text.trim(),
      source: _source,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('record_success')),
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
        title: Text(context.tr('record_transaction_title')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info banner on verification
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined, color: AppColors.primaryGreen, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          context.tr('record_banner_text'),
                          style: const TextStyle(fontSize: 13, color: AppColors.primaryGreenDark, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Crop Name
                UzhavanTextField(
                  label: context.tr('crop_name_label'),
                  hint: context.tr('crop_record_hint'),
                  controller: _cropController,
                  validator: (v) => v!.isEmpty ? context.tr('crop_name_required') : null,
                ),
                const SizedBox(height: 16),

                // Quality Grade
                Text(context.tr('sold_grade_label'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                      value: _qualityGrade,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(value: 'grade_1', child: Text(context.tr('grade_1_label'))),
                        DropdownMenuItem(value: 'grade_2', child: Text(context.tr('grade_2_label'))),
                        DropdownMenuItem(value: 'grade_3', child: Text(context.tr('grade_3_label'))),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _qualityGrade = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Price and Quantity
                Row(
                  children: [
                    Expanded(
                      child: UzhavanTextField(
                        label: context.tr('sale_price_label'),
                        hint: '2420',
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: UzhavanTextField(
                        label: context.tr('quantity_label'),
                        hint: '40',
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Market / Location
                UzhavanTextField(
                  label: context.tr('sale_location_label'),
                  hint: context.tr('market_location_hint'),
                  controller: _marketController,
                ),
                const SizedBox(height: 16),

                // Source
                Text(context.tr('sale_source_label'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                      value: _source,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(value: 'regulated_market', child: Text(context.tr('source_regulated'))),
                        DropdownMenuItem(value: 'trader_direct', child: Text(context.tr('source_trader'))),
                        DropdownMenuItem(value: 'farmer_sale', child: Text(context.tr('source_farmer'))),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _source = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                UzhavanButton(
                  label: context.tr('record_submit_btn'),
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
