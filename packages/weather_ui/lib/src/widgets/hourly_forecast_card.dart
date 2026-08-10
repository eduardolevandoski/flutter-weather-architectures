import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:weather_ui/src/models/hourly_display.dart';
import 'package:weather_ui/src/widgets/weather_icon.dart';

class HourlyForecastCard extends StatelessWidget {
  final List<HourlyDisplay> hourly;
  final bool isLoading;

  const HourlyForecastCard({super.key, required this.hourly, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Skeletonizer(
      enabled: isLoading,
      child: Card(
        elevation: 0,
        color: theme.colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                  const SizedBox(width: 4),
                  Text(
                    'HOURLY FORECAST',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: hourly.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 20),
                  itemBuilder: (context, index) => _HourlySlot(hourly: hourly[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HourlySlot extends StatelessWidget {
  final HourlyDisplay hourly;

  const _HourlySlot({required this.hourly});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          hourly.hourFormatted,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        WeatherIcon(iconCode: hourly.iconCode, size: 30),
        Text(hourly.tempFormatted, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
