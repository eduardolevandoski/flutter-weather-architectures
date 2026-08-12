import 'package:weather_bloc/features/weather/data/models/city_model.dart';
import 'package:weather_bloc/features/weather/data/models/forecast_model.dart';
import 'package:weather_bloc/features/weather/data/models/weather_model.dart';

abstract interface class IWeatherRemoteDataSource {
  Future<WeatherModel> getWeatherByCity(String city);

  Future<WeatherModel> getWeatherByCoords(double lat, double lon);

  Future<ForecastModel> getForecastByCity(String city);

  Future<ForecastModel> getForecastByCoords(double lat, double lon);

  Future<List<CityModel>> searchCities(String query);
}
