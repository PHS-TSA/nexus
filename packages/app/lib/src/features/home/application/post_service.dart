library;

import 'dart:typed_data';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/domain/user.dart';
import '../domain/post_entity.dart';
import '../domain/post_model_entity.dart';
import 'avatar_service.dart';
import 'feed_service.dart';

part 'post_service.g.dart';

@Riverpod(keepAlive: true)
Future<PostModelEntity?> postService(Ref ref, PostId postId) async {
  final post = ref.watch(singlePostProvider(postId));

  if (post == null) return null;

  final (avatar, images) =
      await (
        ref.watch(avatarServiceProvider(post.authorName).future),
        Future.wait(
          post.imageIds.map((image) => ref.watch(imageProvider(image).future)),
        ),
      ).wait;

  return PostModelEntity(
    id: post.id,
    authorName: post.authorName,
    avatar: avatar,
    timestamp: post.timestamp,
    headline: post.headline,
    description: post.description,
    images: images.lockUnsafe,
    likes: post.likes,
  );
}

@Riverpod(dependencies: [])
PostModelEntity currentPost(Ref ref) {
  throw UnimplementedError();
}

@Riverpod(dependencies: [currentPost])
PostId currentPostId(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.id));
}

@Riverpod(dependencies: [currentPost])
String currentPostAuthorName(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.authorName));
}

@Riverpod(dependencies: [currentPost])
DateTime currentPostTimestamp(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.timestamp));
}

@Riverpod(dependencies: [currentPost])
String currentPostHeadline(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.headline));
}

@Riverpod(dependencies: [currentPost])
String currentPostDescription(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.description));
}

@Riverpod(dependencies: [currentPost])
Uint8List currentPostAvatar(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.avatar));
}

@Riverpod(dependencies: [currentPost])
IList<Uint8List> currentPostImages(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.images));
}

@Riverpod(dependencies: [currentPost])
IList<UserId> currentPostLikes(Ref ref) {
  return ref.watch(currentPostProvider.select((value) => value.likes));
}
