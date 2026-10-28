import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/services/storage_service.dart';
import '../../../state/crop_price_provider.dart';
import '../../common/uzhavan_button.dart';
import '../../common/uzhavan_text_field.dart';

class UploadCropPriceScreen extends StatefulWidget {
  const UploadCropPriceScreen({super.key});

  @override
  State<UploadCropPriceScreen> createState() => _UploadCropPriceScreenState();
}

class _UploadCropPriceScreenState extends State<UploadCropPriceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cropTaController = TextEditingController(text: 'நெல் (பொன்னி)');
  final TextEditingController _cropEnController = TextEditingController(text: 'Paddy (Ponni)');
  final TextEditingController _marketController = TextEditingController();
  final TextEditingController _grade1Controller = TextEditingController(text: '2450');
  final TextEditingController _grade2Controller = TextEditingController(text: '2200');
  final TextEditingController _grade3Controller = TextEditingController(text: '1950');
  final TextEditingController _notesController = TextEditingController();
  String _priceUnit = 'quintal';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final village = StorageService.getVillage();
    final district = StorageService.getDistrict();
    _marketController.text = '$village ($district)';
  }

  @override
  void dispose() {
    _cropTaController.dispose();
    _cropEnController.dispose();
    _marketController.dispose();
    _grade1Controller.dispose();
    _grade2Controller.dispose();
    _grade3Controller.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final cropProv = Provider.of<CropPriceProvider>(context, listen: false);

    final success = await cropProv.postTraderOffer(
      cropNameTa: _cropTaController.text.trim(),
      cropNameEn: _cropEnController.text.trim(),
      marketOrVillage: _marketController.text.trim(),
      priceUnit: _priceUnit,
      grade1Price: double.tryParse(_grade1Controller.text.trim()) ?? 0.0,
      grade2Price: double.tryParse(_grade2Controller.text.trim()) ?? 0.0,
      grade3Price: double.tryParse(_grade3Controller.text.trim()) ?? 0.0,
      notes: _notesController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('upload_success')),
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
        title: Text(context.tr('upload_crop_price_title')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Crop Name
                UzhavanTextField(
                  label: context.tr('crop_name_ta_label'),
                  hint: context.tr('crop_name_hint'),
                  controller: _cropTaController,
                  validator: (v) => v!.isEmpty ? context.tr('crop_name_required') : null,
                ),
                const SizedBox(height: 16),
                UzhavanTextField(
                  label: context.tr('crop_name_en_label'),
                  hint: 'e.g. Ponni Paddy',
                  controller: _cropEnController,
                ),
                const SizedBox(height: 16),

                // Market
                UzhavanTextField(
                  label: context.tr('market_location_label'),
                  hint: context.tr('market_location_hint'),
                  controller: _marketController,
                ),
                const SizedBox(height: 16),

                // Price Unit
                Text(context.tr('price_unit_label'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'quintal', label: Text(context.tr('unit_quintal'))),
                      ButtonSegment(value: 'kg', label: Text(context.tr('unit_kg'))),
                    ],
                    selected: {_priceUnit},
                    onSelectionChanged: (val) => setState(() => _priceUnit = val.first),
                  ),
                ),
                const SizedBox(height: 16),

                // 3 Quality Grades
                Text(
                  context.tr('three_tier_prices_label'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                UzhavanTextField(
                  label: context.tr('grade_1_label'),
                  hint: context.tr('price_hint'),
                  controller: _grade1Controller,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                UzhavanTextField(
                  label: context.tr('grade_2_label'),
                  hint: context.tr('price_hint'),
                  controller: _grade2Controller,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                UzhavanTextField(
                  label: context.tr('grade_3_label'),
                  hint: context.tr('price_hint'),
                  controller: _grade3Controller,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Notes
                UzhavanTextField(
                  label: context.tr('moisture_conditions_label'),
                  hint: context.tr('moisture_hint'),
                  controller: _notesController,
                  maxLines: 2,
                ),
                const SizedBox(height: 28),

                UzhavanButton(
                  label: context.tr('publish_prices_btn'),
                  icon: Icons.publish,
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
