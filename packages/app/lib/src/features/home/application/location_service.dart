import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/location_repository.dart';

part 'location_service.g.dart';

/// Get the user's location.
@riverpod
FutureOr<Position> locationService(Ref ref) {
  final locationRepo = ref.watch(locationRepositoryProvider);

  try {
    return locationRepo.determinePosition();
  } catch (e) {
    throw 'Hmmmmm $e';
  }
}
