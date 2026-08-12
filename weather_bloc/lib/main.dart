import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_bloc/core/theme/app_theme.dart';
import 'package:weather_bloc/features/weather/presentation/bloc/weather_event.dart';
import 'package:weather_bloc/features/weather/presentation/view/weather_view.dart';
import 'package:weather_bloc/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => buildWeatherBloc()..add(const LocationRequested()),
      child: MaterialApp(
        title: 'Weather Bloc',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const WeatherView(),
      ),
    );
  }
}