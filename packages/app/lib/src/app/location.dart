import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.

class LocationRepository {
  @riverpod
  LocationRepository locationRepository() => LocationRepository();
}
