import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/location_repository.dart';

part 'location_service.g.dart';

/// Get the user's location.
@riverpod
FutureOr<Position> locationService(LocationServiceRef ref) {
  final locationRepo = ref.watch(locationRepositoryProvider);

  return locationRepo.determinePosition();
}
