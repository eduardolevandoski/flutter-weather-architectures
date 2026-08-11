import 'package:weather_mvvm_clean/features/weather/domain/entities/coordinates.dart';

abstract interface class ILocationRepository {
  Future<Coordinates> getCurrentCoordinates();
}
