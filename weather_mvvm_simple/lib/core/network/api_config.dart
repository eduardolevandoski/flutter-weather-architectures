import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ApiConfig {
  static String get baseUrl => 'https://api.openweathermap.org/data/2.5';

  static String get geoBaseUrl => 'https://api.openweathermap.org/geo/1.0';

  static String get apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';
}
