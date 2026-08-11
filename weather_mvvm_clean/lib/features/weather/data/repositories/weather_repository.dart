import 'package:weather_mvvm_clean/core/errors/exceptions.dart';
import 'package:weather_mvvm_clean/core/errors/failures.dart';
import 'package:weather_mvvm_clean/features/weather/data/datasources/i_weather_remote_datasource.dart';
import 'package:weather_mvvm_clean/features/weather/domain/entities/city.dart';
import 'package:weather_mvvm_clean/features/weather/domain/entities/coordinates.dart';
import 'package:weather_mvvm_clean/features/weather/domain/entities/forecast.dart';
import 'package:weather_mvvm_clean/features/weather/domain/entities/weather.dart';
import 'package:weather_mvvm_clean/features/weather/domain/repositories/i_weather_repository.dart';

class WeatherRepository implements IWeatherRepository {
  final IWeatherRemoteDataSource _dataSource;

  const WeatherRepository(this._dataSource);

  @override
  Future<Weather> getWeatherByCity(String city) {
    return _guard(() async {
      final model = await _dataSource.getWeatherByCity(city);
      return model.toEntity();
    });
  }

  @override
  Future<Weather> getWeatherByCoords(Coordinates coordinates) {
    return _guard(() async {
      final model = await _dataSource.getWeatherByCoords(coordinates.latitude, coordinates.longitude);
      return model.toEntity();
    });
  }

  @override
  Future<Forecast> getForecastByCity(String city) {
    return _guard(() async {
      final model = await _dataSource.getForecastByCity(city);
      return model.toEntity();
    });
  }

  @override
  Future<Forecast> getForecastByCoords(Coordinates coordinates) {
    return _guard(() async {
      final model = await _dataSource.getForecastByCoords(coordinates.latitude, coordinates.longitude);
      return model.toEntity();
    });
  }

  @override
  Future<List<City>> searchCities(String query) {
    return _guard(() async {
      final models = await _dataSource.searchCities(query);
      return models.map((city) => city.toEntity()).toList();
    });
  }

  /// Catches data exceptions and rethrows them as failures.
  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on CityNotFoundException {
      throw const CityNotFoundFailure();
    } on InvalidApiKeyException {
      throw const InvalidApiKeyFailure();
    } on ServerException catch (e) {
      throw ServerFailure(e.statusCode);
    } on NetworkException {
      throw const NetworkFailure();
    }
  }
}
