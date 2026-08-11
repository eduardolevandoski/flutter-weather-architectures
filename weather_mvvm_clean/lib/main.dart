import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:weather_mvvm_clean/core/theme/app_theme.dart';
import 'package:weather_mvvm_clean/features/weather/presentation/views/weather_view.dart';
import 'package:weather_mvvm_clean/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => buildWeatherViewModel(),
      child: MaterialApp(
        title: 'Weather MVVM Clean',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const WeatherView(),
      ),
    );
  }
}
