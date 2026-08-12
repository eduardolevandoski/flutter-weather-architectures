import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:weather_bloc/core/errors/failures.dart';
import 'package:weather_bloc/features/weather/domain/entities/coordinates.dart';
import 'package:weather_bloc/features/weather/domain/entities/weather_report.dart';
import 'package:weather_bloc/features/weather/domain/usecases/get_current_location_weather.dart';
import 'package:weather_bloc/features/weather/domain/usecases/get_weather_by_city.dart';
import 'package:weather_bloc/features/weather/domain/usecases/get_weather_by_coords.dart';
import 'package:weather_bloc/features/weather/domain/usecases/search_cities.dart';
import 'package:weather_bloc/features/weather/presentation/bloc/weather_event.dart';
import 'package:weather_bloc/features/weather/presentation/bloc/weather_state.dart';

EventTransformer<E> _debounce<E>(Duration duration) {
  return (events, mapper) => droppable<E>()(events.debounce(duration), mapper);
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentLocationWeather _getCurrentLocationWeather;
  final GetWeatherByCity _getWeatherByCity;
  final GetWeatherByCoords _getWeatherByCoords;
  final SearchCities _searchCities;

  WeatherBloc({
    required GetCurrentLocationWeather getCurrentLocationWeather,
    required GetWeatherByCity getWeatherByCity,
    required GetWeatherByCoords getWeatherByCoords,
    required SearchCities searchCities,
  }) : _getCurrentLocationWeather = getCurrentLocationWeather,
       _getWeatherByCity = getWeatherByCity,
       _getWeatherByCoords = getWeatherByCoords,
       _searchCities = searchCities,
       super(const WeatherInitial()) {
    on<LocationRequested>(_onLocationRequested, transformer: restartable());
    on<CitySearched>(_onCitySearched, transformer: restartable());
    on<CitySelected>(_onCitySelected, transformer: restartable());
    on<QueryChanged>(_onQueryChanged, transformer: _debounce(const Duration(milliseconds: 400)));
    on<SuggestionsCleared>(_onSuggestionsCleared);
  }

  Future<void> _onLocationRequested(LocationRequested event, Emitter<WeatherState> emit) {
    return _load(emit, () => _getCurrentLocationWeather());
  }

  Future<void> _onCitySearched(CitySearched event, Emitter<WeatherState> emit) {
    if (event.city.trim().isEmpty) return Future.value();
    return _load(emit, () => _getWeatherByCity(event.city.trim()));
  }

  Future<void> _onCitySelected(CitySelected event, Emitter<WeatherState> emit) {
    return _load(emit, () => _getWeatherByCoords(Coordinates(latitude: event.latitude, longitude: event.longitude)));
  }

  Future<void> _onQueryChanged(QueryChanged event, Emitter<WeatherState> emit) async {
    final query = event.query.trim();

    if (query.length < 3) {
      emit(state.copyWithSuggestions(const []));
      return;
    }

    try {
      final cities = await _searchCities(query);
      emit(state.copyWithSuggestions(cities));
    } on Failure {
      emit(state.copyWithSuggestions(const []));
    }
  }

  void _onSuggestionsCleared(SuggestionsCleared event, Emitter<WeatherState> emit) {
    emit(state.copyWithSuggestions(const []));
  }

  Future<void> _load(Emitter<WeatherState> emit, Future<WeatherReport> Function() request) async {
    emit(const WeatherLoading());

    try {
      final report = await request();
      emit(WeatherLoaded(weather: report.weather, forecast: report.forecast));
    } on Failure catch (e) {
      emit(WeatherError(e));
    }
  }
}
