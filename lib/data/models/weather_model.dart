class WeatherData {
  final String district;
  final String village;
  final double temperature;
  final String conditionTa;
  final String conditionEn;
  final int humidity;
  final double windSpeedKm;
  final int rainProbability;
  final String advisoryTa;
  final String advisoryEn;
  final DateTime lastUpdated;

  WeatherData({
    required this.district,
    required this.village,
    required this.temperature,
    required this.conditionTa,
    required this.conditionEn,
    required this.humidity,
    required this.windSpeedKm,
    required this.rainProbability,
    required this.advisoryTa,
    required this.advisoryEn,
    required this.lastUpdated,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      district: json['district'] as String? ?? 'Madurai',
      village: json['village'] as String? ?? 'Alangottaram',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 31.0,
      conditionTa: json['condition_ta'] as String? ?? 'மிதமான மேகமூட்டம்',
      conditionEn: json['condition_en'] as String? ?? 'Partly Cloudy',
      humidity: (json['humidity'] as num?)?.toInt() ?? 68,
      windSpeedKm: (json['wind_speed_km'] as num?)?.toDouble() ?? 14.5,
      rainProbability: (json['rain_probability'] as num?)?.toInt() ?? 25,
      advisoryTa: json['advisory_ta'] as String? ??
          'அடுத்த 48 மணி நேரத்திற்கு மிதமான காற்றுடன் கூடிய மழைக்கு வாய்ப்பு. அறுவடை செய்த தானியங்களை தார்ப்பாய் கொண்டு மூடவும்.',
      advisoryEn: json['advisory_en'] as String? ??
          'Moderate winds and rain chance in next 48 hrs. Protect harvested produce with tarpaulins.',
      lastUpdated: json['last_updated'] != null
          ? DateTime.tryParse(json['last_updated'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'district': district,
      'village': village,
      'temperature': temperature,
      'condition_ta': conditionTa,
      'condition_en': conditionEn,
      'humidity': humidity,
      'wind_speed_km': windSpeedKm,
      'rain_probability': rainProbability,
      'advisory_ta': advisoryTa,
      'advisory_en': advisoryEn,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}
