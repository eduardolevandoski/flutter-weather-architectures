import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/core/errors/failures.dart';
import 'package:weather_bloc/features/weather/domain/entities/forecast.dart';
import 'package:weather_bloc/features/weather/domain/entities/weather.dart';
import 'package:weather_bloc/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_bloc/features/weather/presentation/bloc/weather_event.dart';
import 'package:weather_bloc/features/weather/presentation/bloc/weather_state.dart';
import 'package:weather_bloc/features/weather/presentation/view/weather_display_mappers.dart';
import 'package:weather_ui/weather_ui.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              final bloc = context.read<WeatherBloc>();

              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      WeatherSearchBar(
                        isLoading: state is WeatherLoading,
                        onSearch: (city) => bloc.add(CitySearched(city)),
                        onChanged: (query) => bloc.add(QueryChanged(query)),
                        onClear: () => bloc.add(const LocationRequested()),
                      ),
                      const SizedBox(height: 24),
                      Expanded(child: _buildBody(state)),
                    ],
                  ),
                  if (state.suggestions.isNotEmpty)
                    Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: CitySuggestionsList(
                        cities: state.suggestions.map((city) => city.toDisplay()).toList(),
                        onSelected: (city) => bloc.add(CitySelected(latitude: city.latitude, longitude: city.longitude)),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(WeatherState state) => switch (state) {
    WeatherInitial() => const _EmptyContent(),
    WeatherLoading() => const _LoadingContent(),
    WeatherLoaded(:final weather, :final forecast) => _LoadedContent(weather: weather, forecast: forecast),
    WeatherError(:final failure) => _ErrorContent(failure: failure),
  };
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  static final _weather = WeatherDisplay.placeholder;
  static final _hourly = List.generate(8, HourlyDisplay.placeholder);
  static final _daily = List.generate(5, DailyDisplay.placeholder);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        WeatherCard(weather: _weather, isLoading: true),
        const SizedBox(height: 16),
        HourlyForecastCard(hourly: _hourly, isLoading: true),
        const SizedBox(height: 12),
        WeeklyForecastCard(daily: _daily, isLoading: true),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _LoadedContent extends StatelessWidget {
  final Weather weather;
  final Forecast forecast;

  const _LoadedContent({required this.weather, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        WeatherCard(weather: weather.toDisplay()),
        const SizedBox(height: 16),
        HourlyForecastCard(hourly: forecast.hourly.map((hour) => hour.toDisplay()).toList()),
        const SizedBox(height: 12),
        WeeklyForecastCard(daily: forecast.daily.map((day) => day.toDisplay()).toList()),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _EmptyContent extends StatelessWidget {
  const _EmptyContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_outlined, size: 72, color: theme.colorScheme.outline),
          const SizedBox(height: 12),
          Text(
            'Search for a city to get started',
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final Failure failure;

  const _ErrorContent({required this.failure});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (icon, message, color) = switch (failure) {
      CityNotFoundFailure() => (
        Icons.location_off_outlined,
        'City not found. Try another search.',
        theme.colorScheme.outline,
      ),
      LocationDisabledFailure() => (
        Icons.location_disabled_outlined,
        'Location services are disabled.',
        theme.colorScheme.outline,
      ),
      LocationPermissionDeniedFailure() => (
        Icons.location_off_outlined,
        'Location permission denied.',
        theme.colorScheme.outline,
      ),
      InvalidApiKeyFailure() => (Icons.key_off_outlined, 'Invalid API key.', theme.colorScheme.error),
      ServerFailure() => (Icons.cloud_off_outlined, 'Server error. Try again later.', theme.colorScheme.error),
      NetworkFailure() => (Icons.wifi_off_outlined, 'No internet connection.', theme.colorScheme.error),
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 72, color: color),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
