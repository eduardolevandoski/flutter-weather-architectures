sealed class Failure implements Exception {
  const Failure();
}

final class CityNotFoundFailure extends Failure {
  const CityNotFoundFailure();
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class InvalidApiKeyFailure extends Failure {
  const InvalidApiKeyFailure();
}

final class ServerFailure extends Failure {
  final int statusCode;

  const ServerFailure(this.statusCode);
}

final class LocationDisabledFailure extends Failure {
  const LocationDisabledFailure();
}

final class LocationPermissionDeniedFailure extends Failure {
  const LocationPermissionDeniedFailure();
}
