import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:weather_mvvm_simple/core/location/location_service.dart';
import 'package:weather_mvvm_simple/features/weather/data/weather_repository.dart';
import 'package:weather_mvvm_simple/features/weather/viewmodels/weather_viewmodel.dart';
import 'package:weather_mvvm_simple/features/weather/views/weather_view.dart';

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
      create: (_) => WeatherViewModel(WeatherRepository(http.Client()), const LocationService()),
      child: MaterialApp(
        title: 'Weather MVVM Simple',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true, brightness: Brightness.light),
        home: const WeatherView(),
      ),
    );
  }
}
