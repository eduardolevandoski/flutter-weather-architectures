import 'package:http/http.dart' as http;
import 'package:weather_mvvm_clean/features/weather/data/datasources/location_datasource.dart';
import 'package:weather_mvvm_clean/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_mvvm_clean/features/weather/data/repositories/location_repository.dart';
import 'package:weather_mvvm_clean/features/weather/data/repositories/weather_repository.dart';
import 'package:weather_mvvm_clean/features/weather/domain/usecases/get_current_location_weather.dart';
import 'package:weather_mvvm_clean/features/weather/domain/usecases/get_weather_by_city.dart';
import 'package:weather_mvvm_clean/features/weather/domain/usecases/get_weather_by_coords.dart';
import 'package:weather_mvvm_clean/features/weather/domain/usecases/search_cities.dart';
import 'package:weather_mvvm_clean/features/weather/presentation/viewmodels/weather_viewmodel.dart';

WeatherViewModel buildWeatherViewModel() {
  final weatherDataSource = WeatherRemoteDataSource(http.Client());
  final locationDataSource = const LocationDataSource();

  final weatherRepository = WeatherRepository(weatherDataSource);
  final locationRepository = LocationRepository(locationDataSource);

  final getWeatherByCoords = GetWeatherByCoords(weatherRepository);

  return WeatherViewModel(
    getCurrentLocationWeather: GetCurrentLocationWeather(locationRepository, getWeatherByCoords),
    getWeatherByCity: GetWeatherByCity(weatherRepository),
    getWeatherByCoords: getWeatherByCoords,
    searchCities: SearchCities(weatherRepository),
  );
}
