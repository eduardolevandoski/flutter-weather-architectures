import 'package:weather_mvvm_clean/features/weather/domain/entities/daily_weather.dart';

class DailyModel {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String iconCode;

  const DailyModel({required this.date, required this.minTemp, required this.maxTemp, required this.iconCode});

  DailyWeather toEntity() => DailyWeather(date: date, minTemp: minTemp, maxTemp: maxTemp, iconCode: iconCode);
}
