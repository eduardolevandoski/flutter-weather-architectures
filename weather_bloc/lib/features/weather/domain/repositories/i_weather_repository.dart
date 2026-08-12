import 'package:weather_bloc/features/weather/domain/entities/city.dart';
import 'package:weather_bloc/features/weather/domain/entities/coordinates.dart';
import 'package:weather_bloc/features/weather/domain/entities/forecast.dart';
import 'package:weather_bloc/features/weather/domain/entities/weather.dart';

abstract interface class IWeatherRepository {
  Future<Weather> getWeatherByCity(String city);

  Future<Weather> getWeatherByCoords(Coordinates coordinates);

  Future<Forecast> getForecastByCity(String city);

  Future<Forecast> getForecastByCoords(Coordinates coordinates);

  Future<List<City>> searchCities(String query);
}
