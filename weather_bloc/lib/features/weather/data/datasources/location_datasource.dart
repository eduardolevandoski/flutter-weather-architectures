import 'package:geolocator/geolocator.dart';
import 'package:weather_bloc/core/errors/exceptions.dart';
import 'package:weather_bloc/features/weather/data/datasources/i_location_datasource.dart';

class LocationDataSource implements ILocationDataSource {
  const LocationDataSource();

  @override
  Future<({double latitude, double longitude})> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw const LocationDisabledException();

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationPermissionDeniedException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationPermissionDeniedException();
    }

    final position = await Geolocator.getCurrentPosition();
    return (latitude: position.latitude, longitude: position.longitude);
  }
}
