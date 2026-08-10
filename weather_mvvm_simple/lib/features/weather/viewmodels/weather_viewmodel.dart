import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:weather_mvvm_simple/core/errors/exceptions.dart';
import 'package:weather_mvvm_simple/core/location/location_service.dart';
import 'package:weather_mvvm_simple/features/weather/data/models/city_model.dart';
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
  List<CityModel> suggestions = [];

  Timer? _debounce;
  int _searchId = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();

    if (query.trim().length < 3) {
      clearSuggestions();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () => _searchCities(query.trim()));
  }

  Future<void> selectCity(CityModel city) async {
    clearSuggestions();

    status = WeatherStatus.loading;
    error = null;
    notifyListeners();

    try {
      await _loadByCoords(city.latitude, city.longitude);
    } on NetworkException {
      _setError(const NetworkException());
    } on ServerException catch (e) {
      _setError(e);
    } catch (_) {
      _setError(const NetworkException());
    }
  }

  Future<void> loadCurrentLocation() async {
    clearSuggestions();

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

    clearSuggestions();

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

  void clearSuggestions() {
    _debounce?.cancel();
    _searchId++;
    if (suggestions.isEmpty) return;
    suggestions = [];
    notifyListeners();
  }

  Future<void> _searchCities(String query) async {
    final id = ++_searchId;
    try {
      final results = await _repository.searchCities(query);
      if (id != _searchId) return;
      suggestions = results;
    } catch (_) {
      if (id != _searchId) return;
      suggestions = [];
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
