import 'package:weather_bloc/features/weather/domain/entities/daily_weather.dart';
import 'package:weather_bloc/features/weather/domain/entities/hourly_weather.dart';

class Forecast {
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  const Forecast({required this.hourly, required this.daily});
}
