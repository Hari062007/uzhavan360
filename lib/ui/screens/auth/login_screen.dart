import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../state/auth_provider.dart';
import '../../common/uzhavan_button.dart';
import '../../common/uzhavan_text_field.dart';
import '../../common/voice_speaker_button.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  final List<Map<String, String>> _countries = [
    {'name': 'இந்தியா (India)', 'code': '+91'},
    {'name': 'மலேசியா (Malaysia)', 'code': '+60'},
    {'name': 'சிங்கப்பூர் (Singapore)', 'code': '+65'},
    {'name': 'இலங்கை (Sri Lanka)', 'code': '+94'},
    {'name': 'ஐக்கிய அரபு அமீரகம் (UAE)', 'code': '+971'},
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleGetOtp(AuthProvider auth) async {
    FocusScope.of(context).unfocus();
    auth.setPhoneNumber(_phoneController.text);
    final success = await auth.requestOtp();
    if (success && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OtpVerificationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('UZHAVAN360'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: VoiceSpeakerButton(textToSpeak: 'வணக்கம்! உங்கள் மொபைல் எண்ணை உள்ளிட்டு OTP பெறவும்.'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              // Official Emblem with traditional farmer & modern agricultural drone
              Center(
                child: Container(
                  width: 140,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withValues(alpha: 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/uzhavan360_logo.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.tr('login_title'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                context.tr('login_subtitle'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),

              // Country Dropdown
              Text(
                context.tr('country_label'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarmWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle, width: 1.5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: auth.selectedCountryCode,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryGreen),
                    items: _countries.map((c) {
                      return DropdownMenuItem<String>(
                        value: c['code'],
                        child: Text(
                          '${c['name']} (${c['code']})',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) auth.setCountryCode(val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Phone Number Field
              UzhavanTextField(
                label: context.tr('phone_label'),
                hint: context.tr('phone_placeholder'),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefix: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  child: Text(
                    auth.selectedCountryCode,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ),

              if (auth.errorMessage != null) ...[
                const SizedBox(height: 14),
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
                            fontSize: 14,
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

              const SizedBox(height: 28),

              // Large Green Get OTP Button
              UzhavanButton(
                label: context.tr('get_otp_btn'),
                icon: Icons.sms_outlined,
                isLoading: auth.isLoading,
                onPressed: () => _handleGetOtp(auth),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
