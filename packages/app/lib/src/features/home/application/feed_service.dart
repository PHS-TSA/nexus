/// This library provides a service to stream posts in DB to the UI.
library;

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_service.dart';
import '../data/post_repository.dart';
import '../domain/feed_entity.dart';
import '../domain/feed_model.dart';
import '../domain/post_entity.dart';
import 'avatar_service.dart';

part 'feed_service.g.dart';

/// Provide the values of a feed.
@riverpod
base class FeedService extends _$FeedService {
  @override
  FeedModel build(FeedEntity feed) {
    return const FeedModel(posts: [], ids: [], cursorPos: null);
  }

  /// Fetch the next post in the feed.
  /// Handles pagination automatically.
  /// Returns null if there are no more posts.
  Future<PostEntity?> fetch(int postIndex) async {
    final id = ref.read(idProvider);
    final username = ref.read(usernameProvider);
    final postRepo = ref.read(postRepositoryProvider(id, username, feed));

    // Attempt to retrieve the cached post
    final cachedPost = state.posts.elementAtOrNull(postIndex);

    if (cachedPost != null) {
      // Retrieve the corresponding ID
      final cachedPostId = state.ids.elementAtOrNull(postIndex);
      if (cachedPostId != null) {
        // Return the updated cached post with its ID
        return cachedPost.copyWith(id: cachedPostId);
      }
      // If ID is missing, proceed to fetch
    }

    // Fetch the specific batch
    final posts = await postRepo.readPosts(state.cursorPos);

    if (posts.isEmpty) return null;

    // Update the state with the new batch
    state = state.copyWith(
      posts: [...state.posts, ...posts.map((tuple) => tuple.entity)],
      ids: [...state.ids, ...posts.map((tuple) => tuple.id)],
      cursorPos: posts.lastOrNull?.id,
    );

    // Attempt to retrieve the desired post
    final desiredPost = state.posts.elementAtOrNull(postIndex);
    final desiredPostId = state.ids.elementAtOrNull(postIndex);

    return desiredPost?.copyWith(id: desiredPostId);
  }
}

/// Fetch a single post from the feed.
///
/// [postIndex] is the index of the current post user is viewing.
@riverpod
FutureOr<PostEntity?> singlePost(
  Ref ref,
  FeedEntity feed,
  int postIndex,
) async {
  // Ensure it'll get refreshed.
  ref.watch(feedServiceProvider(feed));

  // Keep previous posts in cache to make scrolling up possible.
  // Otherwise, `ListView` freaks out.
  if (postIndex != 0) {
    final post = await ref.watch(
      singlePostProvider(feed, postIndex - 1).future,
    );
    // Keeps avatar in local memory as well.
    ref.watch(avatarServiceProvider(post?.authorName));
  }

  final feedNotifier = ref.watch(feedServiceProvider(feed).notifier);
  final post = await feedNotifier.fetch(postIndex);

  return post;
}
