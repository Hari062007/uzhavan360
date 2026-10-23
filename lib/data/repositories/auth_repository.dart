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
  /// Request SMS OTP to the phone number via Supabase Auth
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

    if (SupabaseConfig.isConfigured) {
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
    } else {
      // Configuration notice: When Supabase project keys are unconfigured,
      // provide development simulation so UI & state flows remain testable.
      await Future.delayed(const Duration(milliseconds: 600));
      return AuthResult(success: true);
    }
  }

  /// Verify received 6-digit SMS OTP with Supabase Auth
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
      );
    }

    final fullPhone = '$countryCode$phoneNumber';

    if (SupabaseConfig.isConfigured) {
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
    } else {
      // Offline/Dev fallback: Accepts valid 6-digit OTP (e.g., '123456')
      await Future.delayed(const Duration(milliseconds: 600));
      if (token.length == 6) {
        await StorageService.setAuthenticated(true);
        await StorageService.setUserId('dev-farmer-${phoneNumber.hashCode}');
        await StorageService.setPhoneNumber(fullPhone);
        return AuthResult(success: true);
      } else {
        return AuthResult(
          success: false,
          errorMessageKey: 'otp_invalid',
        );
      }
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
