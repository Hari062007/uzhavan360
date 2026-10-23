import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
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
  String _priceUnit = 'quintal'; // quintal or kg
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final village = StorageService.getVillage();
    final district = StorageService.getDistrict();
    _marketController.text = '$village ஒழுங்குமுறை விற்பனை கூடம் ($district)';
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
        const SnackBar(
          content: Text('வியாபாரி பயிர் விலைப்பட்டியல் வெற்றிகரமாகப் பதிவிடப்பட்டது!'),
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
        title: const Text('சந்தை விலை பதிவிடுதல்'),
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
                  label: 'பயிரின் பெயர் (தமிழ்)',
                  hint: 'எ.கா: பொன்னி நெல்',
                  controller: _cropTaController,
                  validator: (v) => v!.isEmpty ? 'பயிர் பெயர் தேவை' : null,
                ),
                const SizedBox(height: 16),
                UzhavanTextField(
                  label: 'Crop Name (English)',
                  hint: 'e.g. Ponni Paddy',
                  controller: _cropEnController,
                ),
                const SizedBox(height: 16),

                // Market
                UzhavanTextField(
                  label: 'மண்டி / ஒழுங்குமுறை கூடம் / கிராமம்',
                  hint: 'சந்தை இடம்',
                  controller: _marketController,
                ),
                const SizedBox(height: 16),

                // Price Unit
                const Text('விலை அலகு (Unit)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'quintal', label: Text('குவிண்டால் (Quintal)')),
                      ButtonSegment(value: 'kg', label: Text('கிலோ (Kg)')),
                    ],
                    selected: {_priceUnit},
                    onSelectionChanged: (val) => setState(() => _priceUnit = val.first),
                  ),
                ),
                const SizedBox(height: 16),

                // 3 Quality Grades
                const Text(
                  '3 தரநிலைகளின் விலை விவரம் (₹)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                UzhavanTextField(
                  label: 'முதல் தரம் (Grade 1 - உயர் தரம்)',
                  hint: 'விலை (₹)',
                  controller: _grade1Controller,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                UzhavanTextField(
                  label: 'இரண்டாம் தரம் (Grade 2 - நடுத்தரம்)',
                  hint: 'விலை (₹)',
                  controller: _grade2Controller,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                UzhavanTextField(
                  label: 'மூன்றாம் தரம் (Grade 3 - பொதுவான தரம்)',
                  hint: 'விலை (₹)',
                  controller: _grade3Controller,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Notes
                UzhavanTextField(
                  label: 'நிபந்தனைகள் / ஈரப்பதம் குறிப்பு',
                  hint: 'எ.கா: ஈரப்பதம் 17% க்குள் இருக்க வேண்டும்',
                  controller: _notesController,
                  maxLines: 2,
                ),
                const SizedBox(height: 28),

                UzhavanButton(
                  label: 'விலைப்பட்டியலை வெளியிடு',
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
