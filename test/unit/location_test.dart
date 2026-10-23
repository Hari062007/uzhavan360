import 'package:flutter_test/flutter_test.dart';
import 'package:uzhavan360/core/constants/tamil_nadu_locations.dart';
import 'package:uzhavan360/core/services/location_service.dart';

void main() {
  group('Tamil Nadu Location Hierarchy Tests', () {
    test('Contains Madurai, Thanjavur, Coimbatore, and Erode agricultural districts', () {
      final districts = TamilNaduLocations.data.map((d) => d.district).toList();
      expect(districts, containsAll(['Madurai', 'Thanjavur', 'Coimbatore', 'Erode']));
    });

    test('Vadipatti taluk contains Alangottaram village with pincode 625218', () {
      final madurai = TamilNaduLocations.data.firstWhere((d) => d.district == 'Madurai');
      final vadipatti = madurai.taluks.firstWhere((t) => t.taluk == 'Vadipatti');
      final alangottaram = vadipatti.villages.firstWhere((v) => v.name == 'Alangottaram');

      expect(alangottaram.nameTa, equals('ஆலங்கொட்டாரம்'));
      expect(alangottaram.pincode, equals('625218'));
    });

    test('LocationService matches village correctly by Tamil and English names', () {
      final match = LocationService.findVillage(
        district: 'மதுரை',
        taluk: 'வாடிப்பட்டி',
        villageName: 'ஆலங்கொட்டாரம்',
      );

      expect(match, isNotNull);
      expect(match!.name, equals('Alangottaram'));
    });
  });
}
