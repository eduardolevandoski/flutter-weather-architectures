import 'package:weather_mvvm_clean/features/weather/domain/entities/city.dart';
import 'package:weather_mvvm_clean/features/weather/domain/repositories/i_weather_repository.dart';

class SearchCities {
  final IWeatherRepository _repository;

  const SearchCities(this._repository);

  Future<List<City>> call(String query) => _repository.searchCities(query);
}
