/// This library provides a service to stream posts in DB to the UI.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    final postRepo = ref.watch(
      postRepositoryProvider(const UserId('0'), feed),
    ); // Add user id here
    final posts = await postRepo.readPosts();

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
