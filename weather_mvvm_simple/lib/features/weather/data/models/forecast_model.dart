import 'package:weather_mvvm_simple/features/weather/data/models/daily_model.dart';
import 'package:weather_mvvm_simple/features/weather/data/models/hourly_model.dart';

class ForecastModel {
  final List<HourlyModel> hourly;
  final List<DailyModel> daily;

  const ForecastModel({required this.hourly, required this.daily});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final forecasts = json['list'] as List<dynamic>;

    final hourly = forecasts.take(8).map((forecast) => HourlyModel.fromJson(forecast as Map<String, dynamic>)).toList();

    final daily = _groupForecastsByDay(forecasts).values.map(_dailyModelFromForecasts).toList();

    return ForecastModel(hourly: hourly, daily: daily);
  }

  static Map<String, List<Map<String, dynamic>>> _groupForecastsByDay(List<dynamic> forecasts) {
    final Map<String, List<Map<String, dynamic>>> byDay = {};

    for (final item in forecasts) {
      final forecast = item as Map<String, dynamic>;
      final date = _dateFromForecast(forecast);
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      byDay.putIfAbsent(key, () => []).add(forecast);
    }

    return byDay;
  }

  static DailyModel _dailyModelFromForecasts(List<Map<String, dynamic>> forecasts) {
    final temps = forecasts.map((forecast) => (forecast['main']['temp'] as num).toDouble()).toList();

    final middayForecast = forecasts.firstWhere((forecast) {
      final hour = _dateFromForecast(forecast).hour;
      return hour >= 11 && hour <= 14;
    }, orElse: () => forecasts.first);

    return DailyModel(
      date: _dateFromForecast(forecasts.first),
      minTemp: temps.reduce((a, b) => a < b ? a : b),
      maxTemp: temps.reduce((a, b) => a > b ? a : b),
      iconCode: middayForecast['weather'][0]['icon'] as String,
    );
  }

  static DateTime _dateFromForecast(Map<String, dynamic> forecast) {
    return DateTime.fromMillisecondsSinceEpoch((forecast['dt'] as int) * 1000);
  }
}
