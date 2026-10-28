import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/services/storage_service.dart';
import '../../../state/auth_provider.dart';
import '../../common/uzhavan_button.dart';
import '../../common/uzhavan_text_field.dart';
import '../../common/voice_speaker_button.dart';
import '../onboarding/profile_setup_screen.dart';
import '../dashboard/main_dashboard_shell.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerify(AuthProvider auth) async {
    FocusScope.of(context).unfocus();
    auth.setOtpCode(_otpController.text);
    final success = await auth.verifyOtp();
    if (success && mounted) {
      final isProfileDone = StorageService.isProfileComplete();
      Widget destination = isProfileDone
          ? const MainDashboardShell()
          : const ProfileSetupScreen();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => destination),
        (route) => false,
      );
    }
  }

  String _maskPhone(String phone) {
    if (phone.length <= 4) return phone;
    final start = phone.substring(0, 3);
    final end = phone.substring(phone.length - 2);
    return '$start ••••• $end';
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(context.tr('otp_title')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: VoiceSpeakerButton(
              textToSpeak: context.tr('otp_voice_instruction'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.greenLightBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mark_email_read_outlined,
                    color: AppColors.primaryGreen,
                    size: 52,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                context.tr('enter_otp'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr('otp_sent_to'),
                    style: const TextStyle(fontSize: 15, color: AppColors.textMuted),
                  ),
                  Text(
                    '${auth.selectedCountryCode} ${_maskPhone(auth.phoneNumber)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 6-digit OTP Input
              UzhavanTextField(
                label: context.tr('otp_label'),
                hint: context.tr('otp_hint'),
                controller: _otpController,
                keyboardType: TextInputType.number,
                prefix: const Icon(Icons.lock_clock_outlined, color: AppColors.primaryGreen),
              ),

              // Error display
              if (auth.errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          context.tr(auth.errorMessage!),
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      VoiceSpeakerButton(
                        textToSpeak: context.tr(auth.errorMessage!),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Resend Countdown
              Center(
                child: auth.canResend
                    ? TextButton.icon(
                        icon: const Icon(Icons.refresh, color: AppColors.primaryGreen),
                        label: Text(
                          context.tr('resend_otp'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        onPressed: () => auth.requestOtp(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.timer_outlined, size: 18, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Text(
                            '${context.tr('resend_in')}${auth.resendCountdown}${context.tr('seconds')}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 28),

              UzhavanButton(
                label: context.tr('verify_otp_btn'),
                icon: Icons.check_circle_outline,
                isLoading: auth.isLoading,
                onPressed: () => _handleVerify(auth),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
