import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/services/tts_service.dart';
import '../../core/theme/app_colors.dart';
import '../../state/locale_provider.dart';

class VoiceSpeakerButton extends StatefulWidget {
  final String textToSpeak;
  final String? tooltip;
  final double size;

  const VoiceSpeakerButton({
    super.key,
    required this.textToSpeak,
    this.tooltip,
    this.size = 28.0,
  });

  @override
  State<VoiceSpeakerButton> createState() => _VoiceSpeakerButtonState();
}

class _VoiceSpeakerButtonState extends State<VoiceSpeakerButton> {
  final TtsService _tts = TtsService();
  bool _speaking = false;

  void _toggleSpeak(BuildContext context) async {
    final lang = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;
    if (_speaking) {
      await _tts.stop();
      if (mounted) setState(() => _speaking = false);
    } else {
      if (mounted) setState(() => _speaking = true);
      await _tts.speak(widget.textToSpeak, language: lang);
      if (mounted) {
        setState(() => _speaking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _speaking ? AppColors.accentGold.withValues(alpha: 0.2) : AppColors.greenLightBg,
        shape: BoxShape.circle,
        border: Border.all(
          color: _speaking ? AppColors.accentGold : AppColors.primaryGreen.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: IconButton(
        iconSize: widget.size,
        padding: const EdgeInsets.all(8),
        icon: Icon(
          _speaking ? Icons.volume_up : Icons.volume_up_outlined,
          color: _speaking ? AppColors.accentGold : AppColors.primaryGreen,
        ),
        tooltip: widget.tooltip ?? context.tr('voice_help_tooltip'),
        onPressed: () => _toggleSpeak(context),
      ),
    );
  }
}
