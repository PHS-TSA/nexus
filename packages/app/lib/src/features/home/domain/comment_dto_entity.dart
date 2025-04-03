import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/json.dart';
import '../../auth/domain/user.dart';

part 'comment_dto_entity.freezed.dart';
part 'comment_dto_entity.g.dart';

/// {@template nexus.features.home.domain.comment_dto_entity}
/// Represent a comment on a post.
/// {@endtemplate}
@immutable
@freezed
sealed class CommentDtoEntity with _$CommentDtoEntity {
  /// {@macro nexus.features.home.domain.comment_dto_entity}
  ///
  /// Create a new, immutable instance of [CommentDtoEntity].
  const factory CommentDtoEntity({
    /// The textual content of the comment.
    required String comment,

    /// The [UserId] of the author of the comment.
    required UserId author,

    /// The author of the comment’s display name.
    required String authorName,

    /// When the comment was created.
    @DataTimeJsonConverter() required DateTime timestamp,
  }) = _CommentDtoEntity;

  /// Deserialize a JSON [Map] into a new, immutable instance of [CommentDtoEntity].
  factory CommentDtoEntity.fromJson(Map<String, dynamic> json) =>
      _$CommentDtoEntityFromJson(json);
}
