import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:weather_mvvm_clean/core/errors/failures.dart';
import 'package:weather_mvvm_clean/features/weather/domain/entities/city.dart';
import 'package:weather_mvvm_clean/features/weather/domain/entities/coordinates.dart';
import 'package:weather_mvvm_clean/features/weather/domain/entities/forecast.dart';
import 'package:weather_mvvm_clean/features/weather/domain/entities/weather.dart';
import 'package:weather_mvvm_clean/features/weather/domain/entities/weather_report.dart';
import 'package:weather_mvvm_clean/features/weather/domain/usecases/get_current_location_weather.dart';
import 'package:weather_mvvm_clean/features/weather/domain/usecases/get_weather_by_city.dart';
import 'package:weather_mvvm_clean/features/weather/domain/usecases/get_weather_by_coords.dart';
import 'package:weather_mvvm_clean/features/weather/domain/usecases/search_cities.dart';

enum WeatherStatus { initial, loading, loaded, error }

class WeatherViewModel extends ChangeNotifier {
  final GetCurrentLocationWeather _getCurrentLocationWeather;
  final GetWeatherByCity _getWeatherByCity;
  final GetWeatherByCoords _getWeatherByCoords;
  final SearchCities _searchCities;

  WeatherViewModel({
    required GetCurrentLocationWeather getCurrentLocationWeather,
    required GetWeatherByCity getWeatherByCity,
    required GetWeatherByCoords getWeatherByCoords,
    required SearchCities searchCities,
  }) : _getCurrentLocationWeather = getCurrentLocationWeather,
       _getWeatherByCity = getWeatherByCity,
       _getWeatherByCoords = getWeatherByCoords,
       _searchCities = searchCities;

  WeatherStatus status = WeatherStatus.initial;
  Weather? weather;
  Forecast? forecast;
  Failure? failure;
  List<City> suggestions = [];

  Timer? _debounce;
  int _searchId = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> loadCurrentLocation() => _load(() => _getCurrentLocationWeather());

  Future<void> searchCity(String city) {
    if (city.trim().isEmpty) return Future.value();
    return _load(() => _getWeatherByCity(city.trim()));
  }

  Future<void> selectCity(double latitude, double longitude) {
    return _load(() => _getWeatherByCoords(Coordinates(latitude: latitude, longitude: longitude)));
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();

    if (query.trim().length < 3) {
      clearSuggestions();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () => _loadSuggestions(query.trim()));
  }

  void clearSuggestions() {
    _debounce?.cancel();
    _searchId++;
    if (suggestions.isEmpty) return;
    suggestions = [];
    notifyListeners();
  }

  Future<void> _load(Future<WeatherReport> Function() request) async {
    clearSuggestions();

    status = WeatherStatus.loading;
    failure = null;
    notifyListeners();

    try {
      final report = await request();
      weather = report.weather;
      forecast = report.forecast;
      status = WeatherStatus.loaded;
    } on Failure catch (e) {
      failure = e;
      status = WeatherStatus.error;
    }

    notifyListeners();
  }

  Future<void> _loadSuggestions(String query) async {
    final id = ++_searchId;

    try {
      final results = await _searchCities(query);
      if (id != _searchId) return;
      suggestions = results;
    } on Failure {
      if (id != _searchId) return;
      suggestions = [];
    }

    notifyListeners();
  }
}
