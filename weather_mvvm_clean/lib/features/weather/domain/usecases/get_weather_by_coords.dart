import 'package:weather_mvvm_clean/features/weather/domain/entities/coordinates.dart';
import 'package:weather_mvvm_clean/features/weather/domain/entities/forecast.dart';
import 'package:weather_mvvm_clean/features/weather/domain/entities/weather.dart';
import 'package:weather_mvvm_clean/features/weather/domain/entities/weather_report.dart';
import 'package:weather_mvvm_clean/features/weather/domain/repositories/i_weather_repository.dart';

class GetWeatherByCoords {
  final IWeatherRepository _repository;

  const GetWeatherByCoords(this._repository);

  Future<WeatherReport> call(Coordinates coordinates) async {
    final results = await Future.wait([
      _repository.getWeatherByCoords(coordinates),
      _repository.getForecastByCoords(coordinates),
    ]);

    return (weather: results[0] as Weather, forecast: results[1] as Forecast);
  }
}
