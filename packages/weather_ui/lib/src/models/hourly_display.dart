class HourlyDisplay {
  final DateTime time;
  final double temperature;
  final String iconCode;

  const HourlyDisplay({required this.time, required this.temperature, required this.iconCode});

  String get tempFormatted => '${temperature.toStringAsFixed(0)}°';

  String get hourFormatted => '${time.hour.toString().padLeft(2, '0')}:00';

  static HourlyDisplay placeholder(int index) => HourlyDisplay(
    time: DateTime.now().add(Duration(hours: index * 3)),
    temperature: 22,
    iconCode: '01d',
  );
}
