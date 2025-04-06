/// This library provides a service to get the user’s current location.
library;

import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/location_repository.dart';

part 'location_service.g.dart';

/// Get the user's location.
@riverpod
FutureOr<Position> locationService(Ref ref) async {
  final locationRepo = ref.watch(locationRepositoryProvider);

  return await locationRepo.determinePosition();
}
