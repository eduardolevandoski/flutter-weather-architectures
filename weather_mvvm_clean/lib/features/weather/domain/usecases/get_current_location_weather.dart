import 'package:weather_mvvm_clean/features/weather/domain/entities/weather_report.dart';
import 'package:weather_mvvm_clean/features/weather/domain/repositories/i_location_repository.dart';
import 'package:weather_mvvm_clean/features/weather/domain/usecases/get_weather_by_coords.dart';

class GetCurrentLocationWeather {
  final ILocationRepository _locationRepository;
  final GetWeatherByCoords _getWeatherByCoords;

  const GetCurrentLocationWeather(this._locationRepository, this._getWeatherByCoords);

  Future<WeatherReport> call() async {
    final coordinates = await _locationRepository.getCurrentCoordinates();
    return _getWeatherByCoords(coordinates);
  }
}
