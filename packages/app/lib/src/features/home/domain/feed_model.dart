import 'package:freezed_annotation/freezed_annotation.dart';

import 'post_entity.dart';

part 'feed_model.freezed.dart';

@immutable
@freezed
sealed class FeedModel with _$FeedModel {
  const factory FeedModel({
    required List<PostEntity> posts,
  }) = _FeedModel;
}
