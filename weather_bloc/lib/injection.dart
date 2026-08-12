import 'package:http/http.dart' as http;
import 'package:weather_bloc/features/weather/data/datasources/location_datasource.dart';
import 'package:weather_bloc/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_bloc/features/weather/data/repositories/location_repository.dart';
import 'package:weather_bloc/features/weather/data/repositories/weather_repository.dart';
import 'package:weather_bloc/features/weather/domain/usecases/get_current_location_weather.dart';
import 'package:weather_bloc/features/weather/domain/usecases/get_weather_by_city.dart';
import 'package:weather_bloc/features/weather/domain/usecases/get_weather_by_coords.dart';
import 'package:weather_bloc/features/weather/domain/usecases/search_cities.dart';
import 'package:weather_bloc/features/weather/presentation/bloc/weather_bloc.dart';

WeatherBloc buildWeatherBloc() {
  final weatherDataSource = WeatherRemoteDataSource(http.Client());
  const locationDataSource = LocationDataSource();

  final weatherRepository = WeatherRepository(weatherDataSource);
  final locationRepository = LocationRepository(locationDataSource);

  final getWeatherByCoords = GetWeatherByCoords(weatherRepository);

  return WeatherBloc(
    getCurrentLocationWeather: GetCurrentLocationWeather(locationRepository, getWeatherByCoords),
    getWeatherByCity: GetWeatherByCity(weatherRepository),
    getWeatherByCoords: getWeatherByCoords,
    searchCities: SearchCities(weatherRepository),
  );
}
