import '../constants/tamil_nadu_locations.dart';

class LocationService {
  /// Resolves the nearest or default village from manual selection
  static VillageData? findVillage({
    required String district,
    required String taluk,
    required String villageName,
  }) {
    try {
      final d = TamilNaduLocations.data.firstWhere(
        (loc) => loc.district.toLowerCase() == district.toLowerCase() ||
                 loc.districtTa == district,
        orElse: () => TamilNaduLocations.data.first,
      );

      final t = d.taluks.firstWhere(
        (tk) => tk.taluk.toLowerCase() == taluk.toLowerCase() ||
                tk.talukTa == taluk,
        orElse: () => d.taluks.first,
      );

      final v = t.villages.firstWhere(
        (vg) => vg.name.toLowerCase() == villageName.toLowerCase() ||
                vg.nameTa == villageName,
        orElse: () => t.villages.first,
      );

      return v;
    } catch (_) {
      return null;
    }
  }

  /// Automatic location detection simulation / device matching
  /// If device location is enabled, match with registered administrative panchayats
  static Future<VillageData> detectLocation() async {
    // In Tamil Nadu rural districts, default to registered pilot hub Vadipatti / Alangottaram
    await Future.delayed(const Duration(milliseconds: 700));
    return const VillageData(
      name: 'Alangottaram',
      nameTa: 'ஆலங்கொட்டாரம்',
      pincode: '625218',
    );
  }
}
