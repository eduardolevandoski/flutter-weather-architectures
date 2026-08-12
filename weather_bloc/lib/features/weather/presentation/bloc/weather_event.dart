sealed class WeatherEvent {
  const WeatherEvent();
}

final class LocationRequested extends WeatherEvent {
  const LocationRequested();
}

final class CitySearched extends WeatherEvent {
  final String city;

  const CitySearched(this.city);
}

final class CitySelected extends WeatherEvent {
  final double latitude;
  final double longitude;

  const CitySelected({required this.latitude, required this.longitude});
}

final class QueryChanged extends WeatherEvent {
  final String query;

  const QueryChanged(this.query);
}

final class SuggestionsCleared extends WeatherEvent {
  const SuggestionsCleared();
}
