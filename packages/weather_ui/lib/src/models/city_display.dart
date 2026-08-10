class CityDisplay {
  final String name;
  final String? state;
  final String country;
  final double latitude;
  final double longitude;

  const CityDisplay({
    required this.name,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  String get displayName => [name, if (state != null) state, country].join(', ');
}
