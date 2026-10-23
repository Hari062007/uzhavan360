import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/repositories/auth_repository.dart';
import '../core/services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();

  String _selectedCountryCode = '+91';
  String _phoneNumber = '';
  String _otpCode = '';
  bool _isLoading = false;
  String? _errorMessage;
  int _resendCountdown = 0;
  Timer? _countdownTimer;

  String get selectedCountryCode => _selectedCountryCode;
  String get phoneNumber => _phoneNumber;
  String get otpCode => _otpCode;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get resendCountdown => _resendCountdown;
  bool get canResend => _resendCountdown == 0;

  bool get isAuthenticated => StorageService.isAuthenticated();
  bool get isProfileComplete => StorageService.isProfileComplete();

  void setCountryCode(String code) {
    _selectedCountryCode = code;
    notifyListeners();
  }

  void setPhoneNumber(String phone) {
    _phoneNumber = phone.trim();
    _errorMessage = null;
    notifyListeners();
  }

  void setOtpCode(String otp) {
    _otpCode = otp.trim();
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Request SMS OTP
  Future<bool> requestOtp() async {
    if (_phoneNumber.length < 10) {
      _errorMessage = 'phone_invalid';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepo.sendPhoneOtp(
      countryCode: _selectedCountryCode,
      phoneNumber: _phoneNumber,
    );

    _isLoading = false;

    if (result.success) {
      _startResendTimer();
      notifyListeners();
      return true;
    } else {
      _errorMessage = result.errorMessageKey ?? result.rawMessage ?? 'error_title';
      notifyListeners();
      return false;
    }
  }

  /// Verify received 6-digit OTP
  Future<bool> verifyOtp() async {
    if (_otpCode.length != 6) {
      _errorMessage = 'otp_invalid';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepo.verifyOtp(
      countryCode: _selectedCountryCode,
      phoneNumber: _phoneNumber,
      token: _otpCode,
    );

    _isLoading = false;

    if (result.success) {
      _countdownTimer?.cancel();
      notifyListeners();
      return true;
    } else {
      _errorMessage = result.errorMessageKey ?? 'otp_invalid';
      notifyListeners();
      return false;
    }
  }

  void _startResendTimer() {
    _countdownTimer?.cancel();
    _resendCountdown = 60;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        _resendCountdown--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> logout() async {
    await _authRepo.signOut();
    _phoneNumber = '';
    _otpCode = '';
    _countdownTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
