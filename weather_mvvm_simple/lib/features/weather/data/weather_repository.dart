import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_mvvm_simple/core/network/api_config.dart';
import 'package:weather_mvvm_simple/features/weather/data/weather_model.dart';

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

    final response = await _client.get(uri);

    return switch (response.statusCode) {
      200 => WeatherModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>),
      404 => throw Exception('City "$city" not found.'),
      401 => throw Exception('Invalid API key. Check your .env file.'),
      _ => throw Exception('Server error (${response.statusCode}).'),
    };
  }
}
