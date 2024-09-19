import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_entity.freezed.dart';

@immutable
@freezed
sealed class PostEntity with _$PostEntity {
  const factory PostEntity({
    required String body,
    required ImageProvider? image,
  }) = _PostEntity;
}
