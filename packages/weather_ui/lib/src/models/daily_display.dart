class DailyDisplay {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String iconCode;

  const DailyDisplay({required this.date, required this.minTemp, required this.maxTemp, required this.iconCode});

  String get minFormatted => '${minTemp.toStringAsFixed(0)}°';

  String get maxFormatted => '${maxTemp.toStringAsFixed(0)}°';

  String get weekday {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }

  static DailyDisplay placeholder(int index) => DailyDisplay(
    date: DateTime.now().add(Duration(days: index)),
    minTemp: 15,
    maxTemp: 25,
    iconCode: '01d',
  );
}
