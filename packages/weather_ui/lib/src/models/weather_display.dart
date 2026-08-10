class WeatherDisplay {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;

  const WeatherDisplay({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
  });

  String get location => '$cityName, $country';

  String get tempFormatted => '${temperature.toStringAsFixed(0)}°';

  String get feelsLikeFormatted => '${feelsLike.toStringAsFixed(0)}°';

  String get windFormatted => '${windSpeed.toStringAsFixed(1)} m/s';

  String get descriptionCapitalized =>
      description.isEmpty ? description : description[0].toUpperCase() + description.substring(1);

  static const placeholder = WeatherDisplay(
    cityName: 'New York',
    country: 'US',
    temperature: 22,
    feelsLike: 21,
    description: 'clear sky',
    iconCode: '01d',
    humidity: 60,
    windSpeed: 3.5,
  );
}
