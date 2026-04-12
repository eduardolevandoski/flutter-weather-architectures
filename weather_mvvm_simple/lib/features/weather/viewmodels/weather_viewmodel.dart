import 'package:flutter/foundation.dart';
import 'package:weather_mvvm_simple/features/weather/data/weather_model.dart';
import 'package:weather_mvvm_simple/features/weather/data/weather_repository.dart';

enum WeatherStatus { initial, loading, loaded, error }

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _repository;

  WeatherViewModel(this._repository);

  WeatherStatus status = WeatherStatus.initial;
  WeatherModel? weather;

  Future<void> searchCity(String city) async {
    if (city.trim().isEmpty) return;

    status = WeatherStatus.loading;
    notifyListeners();

    try {
      weather = await _repository.getWeatherByCity(city.trim());
      status = WeatherStatus.loaded;
    } catch (e) {
      status = WeatherStatus.error;
    }

    notifyListeners();
  }
}