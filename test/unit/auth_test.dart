import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzhavan360/core/services/storage_service.dart';
import 'package:uzhavan360/core/services/connectivity_service.dart';
import 'package:uzhavan360/state/auth_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
    ConnectivityService.mockInternetAvailable = true;
  });

  group('Authentication Unit Tests', () {
    test('Phone number with less than 10 digits fails validation', () async {
      final authProvider = AuthProvider();
      authProvider.setPhoneNumber('98421');
      final result = await authProvider.requestOtp();

      expect(result, isFalse);
      expect(authProvider.errorMessage, equals('phone_invalid'));
    });

    test('Valid 10-digit phone number initiates OTP request', () async {
      final authProvider = AuthProvider();
      authProvider.setPhoneNumber('9842100001');
      final result = await authProvider.requestOtp();

      expect(result, isTrue);
      expect(authProvider.errorMessage, isNull);
      expect(authProvider.resendCountdown, equals(60));
    });

    test('Invalid OTP with incorrect length fails verification', () async {
      final authProvider = AuthProvider();
      authProvider.setPhoneNumber('9842100001');
      authProvider.setOtpCode('123'); // Invalid length (should be 6)
      final result = await authProvider.verifyOtp();

      expect(result, isFalse);
      expect(authProvider.errorMessage, equals('otp_invalid'));
    });

    test('Valid 6-digit OTP succeeds verification and persists authentication session', () async {
      final authProvider = AuthProvider();
      authProvider.setPhoneNumber('9842100001');
      authProvider.setOtpCode('123456');
      final result = await authProvider.verifyOtp();

      expect(result, isTrue);
      expect(StorageService.isAuthenticated(), isTrue);
      expect(StorageService.getPhoneNumber(), contains('9842100001'));
    });
  });
}
