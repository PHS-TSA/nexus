library;

import 'dart:typed_data';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/domain/user.dart';
import '../domain/comment_entity.dart';
import '../domain/post_id.dart';
import '../domain/post_model_entity.dart';
import 'avatar_service.dart';
import 'feed_service.dart';

part 'post_service.g.dart';

/// Provide the resolved values of a post.
/// This includes the avatar, images, and other data.
///
/// This lets us emulate a "suspense"-like UI, where the UI doesn’t show until all data is loaded.
@Riverpod(keepAlive: true)
Future<PostModelEntity?> postService(Ref ref, PostId postId) async {
  final post = await ref.watch(getPostProvider(postId).future);

  if (post == null) return null;

  final (avatar, images, commentsAvatars) =
      await (
        ref.watch(avatarServiceProvider(post.authorName).future),
        Future.wait(
          // TODO(MattsAttack): Could we grab all images with a single call?
          post.imageIds.map((image) => ref.watch(imageProvider(image).future)),
        ),
        Future.wait(
          post.comments.map(
            (comment) =>
                ref.watch(avatarServiceProvider(comment.authorName).future),
          ),
        ),
      ).wait;

  if (post.comments.length != commentsAvatars.length) {
    throw Exception('The number of comments and comment avatars do not match.');
  }

  final commentsWithAvatars = post.comments.zip(commentsAvatars);
  final comments =
      [
        for (final (comment, commentAvatar) in commentsWithAvatars)
          CommentEntity(
            comment: comment.comment,
            avatar: commentAvatar,
            authorName: comment.authorName,
            timestamp: comment.timestamp,
          ),
      ].lockUnsafe;

  return PostModelEntity(
    id: post.id,
    authorName: post.authorName,
    avatar: avatar,
    timestamp: post.timestamp,
    headline: post.headline,
    description: post.description,
    images: images.lockUnsafe,
    likes: post.likes,
    comments: comments,
  );
}

/// Provide the values of a single post.
///
/// This should be set in the overrides of a parent [ProviderScope].
@Riverpod(dependencies: [])
PostModelEntity currentPost(Ref ref) {
  throw UnimplementedError();
}

/// Provide the ID of the [currentPost].
@Riverpod(dependencies: [currentPost])
PostId currentPostId(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.id));
}

/// Provide the name of the author of the [currentPost].
@Riverpod(dependencies: [currentPost])
String currentPostAuthorName(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.authorName));
}

/// Provide the timestamp of the [currentPost].
@Riverpod(dependencies: [currentPost])
DateTime currentPostTimestamp(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.timestamp));
}

/// Provide the headline of the [currentPost].
@Riverpod(dependencies: [currentPost])
String currentPostHeadline(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.headline));
}

/// Provide the description of the [currentPost].
@Riverpod(dependencies: [currentPost])
String currentPostDescription(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.description));
}

/// Provide the avatar of the [currentPost].
@Riverpod(dependencies: [currentPost])
Uint8List currentPostAvatar(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.avatar));
}

/// Provide the images of the [currentPost].
@Riverpod(dependencies: [currentPost])
IList<Uint8List> currentPostImages(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.images));
}

/// Provide the likes of the [currentPost].
@Riverpod(dependencies: [currentPost])
IList<UserId> currentPostLikes(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.likes));
}
