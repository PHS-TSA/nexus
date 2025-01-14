/// This library provides a service to stream posts in DB to the UI.
library;

import 'dart:typed_data';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_service.dart';
import '../data/post_repository.dart';
import '../domain/feed_entity.dart';
import '../domain/feed_model.dart';
import '../domain/post_entity.dart';

part 'feed_service.g.dart';

/// Provide the values of a feed.
@riverpod
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
@riverpod
FutureOr<PostId?> feedPost(Ref ref, FeedEntity feed, int postIndex) async {
  // Keep previous posts in cache to make scrolling up possible.
  // Otherwise, the `ListView` freaks out.
  if (postIndex != 0) {
    final lastPost = await ref.watch(
      feedPostProvider(feed, postIndex - 1).future,
    );

    if (lastPost != null) {
      final imageIds = ref.watch(
        singlePostProvider(lastPost).select((s) => s?.imageIds),
      );

      for (final imageId in imageIds ?? const IList<String>.empty()) {
        ref.watch(imageProvider(imageId));
      }
    }
  }

  final ids = ref.watch(feedServiceProvider(feed).select((s) => s.ids));

  var next = ids.elementAtOrNull(postIndex);
  var moreToGet = true;

  while (moreToGet && next == null) {
    moreToGet = await ref.watch(feedServiceProvider(feed).notifier).fetchMore();
    next = ids.elementAtOrNull(postIndex);
  }

  return next;
}

/// Store a post independently of any feed for memory efficiency.
///
/// [id] is the unique identifier for the post.
@riverpod
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
}

/// Image provider for posts
@riverpod
Future<Uint8List> image(Ref ref, String id) {
  return ref.watch(postRepositoryProvider).getImages(id);
}
