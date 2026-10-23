import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  FlutterTts? _flutterTts;
  bool _isSpeaking = false;
  bool _isInitialized = false;

  bool get isSpeaking => _isSpeaking;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      _flutterTts = FlutterTts();
      await _flutterTts?.setSpeechRate(0.48); // Slightly slower for elderly rural farmers
      await _flutterTts?.setVolume(1.0);
      await _flutterTts?.setPitch(1.0);

      _flutterTts?.setStartHandler(() {
        _isSpeaking = true;
      });

      _flutterTts?.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _flutterTts?.setCancelHandler(() {
        _isSpeaking = false;
      });

      _flutterTts?.setErrorHandler((msg) {
        _isSpeaking = false;
        debugPrint('TTS Error: $msg');
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing FlutterTts: $e');
    }
  }

  Future<void> speak(String text, {String language = 'ta'}) async {
    try {
      if (!_isInitialized) {
        await init();
      }

      if (_isSpeaking) {
        await stop();
        return;
      }

      if (_flutterTts == null) return;

      String langTag = language == 'ta' ? 'ta-IN' : 'en-IN';
      var isLangAvailable = await _flutterTts?.isLanguageAvailable(langTag);
      if (isLangAvailable != true) {
        // Fallback to generic language code if regional tag not found
        langTag = language == 'ta' ? 'ta' : 'en-US';
      }

      await _flutterTts?.setLanguage(langTag);
      _isSpeaking = true;
      await _flutterTts?.speak(text);
    } catch (e) {
      _isSpeaking = false;
      debugPrint('TTS speak failed: $e');
    }
  }

  Future<void> stop() async {
    try {
      if (_flutterTts != null) {
        await _flutterTts?.stop();
        _isSpeaking = false;
      }
    } catch (e) {
      debugPrint('TTS stop failed: $e');
    }
  }
}
