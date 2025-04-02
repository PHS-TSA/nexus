/// This library contains a data class representing a singular post.
library;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/json.dart';
import '../../auth/domain/user.dart';
import 'post_id.dart';

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

    /// Contains ID of image in bucket
    @JsonKey(name: 'imageID') required IList<String> imageIds,
  }) = _PostEntity;

  factory PostEntity.fromJson(Map<String, dynamic> json) =>
      _$PostEntityFromJson(json);
}

/// A list of users who like a post.
typedef Likes = IList<UserId>;
