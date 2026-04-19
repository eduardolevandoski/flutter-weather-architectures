import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:weather_mvvm_simple/features/weather/data/models/daily_model.dart';

class WeeklyForecastCard extends StatelessWidget {
  final List<DailyModel> daily;
  final bool isLoading;

  const WeeklyForecastCard({super.key, required this.daily, this.isLoading = false});

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
                  Icon(Icons.calendar_today_outlined, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                  const SizedBox(width: 4),
                  Text(
                    '5-DAY FORECAST',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              ...daily.map((day) => _DailyRow(day: day, isLoading: isLoading)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyRow extends StatelessWidget {
  final DailyModel day;
  final bool isLoading;

  const _DailyRow({required this.day, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(day.weekday, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          ),
          Skeleton.replace(
            replace: isLoading,
            replacement: const SizedBox(width: 32, height: 32),
            child: Image.network(
              day.iconUrl,
              width: 32,
              height: 32,
              loadingBuilder: (context, child, progress) => progress == null ? child : const SizedBox(width: 32, height: 32),
            ),
          ),
          const Spacer(),
          Text(
            day.minTempFormatted,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
          const SizedBox(width: 8),
          _TemperatureBar(isLoading: isLoading),
          const SizedBox(width: 8),
          SizedBox(
            width: 32,
            child: Text(day.maxTempFormatted, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _TemperatureBar extends StatelessWidget {
  final bool isLoading;

  const _TemperatureBar({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Skeleton.replace(
      replace: isLoading,
      replacement: Container(
        width: 80,
        height: 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Container(
        width: 80,
        height: 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          gradient: LinearGradient(colors: [theme.colorScheme.primary.withValues(alpha: 0.2), theme.colorScheme.primary]),
        ),
      ),
    );
  }
}
