import 'dart:typed_data';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../auth/domain/user.dart';
import 'post_entity.dart';
import 'post_id.dart';

part 'post_model_entity.freezed.dart';

/// {@template nexus.features.home.domain.post_model_entity}
/// Represent a post, which is a single item in a feed.
///
/// As opposed to [PostEntity], this is contains the resolved values of a post.
/// {@endtemplate}
@immutable
@freezed
sealed class PostModelEntity with _$PostModelEntity {
  /// {@macro nexus.features.home.domain.post_model_entity}
  ///
  /// Create a new, immutable instance of [PostModelEntity].
  const factory PostModelEntity({
    /// The ID of the post.
    required PostId id,

    /// The author of the post.
    required String authorName,

    /// The author of the post’s “initials picture”.
    required Uint8List avatar,

    /// When the post was created.
    ///
    /// This *should* be in UTC, but as far I as I know, it’s no checked in the backend so who knows?
    required DateTime timestamp,

    /// The title of the post.
    required String headline,

    /// The textual content of the post.
    required String description,

    /// The images in the post.
    ///
    /// This is a list of the raw image data.
    required IList<Uint8List> images,

    /// Who likes this post.
    ///
    /// This is a list of the [UserId]s of users who liked the post.
    required IList<UserId> likes,
  }) = _PostModelEntity;

  const PostModelEntity._();

  @override
  String toString() {
    return 'PostModelEntity(id: $id, authorName: $authorName, timestamp: $timestamp, headline: $headline, description: $description, likes: $likes)';
  }
}
