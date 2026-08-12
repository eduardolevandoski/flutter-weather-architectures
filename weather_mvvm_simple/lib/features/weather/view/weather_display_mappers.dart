import 'package:weather_mvvm_simple/features/weather/data/models/city_model.dart';
import 'package:weather_mvvm_simple/features/weather/data/models/daily_model.dart';
import 'package:weather_mvvm_simple/features/weather/data/models/hourly_model.dart';
import 'package:weather_mvvm_simple/features/weather/data/models/weather_model.dart';
import 'package:weather_ui/weather_ui.dart';

extension WeatherModelMapper on WeatherModel {
  WeatherDisplay toDisplay() => WeatherDisplay(
    cityName: cityName,
    country: country,
    temperature: temperature,
    feelsLike: feelsLike,
    description: description,
    iconCode: iconCode,
    humidity: humidity,
    windSpeed: windSpeed,
  );
}

extension HourlyModelMapper on HourlyModel {
  HourlyDisplay toDisplay() => HourlyDisplay(time: time, temperature: temperature, iconCode: iconCode);
}

extension DailyModelMapper on DailyModel {
  DailyDisplay toDisplay() => DailyDisplay(date: date, minTemp: minTemp, maxTemp: maxTemp, iconCode: iconCode);
}

extension CityModelMapper on CityModel {
  CityDisplay toDisplay() =>
      CityDisplay(name: name, state: state, country: country, latitude: latitude, longitude: longitude);
}
