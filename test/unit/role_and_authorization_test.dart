import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzhavan360/core/services/storage_service.dart';
import 'package:uzhavan360/data/models/user_role.dart';
import 'package:uzhavan360/state/profile_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
  });

  group('Role Selection & Official Security Verification Tests (Requirements 15 & 21)', () {
    test('User selecting Panchayat Official role starts as unverified by default', () async {
      final profileProvider = ProfileProvider();
      profileProvider.setFullName('சுப்பிரமணியன்');
      profileProvider.setRole(AppRole.panchayatOfficial);

      await profileProvider.saveProfileSetup();

      expect(profileProvider.selectedRole, equals(AppRole.panchayatOfficial));
      expect(profileProvider.isOfficialVerified, isFalse);
      expect(StorageService.isOfficialVerified(), isFalse);
    });

    test('User cannot publish official records or claim verified status without audit approval', () async {
      final profileProvider = ProfileProvider();
      expect(profileProvider.isOfficialVerified, isFalse);

      // Simulating administrative verification approval
      await profileProvider.toggleOfficialVerification(true);
      expect(profileProvider.isOfficialVerified, isTrue);
      expect(StorageService.isOfficialVerified(), isTrue);
    });

    test('User can switch roles freely among permitted citizen roles', () async {
      final profileProvider = ProfileProvider();
      profileProvider.setRole(AppRole.worker);
      expect(profileProvider.selectedRole, equals(AppRole.worker));

      profileProvider.setRole(AppRole.workerLandowner);
      expect(profileProvider.selectedRole, equals(AppRole.workerLandowner));

      profileProvider.setRole(AppRole.landownerTrader);
      expect(profileProvider.selectedRole, equals(AppRole.landownerTrader));

      profileProvider.setRole(AppRole.trader);
      expect(profileProvider.selectedRole, equals(AppRole.trader));
    });
  });
}
