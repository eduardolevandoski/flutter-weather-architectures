class HourlyModel {
  final DateTime time;
  final double temperature;
  final String iconCode;

  const HourlyModel({required this.time, required this.temperature, required this.iconCode});

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';

  String get temperatureFormatted => '${temperature.toStringAsFixed(0)}°';

  String get hourFormatted => '${time.hour.toString().padLeft(2, '0')}:00';

  factory HourlyModel.fromJson(Map<String, dynamic> json) {
    return HourlyModel(
      time: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      iconCode: json['weather'][0]['icon'] as String,
    );
  }

  static HourlyModel placeholder(int index) => HourlyModel(
    time: DateTime.now().add(Duration(hours: index * 3)),
    temperature: 22,
    iconCode: '01d',
  );
}
