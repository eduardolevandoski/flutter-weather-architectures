import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_mvvm_simple/core/errors/exceptions.dart';
import 'package:weather_mvvm_simple/core/network/api_config.dart';
import 'package:weather_mvvm_simple/features/weather/data/models/city_model.dart';
import 'package:weather_mvvm_simple/features/weather/data/models/forecast_model.dart';
import 'package:weather_mvvm_simple/features/weather/data/models/weather_model.dart';

/// Handles all the OpenWeatherMap calls.
/// Every endpoint needs the key as `appid`.
///
/// https://openweathermap.org/api
class WeatherRepository {
  final http.Client _client;

  const WeatherRepository(this._client);

  /// Searches city names and gives back up to 5 matches with coords.
  /// This is what fills the search suggestions.
  ///
  /// https://openweathermap.org/api/geocoding-api
  Future<List<CityModel>> searchCities(String query) async {
    final uri = Uri.parse(
      '${ApiConfig.geoBaseUrl}/direct'
      '?q=${Uri.encodeComponent(query)}'
      '&limit=5'
      '&appid=${ApiConfig.apiKey}',
    );

    try {
      final response = await _client.get(uri);
      return switch (response.statusCode) {
        200 =>
          (jsonDecode(response.body) as List<dynamic>)
              .map((city) => CityModel.fromJson(city as Map<String, dynamic>))
              .toList(),
        401 => throw const InvalidApiKeyException(),
        _ => throw ServerException(response.statusCode),
      };
    } on InvalidApiKeyException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (_) {
      throw const NetworkException();
    }
  }

  /// Current weather by city name.
  /// If two cities share a name the API just picks one, so we use
  /// coords whenever we have them.
  ///
  /// https://openweathermap.org/current
  Future<WeatherModel> getWeatherByCity(String city) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/weather'
      '?q=${Uri.encodeComponent(city)}'
      '&appid=${ApiConfig.apiKey}'
      '&units=metric',
    );
    return _fetchWeather(uri);
  }

  /// Current weather by coords. Used for the device location and
  /// for whatever city the user taps in the suggestions.
  ///
  /// https://openweathermap.org/current
  Future<WeatherModel> getWeatherByCoords(double lat, double lon) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/weather'
      '?lat=$lat&lon=$lon'
      '&appid=${ApiConfig.apiKey}'
      '&units=metric',
    );
    return _fetchWeather(uri);
  }

  /// 5 day forecast by city name, one entry every 3 hours.
  ///
  /// https://openweathermap.org/forecast5
  Future<ForecastModel> getForecastByCity(String city) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/forecast'
      '?q=${Uri.encodeComponent(city)}'
      '&appid=${ApiConfig.apiKey}'
      '&units=metric',
    );
    return _fetchForecast(uri);
  }

  /// 5 day forecast by coords, one entry every 3 hours.
  ///
  /// https://openweathermap.org/forecast5
  Future<ForecastModel> getForecastByCoords(double lat, double lon) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/forecast'
      '?lat=$lat&lon=$lon'
      '&appid=${ApiConfig.apiKey}'
      '&units=metric',
    );
    return _fetchForecast(uri);
  }

  Future<WeatherModel> _fetchWeather(Uri uri) async {
    try {
      final response = await _client.get(uri);
      return switch (response.statusCode) {
        200 => WeatherModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>),
        404 => throw const CityNotFoundException(),
        401 => throw const InvalidApiKeyException(),
        _ => throw ServerException(response.statusCode),
      };
    } on CityNotFoundException {
      rethrow;
    } on InvalidApiKeyException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (_) {
      throw const NetworkException();
    }
  }

  Future<ForecastModel> _fetchForecast(Uri uri) async {
    try {
      final response = await _client.get(uri);
      return switch (response.statusCode) {
        200 => ForecastModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>),
        404 => throw const CityNotFoundException(),
        401 => throw const InvalidApiKeyException(),
        _ => throw ServerException(response.statusCode),
      };
    } on CityNotFoundException {
      rethrow;
    } on InvalidApiKeyException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (_) {
      throw const NetworkException();
    }
  }
}
