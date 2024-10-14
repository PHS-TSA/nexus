/// This library contains a data class representing a singular post.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_entity.freezed.dart';
part 'post_entity.g.dart';

extension type const UserId(String id) {
  factory UserId.fromJson(String id) => UserId(id);

  String toJson() => id;
}

extension type const BucketFile(String id) {
  factory BucketFile.fromJson(String id) => BucketFile(id);

  String toJson() => id;
}

/// {@template our_democracy.features.home.domain.post}
/// Represent a post, which is a single item in a feed.
/// {@endtemplate}
@immutable
@freezed
sealed class PostEntity with _$PostEntity {
  /// {@macro our_democracy.features.home.domain.post}
  ///
  /// Create a new, immutable instance of [PostEntity].
  const factory PostEntity({
    /// The title of the post.
    required String headline,

    /// The textual content of the post.
    required String description,

    /// The author of the post.
    required UserId author,

    ///
    required double lat,

    ///
    required double lng,

    ///
    required DateTime timestamp,

    /// An optional media to display alongside the post.
    BucketFile? image,

    //TODO when implementing likes add numberOfLikes here
  }) = _PostEntity;

  factory PostEntity.fromJson(Map<String, dynamic> json) =>
      _$PostEntityFromJson(json);
}
