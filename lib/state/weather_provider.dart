import 'package:flutter/foundation.dart';
import '../data/models/weather_model.dart';
import '../data/repositories/weather_repository.dart';
import '../core/services/storage_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _repo = WeatherRepository();

  WeatherData? _weather;
  bool _isLoading = false;

  WeatherData? get weather => _weather;
  bool get isLoading => _isLoading;

  WeatherProvider() {
    loadWeather();
  }

  Future<void> loadWeather() async {
    _isLoading = true;
    notifyListeners();

    _weather = await _repo.fetchWeather(
      district: StorageService.getDistrict(),
      village: StorageService.getVillage(),
    );

    _isLoading = false;
    notifyListeners();
  }
}
