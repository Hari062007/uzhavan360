import '../models/weather_model.dart';

class WeatherRepository {
  Future<WeatherData> fetchWeather({required String district, required String village}) async {
    // Returns realistic meteorological agro-advisory for Tamil Nadu agricultural hubs
    return WeatherData(
      district: district,
      village: village,
      temperature: 32.5,
      conditionTa: 'தெளிவான வானம் மற்றும் மிதமான வெயில்',
      conditionEn: 'Clear Sky & Moderate Sunshine',
      humidity: 62,
      windSpeedKm: 12.0,
      rainProbability: 15,
      advisoryTa: 'பயிர்களுக்கு நீர்ப்பாசனம் செய்ய உகந்த சூழல். நெல் மற்றும் கரும்பு பயிர்களுக்கு தேவையான உரமிடுதலை மேற்கொள்ளலாம்.',
      advisoryEn: 'Favorable conditions for crop irrigation. Recommended timing for top dressing fertilizers in paddy and sugarcane.',
      lastUpdated: DateTime.now(),
    );
  }
}
