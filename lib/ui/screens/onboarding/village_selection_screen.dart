import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/constants/tamil_nadu_locations.dart';
import '../../../state/profile_provider.dart';
import '../../common/uzhavan_button.dart';

class VillageSelectionScreen extends StatefulWidget {
  const VillageSelectionScreen({super.key});

  @override
  State<VillageSelectionScreen> createState() => _VillageSelectionScreenState();
}

class _VillageSelectionScreenState extends State<VillageSelectionScreen> {
  late LocationHierarchy _selectedDistrict;
  late TalukData _selectedTaluk;
  late VillageData _selectedVillage;

  @override
  void initState() {
    super.initState();
    _selectedDistrict = TamilNaduLocations.data.first;
    _selectedTaluk = _selectedDistrict.taluks.first;
    _selectedVillage = _selectedTaluk.villages.first;
  }

  void _confirmSelection() {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    profile.setLocation(
      district: _selectedDistrict.district,
      districtTa: _selectedDistrict.districtTa,
      taluk: _selectedTaluk.taluk,
      talukTa: _selectedTaluk.talukTa,
      village: _selectedVillage.name,
      villageTa: _selectedVillage.nameTa,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(context.tr('select_village_title')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // District Selector
              Text(
                context.tr('step_district'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarmWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<LocationHierarchy>(
                    value: _selectedDistrict,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryGreen),
                    items: TamilNaduLocations.data.map((d) {
                      final label = lang == 'ta' ? '${d.districtTa} (${d.district})' : '${d.district} (${d.districtTa})';
                      return DropdownMenuItem<LocationHierarchy>(
                        value: d,
                        child: Text(label, style: const TextStyle(fontSize: 16)),
                      );
                    }).toList(),
                    onChanged: (newDist) {
                      if (newDist != null) {
                        setState(() {
                          _selectedDistrict = newDist;
                          _selectedTaluk = newDist.taluks.first;
                          _selectedVillage = _selectedTaluk.villages.first;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Taluk Selector
              Text(
                context.tr('step_taluk'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarmWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<TalukData>(
                    value: _selectedTaluk,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryGreen),
                    items: _selectedDistrict.taluks.map((t) {
                      final label = lang == 'ta' ? '${t.talukTa} (${t.taluk})' : '${t.taluk} (${t.talukTa})';
                      return DropdownMenuItem<TalukData>(
                        value: t,
                        child: Text(label, style: const TextStyle(fontSize: 16)),
                      );
                    }).toList(),
                    onChanged: (newTaluk) {
                      if (newTaluk != null) {
                        setState(() {
                          _selectedTaluk = newTaluk;
                          _selectedVillage = newTaluk.villages.first;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Village List
              Text(
                context.tr('step_village'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _selectedTaluk.villages.length,
                  itemBuilder: (context, index) {
                    final village = _selectedTaluk.villages[index];
                    final isSelected = village.name == _selectedVillage.name;
                    final villageLabel = lang == 'ta'
                        ? '${village.nameTa} (${village.name})'
                        : '${village.name} (${village.nameTa})';

                    return Card(
                      elevation: isSelected ? 2 : 0,
                      color: isSelected ? AppColors.greenLightBg : AppColors.cardSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isSelected ? AppColors.primaryGreen : AppColors.borderSubtle,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: Icon(
                          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isSelected ? AppColors.primaryGreen : AppColors.textMuted,
                        ),
                        title: Text(
                          villageLabel,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? AppColors.primaryGreenDark : AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text('${context.tr('pincode_label')}${village.pincode}'),
                        onTap: () {
                          setState(() => _selectedVillage = village);
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              UzhavanButton(
                label: context.tr('confirm_village_btn'),
                icon: Icons.check,
                onPressed: _confirmSelection,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
