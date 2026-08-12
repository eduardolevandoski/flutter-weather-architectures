import 'package:weather_bloc/features/weather/domain/entities/coordinates.dart';

abstract interface class ILocationRepository {
  Future<Coordinates> getCurrentCoordinates();
}
