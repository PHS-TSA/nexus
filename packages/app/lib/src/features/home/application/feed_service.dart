/// This library provides a service to stream posts in DB to the UI.
// ignore_for_file: prefer_expression_function_bodies

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

//Load in the posts repository here as a func

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
    final id = ref.watch(idProvider);
    final username = ref.watch(usernameProvider);
    final postRepo = ref.watch(postRepositoryProvider(id, username, feed));

    final cachedPost = state.posts.elementAtOrNull(postIndex);

    if (cachedPost != null) {
      // Updates
      final cachedPostId = state.ids.elementAt(postIndex);
      final updatedCachedPost = cachedPost.copyWith(id: cachedPostId);
      return updatedCachedPost;
    }

    // Get user's location.
    final posts = await postRepo.readPosts(state.cursorPos);

    if (posts.isEmpty) return null;
    // Need to figure out how to add id value to post entity
    // posts[postIndex].entity = posts[postIndex].entity.copyWith(id: posts[postIndex].id);
    final postId = posts[postIndex].id;
    state = state.copyWith(
      posts: [...state.posts, ...posts.map((tuple) => tuple.entity)],
      ids: [...state.ids, ...posts.map((tuple) => tuple.id)],
      cursorPos: posts.lastOrNull?.id,
    );
    final post = state.posts.elementAtOrNull(postIndex);
    final updatedPost = post?.copyWith(id: postId);
    return updatedPost ?? await fetch(postIndex + 1);
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
  // Keep previous posts in cache to make scrolling up possible.
  // Otherwise, `ListView` freaks out.
  if (postIndex != 0) {
    final post = await ref.watch(
      singlePostProvider(feed, postIndex - 1).future,
    );
    // Keeps avatar in local memory
    ref.watch(avatarServiceProvider(post?.authorName));
  }

  final feedNotifier = ref.watch(feedServiceProvider(feed).notifier);
  final post = await feedNotifier.fetch(postIndex);

  return post;
}
