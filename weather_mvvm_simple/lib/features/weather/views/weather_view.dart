import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_mvvm_simple/core/errors/exceptions.dart';
import 'package:weather_mvvm_simple/features/weather/viewmodels/weather_viewmodel.dart';
import 'package:weather_mvvm_simple/features/weather/views/weather_display_mappers.dart';
import 'package:weather_ui/weather_ui.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WeatherViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  WeatherSearchBar(
                    isLoading: vm.status == WeatherStatus.loading,
                    onSearch: vm.searchCity,
                    onChanged: vm.onQueryChanged,
                    onClear: vm.loadCurrentLocation,
                  ),
                  const SizedBox(height: 24),
                  Expanded(child: _buildBody(vm)),
                ],
              ),
              if (vm.suggestions.isNotEmpty)
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: CitySuggestionsList(
                    cities: vm.suggestions.map((city) => city.toDisplay()).toList(),
                    onSelected: (city) => vm.selectCity(city.latitude, city.longitude),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(WeatherViewModel vm) => switch (vm.status) {
    WeatherStatus.initial => const _EmptyContent(),
    WeatherStatus.loading => const _LoadingContent(),
    WeatherStatus.loaded => _LoadedContent(vm: vm),
    WeatherStatus.error => _ErrorContent(error: vm.error ?? const NetworkException()),
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
  final WeatherViewModel vm;

  const _LoadedContent({required this.vm});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        WeatherCard(weather: vm.weather!.toDisplay()),
        const SizedBox(height: 16),
        HourlyForecastCard(hourly: vm.forecast!.hourly.map((hour) => hour.toDisplay()).toList()),
        const SizedBox(height: 12),
        WeeklyForecastCard(daily: vm.forecast!.daily.map((day) => day.toDisplay()).toList()),
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
  final Exception error;

  const _ErrorContent({required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (icon, message, color) = switch (error) {
      CityNotFoundException() => (
        Icons.location_off_outlined,
        'City not found. Try another search.',
        theme.colorScheme.outline,
      ),
      LocationDisabledException() => (
        Icons.location_disabled_outlined,
        'Location services are disabled.',
        theme.colorScheme.outline,
      ),
      LocationPermissionDeniedException() => (
        Icons.location_off_outlined,
        'Location permission denied.',
        theme.colorScheme.outline,
      ),
      InvalidApiKeyException() => (Icons.key_off_outlined, 'Invalid API key.', theme.colorScheme.error),
      ServerException() => (Icons.cloud_off_outlined, 'Server error. Try again later.', theme.colorScheme.error),
      NetworkException() => (Icons.wifi_off_outlined, 'No internet connection.', theme.colorScheme.error),
      _ => (Icons.error_outline, 'Something went wrong.', theme.colorScheme.error),
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
