import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _flutterTts = FlutterTts();

  static Future<void> init() async {
    await _flutterTts.setLanguage("tr-TR"); // Kürtçe TTS motoru olmayabilir, TR fallback
    // Eğer telefonda Kürtçe motor varsa "kmr" veya "ku" denenebilir
    // await _flutterTts.setLanguage("ku"); 
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5); // Öğrenme için yavaş
  }

  static Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }
}
