import 'dart:typed_data';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../auth/domain/user.dart';
import 'post_entity.dart';

part 'post_model_entity.freezed.dart';

@immutable
@freezed
sealed class PostModelEntity with _$PostModelEntity {
  const factory PostModelEntity({
    required PostId id,
    required String authorName,
    required Uint8List avatar,
    required DateTime timestamp,
    required String headline,
    required String description,
    required IList<Uint8List> images,
    required IList<UserId> likes,
  }) = _PostModelEntity;

  const PostModelEntity._();

  @override
  String toString() {
    return 'PostModelEntity(id: $id, authorName: $authorName, timestamp: $timestamp, headline: $headline, description: $description, likes: $likes)';
  }
}
