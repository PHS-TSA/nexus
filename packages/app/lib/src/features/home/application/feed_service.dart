/// This library provides a service to stream posts in DB to the UI.
library;

import 'dart:developer';

import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../gen/assets.gen.dart';
import '../data/post_repository.dart';
import '../domain/feed_entity.dart';
import '../domain/feed_model.dart';
import '../domain/post_entity.dart';

part 'feed_service.g.dart';

/// The number of posts to fetch at a time.
const pageSize = 10;

//Load in the posts repository here as a func

/// Provide the values of a feed.
@riverpod
base class FeedService extends _$FeedService {
  @override
  FutureOr<FeedModel> build(FeedEntity feed, int page) async {
    log('im running');
    final postRepo = ref.watch(postRepositoryProvider);
    log('im still running');
    final posts = postRepo.allPosts;
    log('im still still running');
    return FeedModel(
      // Generate a list containing [pageSize] number of dummy posts.
      posts: List.generate(
        pageSize,
        // TODO(MattsAttack): For local vs world sorting have a conditional to determine sorting method.
        (index) => PostEntity(
          image: switch (feed) {
            // If the feed is a LocalFeed or WorldFeed, use the appropriate image.
            LocalFeed _ || WorldFeed _ => Assets.pictures.kid.provider(),
          },
          headline: 'awesome title',
          timestamp: DateTime.now(),
          author: const UserId('12345'),
          location: const LatLng(0, 0), //add in users location here
          // Use the index to generate a unique body for each post.
          description: 'This works (#${(page - 1) * pageSize + index + 1})',
        ),
      ),

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
