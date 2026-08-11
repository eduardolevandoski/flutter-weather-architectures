abstract interface class ILocationDataSource {
  Future<({double latitude, double longitude})> getCurrentPosition();
}
