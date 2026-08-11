import 'package:weather_mvvm_clean/features/weather/domain/entities/forecast.dart';
import 'package:weather_mvvm_clean/features/weather/domain/entities/weather.dart';
import 'package:weather_mvvm_clean/features/weather/domain/entities/weather_report.dart';
import 'package:weather_mvvm_clean/features/weather/domain/repositories/i_weather_repository.dart';

class GetWeatherByCity {
  final IWeatherRepository _repository;

  const GetWeatherByCity(this._repository);

  Future<WeatherReport> call(String city) async {
    final results = await Future.wait([_repository.getWeatherByCity(city), _repository.getForecastByCity(city)]);

    return (weather: results[0] as Weather, forecast: results[1] as Forecast);
  }
}
