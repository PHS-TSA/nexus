/// This library provides a service to stream posts in DB to the UI.
library;

import 'dart:typed_data';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_service.dart';
import '../../auth/domain/user.dart';
import '../data/post_repository.dart';
import '../domain/feed_entity.dart';
import '../domain/feed_model.dart';
import '../domain/post_entity.dart';

part 'feed_service.g.dart';

/// Provide the values of a feed.
@Riverpod(keepAlive: true)
base class FeedService extends _$FeedService {
  @override
  FeedModel build(FeedEntity feed) {
    return const FeedModel(ids: IList.empty(), cursorPos: null);
  }

  /// Fetch the next posts for a given [feed].
  ///
  /// Handles pagination automatically.
  /// Returns `true` if more were fetched, and false if not.
  Future<bool> fetchMore() async {
    final postRepo = ref.read(postRepositoryProvider);

    // Fetch the specific batch
    final fetchedPosts = await postRepo.readPosts(feed, state.cursorPos);

    if (fetchedPosts.isEmpty) return false;

    // Store each fetched post in the provider without directly calling setPost
    final newPostIds = <PostId>[];
    for (final post in fetchedPosts) {
      // Store the post in the provider
      ref.watch(singlePostProvider(post.id).notifier).setPost(post);

      // Collect the post ID
      newPostIds.add(post.id);
    }

    // Update the state with the new batch of post IDs and cursor
    state = state.copyWith(
      ids: state.ids.addAll(newPostIds),
      cursorPos: newPostIds.lastOrNull,
    );

    return true;
  }
}

/// Fetches a single post from the feed.
///
/// [postIndex] is the index of the current post the user is viewing.
@Riverpod(keepAlive: true)
FutureOr<PostId?> feedPost(Ref ref, FeedEntity feed, int postIndex) async {
  // Keep previous posts in cache to make scrolling up possible.
  // Otherwise, the `ListView` freaks out.
  // Also makes reloading the feed significantly simpler.
  if (postIndex != 0) {
    ref.watch(feedPostProvider(feed, postIndex - 1));
  }

  var next = ref
      .read(feedServiceProvider(feed).select((s) => s.ids))
      .elementAtOrNull(postIndex);
  var moreToGet = true;

  while (moreToGet && next == null) {
    moreToGet = await ref.watch(feedServiceProvider(feed).notifier).fetchMore();
    next = ref
        .read(feedServiceProvider(feed).select((s) => s.ids))
        .elementAtOrNull(postIndex);
  }

  return next;
}

/// Given a list of likes and a user ID, return a new list of likes with the user ID toggled in or out of the list.
Likes _toggleLike(Likes currentLikes, UserId userId) {
  // Toggle likes.
  if (!currentLikes.contains(userId)) {
    // User likes the post.
    return currentLikes.add(userId);
  } else {
    // User is removing like
    return currentLikes.remove(userId);
  }
}

/// Store a post independently of any feed for memory efficiency.
///
/// [id] is the unique identifier for the post.
@Riverpod(keepAlive: true)
base class SinglePost extends _$SinglePost {
  @override
  PostEntity? build(PostId id) {
    // Initially, the post is null. It will be set when fetched.
    return null;
  }

  /// Set the post data.
  // TODO(lishaduck): Be a good person.
  // ignore: use_setters_to_change_properties
  void setPost(PostEntity post) {
    state = post;
  }

  Future<bool> toggleLike(UserId userId) async {
    if (state == null) return false;
    final post = state!;

    final newLikes = _toggleLike(post.likes, userId);

    state = post.copyWith(likes: newLikes);

    try {
      await ref
          .read(postRepositoryProvider)
          .toggleLikePost(post.id, userId, newLikes);
    } on Exception {
      // Undo like.
      ref
          .read(singlePostProvider(post.id).notifier)
          .setPost(post); // This is still the old post.

      return false;
    }

    return true;
  }
}

/// Image provider for posts
@Riverpod(keepAlive: true)
Future<Uint8List> image(Ref ref, String id) async {
  return await ref.watch(postRepositoryProvider).getImages(id);
}
