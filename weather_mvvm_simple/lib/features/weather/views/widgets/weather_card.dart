import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:weather_mvvm_simple/features/weather/data/models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final bool isLoading;

  const WeatherCard({super.key, required this.weather, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Skeletonizer(
      enabled: isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 18),
              const SizedBox(width: 4),
              Text(weather.location, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                weather.temperatureFormatted,
                style: theme.textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w200, fontSize: 80),
              ),
              const SizedBox(width: 8),
              Skeleton.replace(
                replace: isLoading,
                replacement: const SizedBox(width: 64, height: 64),
                child: Image.network(
                  weather.iconUrl,
                  width: 64,
                  height: 64,
                  loadingBuilder: (context, child, progress) =>
                      progress == null ? child : const SizedBox(width: 64, height: 64),
                ),
              ),
            ],
          ),
          Text(
            weather.description[0].toUpperCase() + weather.description.substring(1),
            style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Skeleton.leaf(
                child: _StatChip(icon: Icons.thermostat_outlined, label: 'Feels like ${weather.feelsLikeFormatted}'),
              ),
              const SizedBox(width: 8),
              Skeleton.leaf(
                child: _StatChip(icon: Icons.water_drop_outlined, label: '${weather.humidity}%'),
              ),
              const SizedBox(width: 8),
              Skeleton.leaf(
                child: _StatChip(icon: Icons.air, label: weather.windFormatted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
