import 'package:flutter/foundation.dart';
import 'package:weather_mvvm_simple/core/errors/exceptions.dart';
import 'package:weather_mvvm_simple/core/location/location_service.dart';
import 'package:weather_mvvm_simple/features/weather/data/models/forecast_model.dart';
import 'package:weather_mvvm_simple/features/weather/data/models/weather_model.dart';
import 'package:weather_mvvm_simple/features/weather/data/weather_repository.dart';

enum WeatherStatus { initial, loading, loaded, error }

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _repository;
  final LocationService _locationService;

  WeatherViewModel(this._repository, this._locationService) {
    loadCurrentLocation();
  }

  WeatherStatus status = WeatherStatus.initial;
  WeatherModel? weather;
  ForecastModel? forecast;
  Exception? error;

  Future<void> loadCurrentLocation() async {
    status = WeatherStatus.loading;
    error = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentPosition();
      await _loadByCoords(position.latitude, position.longitude);
    } on LocationDisabledException {
      _setError(const LocationDisabledException());
    } on LocationPermissionDeniedException {
      _setError(const LocationPermissionDeniedException());
    } catch (_) {
      _setError(const NetworkException());
    }
  }

  Future<void> searchCity(String city) async {
    if (city.trim().isEmpty) return;

    status = WeatherStatus.loading;
    error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getWeatherByCity(city.trim()),
        _repository.getForecastByCity(city.trim()),
      ]);

      weather = results[0] as WeatherModel;
      forecast = results[1] as ForecastModel;
      status = WeatherStatus.loaded;
    } on CityNotFoundException {
      _setError(const CityNotFoundException());
    } on InvalidApiKeyException {
      _setError(const InvalidApiKeyException());
    } on NetworkException {
      _setError(const NetworkException());
    } on ServerException catch (e) {
      _setError(e);
    } catch (_) {
      _setError(const NetworkException());
    }

    notifyListeners();
  }

  Future<void> _loadByCoords(double lat, double lon) async {
    final results = await Future.wait([_repository.getWeatherByCoords(lat, lon), _repository.getForecastByCoords(lat, lon)]);

    weather = results[0] as WeatherModel;
    forecast = results[1] as ForecastModel;
    status = WeatherStatus.loaded;
    notifyListeners();
  }

  void _setError(Exception e) {
    error = e;
    status = WeatherStatus.error;
    notifyListeners();
  }
}
