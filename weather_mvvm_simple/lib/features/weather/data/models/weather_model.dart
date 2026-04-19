class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;

  const WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
  });

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';

  String get location => '$cityName, $country';

  String get temperatureFormatted => '${temperature.toStringAsFixed(0)}°';

  String get feelsLikeFormatted => '${feelsLike.toStringAsFixed(0)}°';

  String get windFormatted => '${windSpeed.toStringAsFixed(1)} m/s';

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] as String,
      country: json['sys']['country'] as String,
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      iconCode: json['weather'][0]['icon'] as String,
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }

  static const placeholder = WeatherModel(
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
