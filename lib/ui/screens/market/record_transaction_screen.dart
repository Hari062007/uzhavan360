import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
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
    _marketController.text = '$village ஒழுங்குமுறை கூடம்';
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
        const SnackBar(
          content: Text('உண்மையான விற்பனைப் பரிவர்த்தனை வெற்றிகரமாகப் பதிவு செய்யப்பட்டது!'),
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
        title: const Text('விற்பனைப் பரிவர்த்தனை பதிவு'),
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
                  child: const Row(
                    children: [
                      Icon(Icons.shield_outlined, color: AppColors.primaryGreen, size: 22),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'சந்தையில் நடைபெற்ற உண்மையான விற்பனை விலை விவரங்களை இங்கே பதிவு செய்யலாம்.',
                          style: TextStyle(fontSize: 13, color: AppColors.primaryGreenDark, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Crop Name
                UzhavanTextField(
                  label: 'விளைபொருள் பெயர்',
                  hint: 'எ.கா: பொன்னி நெல் / விரலி மஞ்சள்',
                  controller: _cropController,
                  validator: (v) => v!.isEmpty ? 'பயிர் பெயர் தேவை' : null,
                ),
                const SizedBox(height: 16),

                // Quality Grade
                const Text('விற்பனை செய்யப்பட்ட தரம்', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                      items: const [
                        DropdownMenuItem(value: 'grade_1', child: Text('முதல் தரம் (Grade 1 - Top Quality)')),
                        DropdownMenuItem(value: 'grade_2', child: Text('இரண்டாம் தரம் (Grade 2 - Medium)')),
                        DropdownMenuItem(value: 'grade_3', child: Text('மூன்றாம் தரம் (Grade 3 - Fair)')),
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
                        label: 'விற்பனை விலை (₹)',
                        hint: '2420',
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: UzhavanTextField(
                        label: 'அளவு (Quantity)',
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
                  label: 'விற்பனை நடைபெற்ற இடம் / மண்டி',
                  hint: 'ஒழுங்குமுறை விற்பனைக்கூடம்',
                  controller: _marketController,
                ),
                const SizedBox(height: 16),

                // Source
                const Text('விற்பனை வகை / ஆதாரம்', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                      items: const [
                        DropdownMenuItem(value: 'regulated_market', child: Text('ஒழுங்குமுறை கூடம் (Regulated Market)')),
                        DropdownMenuItem(value: 'trader_direct', child: Text('மண்டி / நேரடி கொள்முதல் (Trader Direct)')),
                        DropdownMenuItem(value: 'farmer_sale', child: Text('உழவர் நேரடி விற்பனை (Farmer Direct)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _source = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                UzhavanButton(
                  label: 'விற்பனை விலையைப் பதிவு செய்',
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
