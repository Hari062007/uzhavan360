import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/connectivity_service.dart';

class AuthResult {
  final bool success;
  final String? errorMessageKey;
  final String? rawMessage;

  AuthResult({
    required this.success,
    this.errorMessageKey,
    this.rawMessage,
  });
}

class AuthRepository {
  /// Test-only hook for isolated unit test verification.
  /// Strictly false by default in production and runtime.
  static bool mockAuthForTesting = false;

  /// Request SMS OTP to the phone number via genuine Supabase Auth
  Future<AuthResult> sendPhoneOtp({
    required String countryCode,
    required String phoneNumber,
  }) async {
    final hasNet = await ConnectivityService.hasInternet();
    if (!hasNet) {
      return AuthResult(
        success: false,
        errorMessageKey: 'network_error',
        rawMessage: 'No internet connection available.',
      );
    }

    final fullPhone = '$countryCode$phoneNumber';

    if (mockAuthForTesting) {
      return AuthResult(success: true);
    }

    if (!SupabaseConfig.isConfigured) {
      return AuthResult(
        success: false,
        errorMessageKey: 'supabase_not_configured',
        rawMessage:
            'Supabase credentials are not configured. Please supply your Supabase project URL and Anon key in lib/core/config/supabase_config.dart or via environment variables.',
      );
    }

    try {
      await Supabase.instance.client.auth.signInWithOtp(
        phone: fullPhone,
        channel: OtpChannel.sms,
      );
      return AuthResult(success: true);
    } on AuthException catch (e) {
      return AuthResult(
        success: false,
        errorMessageKey: 'error_title',
        rawMessage: e.message,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessageKey: 'error_title',
        rawMessage: e.toString(),
      );
    }
  }

  /// Verify received 6-digit SMS OTP with genuine Supabase Auth
  Future<AuthResult> verifyOtp({
    required String countryCode,
    required String phoneNumber,
    required String token,
  }) async {
    final hasNet = await ConnectivityService.hasInternet();
    if (!hasNet) {
      return AuthResult(
        success: false,
        errorMessageKey: 'network_error',
        rawMessage: 'No internet connection available.',
      );
    }

    final fullPhone = '$countryCode$phoneNumber';

    if (mockAuthForTesting) {
      if (token == '123456') {
        await StorageService.setAuthenticated(true);
        await StorageService.setUserId('test-farmer-${phoneNumber.hashCode}');
        await StorageService.setPhoneNumber(fullPhone);
        return AuthResult(success: true);
      } else {
        return AuthResult(
          success: false,
          errorMessageKey: 'otp_invalid',
          rawMessage: 'The OTP is incorrect. Please try again.',
        );
      }
    }

    if (!SupabaseConfig.isConfigured) {
      return AuthResult(
        success: false,
        errorMessageKey: 'supabase_not_configured',
        rawMessage:
            'Supabase credentials are not configured. Please supply your Supabase project URL and Anon key in lib/core/config/supabase_config.dart.',
      );
    }

    try {
      final res = await Supabase.instance.client.auth.verifyOTP(
        phone: fullPhone,
        token: token,
        type: OtpType.sms,
      );

      if (res.session != null && res.user != null) {
        await StorageService.setAuthenticated(true);
        await StorageService.setUserId(res.user!.id);
        await StorageService.setPhoneNumber(fullPhone);
        return AuthResult(success: true);
      } else {
        return AuthResult(
          success: false,
          errorMessageKey: 'otp_invalid',
          rawMessage: 'The OTP is incorrect. Please try again.',
        );
      }
    } on AuthException catch (e) {
      return AuthResult(
        success: false,
        errorMessageKey: 'otp_invalid',
        rawMessage: e.message,
      );
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessageKey: 'error_title',
        rawMessage: e.toString(),
      );
    }
  }

  /// Sign out and clear stored session
  Future<void> signOut() async {
    if (SupabaseConfig.isConfigured) {
      try {
        await Supabase.instance.client.auth.signOut();
      } catch (_) {}
    }
    await StorageService.clearSession();
  }
}
