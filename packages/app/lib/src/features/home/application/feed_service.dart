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
  FeedModel build(FeedEntity feed) {
    return const FeedModel(posts: [], cursorPos: null);
  }

  /// Fetch the next post in the feed.
  /// Handles pagination automatically.
  /// Returns null if there are no more posts.
  Future<PostEntity?> fetch(int postIndex) async {
    final id = ref.watch(authServiceProvider).requireValue?.$id;
    final postRepo = ref.watch(postRepositoryProvider(id, feed));

    final cachedPost = state.posts.elementAtOrNull(postIndex);
    if (cachedPost != null) return cachedPost;

    // Get user's location.
    // TODO(lishaduck): Should make a location service so we cache determine location
    final location = await determinePosition();
    final lat = location.latitude;
    final lng = location.longitude;

    final posts = await postRepo.readPosts(
      state.cursorPos,
      lat,
      lng,
    );

    if (posts.isEmpty) return null;

    state = state.copyWith(
      posts: [...state.posts, ...posts.map((tuple) => tuple.entity)],
      cursorPos: posts.lastOrNull?.id,
    );

    final post = state.posts.elementAtOrNull(postIndex);
    return post ?? await fetch(postIndex + 1);
  }
}

/// Fetch a single post from the feed.
@riverpod
FutureOr<PostEntity?> singlePost(
  SinglePostRef ref,
  FeedEntity feed,
  int postIndex,
) async {
  // Keep previous posts in cache to make scrolling up possible.
  // Otherwise, `ListView` freaks out.
  if (postIndex != 0) ref.watch(singlePostProvider(feed, postIndex - 1));

  final feedNotifier = ref.watch(feedServiceProvider(feed).notifier);
  final post = await feedNotifier.fetch(postIndex);

  return post;
}

// TODO(lishaduck): Move this to the location repository.

/// Uses geolocator plugin to request location permission and return a position
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
