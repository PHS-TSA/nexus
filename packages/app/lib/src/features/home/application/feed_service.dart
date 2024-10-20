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
    final username = ref.watch(authServiceProvider).requireValue?.name;
    final postRepo = ref.watch(postRepositoryProvider(id, username, feed));

    final cachedPost = state.posts.elementAtOrNull(postIndex);
    if (cachedPost != null) return cachedPost;

    // Get user's location.
    final posts = await postRepo.readPosts(state.cursorPos);

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
  Ref ref,
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
