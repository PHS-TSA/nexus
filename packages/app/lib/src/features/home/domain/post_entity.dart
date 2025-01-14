/// This library contains a data class representing a singular post.
library;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/json.dart';
import '../../auth/domain/user.dart';

part 'post_entity.freezed.dart';
part 'post_entity.g.dart';

/// {@template nexus.features.home.domain.post}
/// Represent a post, which is a single item in a feed.
/// {@endtemplate}
@immutable
@freezed
sealed class PostEntity with _$PostEntity {
  /// {@macro nexus.features.home.domain.post}
  ///
  /// Create a new, immutable instance of [PostEntity].
  const factory PostEntity({
    /// The title of the post.
    required String headline,

    /// The textual content of the post.
    required String description,

    /// The Id of the author of the post.
    required UserId author,

    /// The author of the post’s display name.
    required String authorName,

    /// Salted latitude where the post was made.
    required double lat,

    /// Salted longitude where the post was made.
    required double lng,

    /// When the post was created.
    @DataTimeJsonConverter() required DateTime timestamp,

    /// Who likes this post.
    required Likes likes,

    /// Post ID
    @JsonKey(includeToJson: false) required PostId id,

    /// An optional media to display alongside the post.
    String? image,
  }) = _PostEntity;

  factory PostEntity.fromJson(Map<String, dynamic> json) =>
      _$PostEntityFromJson(json);
}

/// Represent the unique id of a post.
@immutable
extension type const PostId(String id) {
  /// Convert a JSON [String] to a [PostId].
  factory PostId.fromJson(String json) => PostId(json);

  /// Convert a [PostId] to a JSON [String].
  String toJson() => id;
}

/// A list of users who like a post.
typedef Likes = IList<UserId>;
