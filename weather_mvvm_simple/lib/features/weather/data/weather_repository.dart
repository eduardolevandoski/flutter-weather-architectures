import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_mvvm_simple/core/errors/exceptions.dart';
import 'package:weather_mvvm_simple/core/network/api_config.dart';
import 'package:weather_mvvm_simple/features/weather/data/models/forecast_model.dart';
import 'package:weather_mvvm_simple/features/weather/data/models/weather_model.dart';

class WeatherRepository {
  final http.Client _client;

  const WeatherRepository(this._client);

  Future<WeatherModel> getWeatherByCity(String city) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/weather'
      '?q=$city'
      '&appid=${ApiConfig.apiKey}'
      '&units=metric',
    );
    return _fetchWeather(uri);
  }

  Future<WeatherModel> getWeatherByCoords(double lat, double lon) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/weather'
      '?lat=$lat&lon=$lon'
      '&appid=${ApiConfig.apiKey}'
      '&units=metric',
    );
    return _fetchWeather(uri);
  }

  Future<ForecastModel> getForecastByCity(String city) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/forecast'
      '?q=$city'
      '&appid=${ApiConfig.apiKey}'
      '&units=metric',
    );
    return _fetchForecast(uri);
  }

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
