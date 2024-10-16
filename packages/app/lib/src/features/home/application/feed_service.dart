/// This library provides a service to stream posts in DB to the UI.
library;

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_service.dart';
import '../data/post_repository.dart';
import '../domain/feed_entity.dart';
import '../domain/feed_model.dart';
import '../domain/post_entity.dart';

part 'feed_service.g.dart';

//Load in the posts repository here as a func

/// Provide the values of a feed.
@riverpod
base class FeedService extends _$FeedService {
  @override
  FutureOr<FeedModel> build(FeedEntity feed, int page) async {
    final id = ref.watch(authServiceProvider).requireValue?.$id;
    final postRepo = ref.watch(
      postRepositoryProvider(
        UserId(
          // TODO(MattsAttack): Find a way to handle null here.
          id!,
        ),
        feed,
      ),
    );

    // Get user's location.
    // TODO(lishaduck): Should make a location service so we cache determine location
    final location = await determinePosition();
    final lat = location.latitude;
    final lng = location.longitude;

    final posts = await postRepo.readPosts(
      lat,
      lng,
    ); // Bool to differentate local from world in post repository

    return FeedModel(
      posts: posts,
      // TODO(lishaduck): Set the cursor position to the last post.
      cursorPos: '',
    );
  }

  // TODO(MattsAttack): This is just an unused example. It should be used or removed.
  /// Replace the current posts with newly generated posts.
  Future<FeedModel> addPosts(List<PostEntity> newPosts) async {
    // You can only change a Notifier's `state` by adding methods that assign a new value.
    // You can't mutate the state directly, nor can you change it outside of a method.
    return await update((value) {
      return value.copyWith(
        posts: [
          // Spread the new list into the generated list.
          ...value.posts,
          ...newPosts,
        ],
      );
    });
  }
}

// TODO(lishaduck): Move this to the location repository.
Future<Position> determinePosition() async {
  // Test if location services are enabled.
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    throw Exception('Location services are disabled.');
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    throw Exception(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return Geolocator.getCurrentPosition();
}
