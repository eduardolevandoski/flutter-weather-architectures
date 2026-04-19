class DailyModel {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String iconCode;

  const DailyModel({required this.date, required this.minTemp, required this.maxTemp, required this.iconCode});

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';

  String get minTempFormatted => '${minTemp.toStringAsFixed(0)}°';

  String get maxTempFormatted => '${maxTemp.toStringAsFixed(0)}°';

  String get weekday {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }

  static DailyModel placeholder(int index) => DailyModel(
    date: DateTime.now().add(Duration(days: index)),
    minTemp: 15,
    maxTemp: 25,
    iconCode: '01d',
  );
}
