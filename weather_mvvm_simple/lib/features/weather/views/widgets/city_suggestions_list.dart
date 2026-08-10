import 'package:flutter/material.dart';
import 'package:weather_mvvm_simple/features/weather/data/models/city_model.dart';

class CitySuggestionsList extends StatelessWidget {
  final List<CityModel> cities;
  final ValueChanged<CityModel> onSelected;

  const CitySuggestionsList({super.key, required this.cities, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(16),
      color: theme.colorScheme.surfaceContainerHigh,
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: cities.length,
        separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.onSurface.withValues(alpha: 0.08)),
        itemBuilder: (context, index) {
          final city = cities[index];
          return ListTile(
            dense: true,
            leading: Icon(Icons.place_outlined, size: 20, color: theme.colorScheme.onSurfaceVariant),
            title: Text(city.displayName, style: theme.textTheme.bodyMedium),
            onTap: () => onSelected(city),
          );
        },
      ),
    );
  }
}
