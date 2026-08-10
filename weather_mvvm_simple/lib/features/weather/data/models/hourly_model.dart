class HourlyModel {
  final DateTime time;
  final double temperature;
  final String iconCode;

  const HourlyModel({required this.time, required this.temperature, required this.iconCode});

  factory HourlyModel.fromJson(Map<String, dynamic> json) {
    return HourlyModel(
      time: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      iconCode: json['weather'][0]['icon'] as String,
    );
  }
}
