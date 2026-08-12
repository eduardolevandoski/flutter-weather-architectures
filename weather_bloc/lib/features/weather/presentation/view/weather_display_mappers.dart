import 'package:weather_bloc/features/weather/domain/entities/city.dart';
import 'package:weather_bloc/features/weather/domain/entities/daily_weather.dart';
import 'package:weather_bloc/features/weather/domain/entities/hourly_weather.dart';
import 'package:weather_bloc/features/weather/domain/entities/weather.dart';
import 'package:weather_ui/weather_ui.dart';

extension WeatherMapper on Weather {
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

extension HourlyWeatherMapper on HourlyWeather {
  HourlyDisplay toDisplay() => HourlyDisplay(time: time, temperature: temperature, iconCode: iconCode);
}

extension DailyWeatherMapper on DailyWeather {
  DailyDisplay toDisplay() => DailyDisplay(date: date, minTemp: minTemp, maxTemp: maxTemp, iconCode: iconCode);
}

extension CityMapper on City {
  CityDisplay toDisplay() =>
      CityDisplay(name: name, state: state, country: country, latitude: latitude, longitude: longitude);
}
