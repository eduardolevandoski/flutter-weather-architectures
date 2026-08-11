import 'package:weather_mvvm_clean/features/weather/domain/entities/city.dart';

class CityModel {
  final String name;
  final String? state;
  final String country;
  final double latitude;
  final double longitude;

  const CityModel({
    required this.name,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'] as String,
      state: json['state'] as String?,
      country: json['country'] as String,
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lon'] as num).toDouble(),
    );
  }

  City toEntity() => City(name: name, state: state, country: country, latitude: latitude, longitude: longitude);
}
