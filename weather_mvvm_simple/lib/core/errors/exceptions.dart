class CityNotFoundException implements Exception {
  const CityNotFoundException();
}

class NetworkException implements Exception {
  const NetworkException();
}

class InvalidApiKeyException implements Exception {
  const InvalidApiKeyException();
}

class ServerException implements Exception {
  final int statusCode;
  const ServerException(this.statusCode);
}

class LocationDisabledException implements Exception {
  const LocationDisabledException();
}

class LocationPermissionDeniedException implements Exception {
  const LocationPermissionDeniedException();
}
