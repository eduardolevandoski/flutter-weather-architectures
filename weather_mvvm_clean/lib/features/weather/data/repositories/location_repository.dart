import 'package:weather_mvvm_clean/core/errors/exceptions.dart';
import 'package:weather_mvvm_clean/core/errors/failures.dart';
import 'package:weather_mvvm_clean/features/weather/data/datasources/i_location_datasource.dart';
import 'package:weather_mvvm_clean/features/weather/domain/entities/coordinates.dart';
import 'package:weather_mvvm_clean/features/weather/domain/repositories/i_location_repository.dart';

class LocationRepository implements ILocationRepository {
  final ILocationDataSource _dataSource;

  const LocationRepository(this._dataSource);

  @override
  Future<Coordinates> getCurrentCoordinates() async {
    try {
      final position = await _dataSource.getCurrentPosition();
      return Coordinates(latitude: position.latitude, longitude: position.longitude);
    } on LocationDisabledException {
      throw const LocationDisabledFailure();
    } on LocationPermissionDeniedException {
      throw const LocationPermissionDeniedFailure();
    } catch (_) {
      throw const NetworkFailure();
    }
  }
}
