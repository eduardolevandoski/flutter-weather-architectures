import 'package:flutter/material.dart';
import 'package:weather_ui/src/models/city_display.dart';

class CitySuggestionsList extends StatelessWidget {
  final List<CityDisplay> cities;
  final ValueChanged<CityDisplay> onSelected;

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
        separatorBuilder: (_, _) => Divider(height: 1, color: theme.colorScheme.onSurface.withValues(alpha: 0.08)),
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
