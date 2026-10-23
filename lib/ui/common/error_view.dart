import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'voice_speaker_button.dart';
import 'uzhavan_button.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded, color: AppColors.error, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VoiceSpeakerButton(textToSpeak: message),
                if (onRetry != null) ...[
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 140,
                    child: UzhavanButton(
                      label: 'மீண்டும் முயற்சி',
                      height: 46,
                      onPressed: onRetry,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
