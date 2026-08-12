import 'package:weather_bloc/core/errors/failures.dart';
import 'package:weather_bloc/features/weather/domain/entities/city.dart';
import 'package:weather_bloc/features/weather/domain/entities/forecast.dart';
import 'package:weather_bloc/features/weather/domain/entities/weather.dart';

sealed class WeatherState {
  /// Kept on every state so the dropdown stays open while
  /// the weather loads.
  final List<City> suggestions;

  const WeatherState({this.suggestions = const []});

  WeatherState copyWithSuggestions(List<City> suggestions);
}

final class WeatherInitial extends WeatherState {
  const WeatherInitial({super.suggestions});

  @override
  WeatherInitial copyWithSuggestions(List<City> suggestions) => WeatherInitial(suggestions: suggestions);
}

final class WeatherLoading extends WeatherState {
  const WeatherLoading({super.suggestions});

  @override
  WeatherLoading copyWithSuggestions(List<City> suggestions) => WeatherLoading(suggestions: suggestions);
}

final class WeatherLoaded extends WeatherState {
  final Weather weather;
  final Forecast forecast;

  const WeatherLoaded({required this.weather, required this.forecast, super.suggestions});

  @override
  WeatherLoaded copyWithSuggestions(List<City> suggestions) =>
      WeatherLoaded(weather: weather, forecast: forecast, suggestions: suggestions);
}

final class WeatherError extends WeatherState {
  final Failure failure;

  const WeatherError(this.failure, {super.suggestions});

  @override
  WeatherError copyWithSuggestions(List<City> suggestions) => WeatherError(failure, suggestions: suggestions);
}
