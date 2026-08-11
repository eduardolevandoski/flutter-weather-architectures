import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:weather_mvvm_clean/core/errors/exceptions.dart';
import 'package:weather_mvvm_clean/core/network/api_config.dart';
import 'package:weather_mvvm_clean/features/weather/data/datasources/i_weather_remote_datasource.dart';
import 'package:weather_mvvm_clean/features/weather/data/models/city_model.dart';
import 'package:weather_mvvm_clean/features/weather/data/models/forecast_model.dart';
import 'package:weather_mvvm_clean/features/weather/data/models/weather_model.dart';

/// Handles all the OpenWeatherMap calls.
/// Every endpoint needs the key as `appid`.
///
/// https://openweathermap.org/api
class WeatherRemoteDataSource implements IWeatherRemoteDataSource {
  final http.Client _client;

  const WeatherRemoteDataSource(this._client);

  /// Searches city names and gives back up to 5 matches with coords.
  /// This is what fills the search suggestions.
  ///
  /// https://openweathermap.org/api/geocoding-api
  @override
  Future<List<CityModel>> searchCities(String query) {
    final uri = Uri.parse(
      '${ApiConfig.geoBaseUrl}/direct'
      '?q=${Uri.encodeComponent(query)}'
      '&limit=5'
      '&appid=${ApiConfig.apiKey}',
    );

    return _get(uri, (json) {
      return (json as List<dynamic>).map((city) => CityModel.fromJson(city as Map<String, dynamic>)).toList();
    });
  }

  /// Current weather by city name.
  /// If two cities share a name the API just picks one, so we use
  /// coords whenever we have them.
  ///
  /// https://openweathermap.org/current
  @override
  Future<WeatherModel> getWeatherByCity(String city) {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/weather'
      '?q=${Uri.encodeComponent(city)}'
      '&appid=${ApiConfig.apiKey}'
      '&units=metric',
    );

    return _get(uri, (json) => WeatherModel.fromJson(json as Map<String, dynamic>));
  }

  /// Current weather by coords. Used for the device location and
  /// for whatever city the user taps in the suggestions.
  ///
  /// https://openweathermap.org/current
  @override
  Future<WeatherModel> getWeatherByCoords(double lat, double lon) {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/weather'
      '?lat=$lat&lon=$lon'
      '&appid=${ApiConfig.apiKey}'
      '&units=metric',
    );

    return _get(uri, (json) => WeatherModel.fromJson(json as Map<String, dynamic>));
  }

  /// 5 day forecast by city name, one entry every 3 hours.
  ///
  /// https://openweathermap.org/forecast5
  @override
  Future<ForecastModel> getForecastByCity(String city) {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/forecast'
      '?q=${Uri.encodeComponent(city)}'
      '&appid=${ApiConfig.apiKey}'
      '&units=metric',
    );

    return _get(uri, (json) => ForecastModel.fromJson(json as Map<String, dynamic>));
  }

  /// 5 day forecast by coords, one entry every 3 hours.
  ///
  /// https://openweathermap.org/forecast5
  @override
  Future<ForecastModel> getForecastByCoords(double lat, double lon) {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/forecast'
      '?lat=$lat&lon=$lon'
      '&appid=${ApiConfig.apiKey}'
      '&units=metric',
    );

    return _get(uri, (json) => ForecastModel.fromJson(json as Map<String, dynamic>));
  }

  Future<T> _get<T>(Uri uri, T Function(dynamic json) parse) async {
    final http.Response response;

    try {
      response = await _client.get(uri);
    } on http.ClientException {
      throw const NetworkException();
    } on SocketException {
      throw const NetworkException();
    }

    return switch (response.statusCode) {
      200 => parse(jsonDecode(response.body)),
      404 => throw const CityNotFoundException(),
      401 => throw const InvalidApiKeyException(),
      _ => throw ServerException(response.statusCode),
    };
  }
}
