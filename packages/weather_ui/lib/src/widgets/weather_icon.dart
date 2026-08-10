import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String iconCode;
  final double size;

  const WeatherIcon({super.key, required this.iconCode, required this.size});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (icon, color) = _resolve(isDark);

    return Icon(icon, size: size, color: color);
  }

  /// Maps an OpenWeatherMap icon code to a Material icon.
  ///
  /// Codes are 3 characters: two digits for the condition,
  /// then 'd' (day) or 'n' (night) — e.g. "01d", "04n".
  /// Only clear sky differs between day and night here.
  ///
  /// 01 - clear sky
  /// 02 - few clouds       (11-25% cover)
  /// 03 - scattered clouds (25-50% cover)
  /// 04 - broken clouds    (51-100% cover)
  /// 09 - shower rain
  /// 10 - rain
  /// 11 - thunderstorm
  /// 13 - snow
  /// 50 - mist
  ///
  /// https://openweathermap.org/weather-conditions
  (IconData, Color) _resolve(bool isDark) {
    final condition = iconCode.substring(0, 2);
    final isNight = iconCode.endsWith('n');

    return switch (condition) {
      '01' when isNight => (Icons.nightlight_round, _night(isDark)),
      '01' => (Icons.wb_sunny_rounded, _sun(isDark)),
      '02' => (Icons.cloud_queue_rounded, _cloud(isDark)),
      '03' => (Icons.cloud_outlined, _cloud(isDark)),
      '04' => (Icons.cloud_rounded, _cloud(isDark)),
      '09' => (Icons.grain_rounded, _rain(isDark)),
      '10' => (Icons.water_drop_rounded, _rain(isDark)),
      '11' => (Icons.thunderstorm_rounded, _storm(isDark)),
      '13' => (Icons.ac_unit_rounded, _snow(isDark)),
      '50' => (Icons.foggy, _cloud(isDark)),
      _ => (Icons.cloud_rounded, _cloud(isDark)),
    };
  }

  //@formatter:off
  Color _sun(bool isDark) => isDark ? Colors.amber.shade300 : Colors.amber.shade700;
  Color _night(bool isDark) => isDark ? Colors.indigo.shade200 : Colors.indigo.shade400;
  Color _cloud(bool isDark) => isDark ? Colors.blueGrey.shade200 : Colors.blueGrey.shade500;
  Color _rain(bool isDark) => isDark ? Colors.lightBlue.shade200 : Colors.blue.shade600;
  Color _storm(bool isDark) => isDark ? Colors.deepPurple.shade200 : Colors.deepPurple.shade400;
  Color _snow(bool isDark) => isDark ? Colors.cyan.shade100 : Colors.cyan.shade600;
  //@formatter:on
}