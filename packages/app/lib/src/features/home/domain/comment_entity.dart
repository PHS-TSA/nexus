import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_entity.freezed.dart';

/// {@template nexus.features.home.domain.comment_entity}
/// Represent a comment on a post.
///
///
/// {@endtemplate}
@immutable
@freezed
sealed class CommentEntity with _$CommentEntity {
  /// {@macro nexus.features.home.domain.comment_entity}
  ///
  /// Create a new, immutable instance of [CommentEntity].
  const factory CommentEntity({
    /// The textual content of the comment.
    required String comment,

    /// The author of the comment’s “initials picture”.
    required Uint8List avatar,

    /// The author of the comment’s display name.
    required String authorName,

    /// When the comment was created.
    required DateTime timestamp,
  }) = _CommentEntity;

  const CommentEntity._();

  @override
  String toString() {
    return 'CommentEntity{comment: $comment, avatar: Uint8List(${avatar.length}), authorName: $authorName, timestamp: $timestamp}';
  }
}
