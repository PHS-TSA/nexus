/// This library contains a data class for a feed of posts.
library;

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'post_entity.dart';

part 'feed_model.freezed.dart';

/// {@template nexus.features.home.domain.feed}
/// Represent a feed of posts.
/// {@endtemplate}
@immutable
@freezed
sealed class FeedModel with _$FeedModel {
  /// {@macro nexus.features.home.domain.feed}
  ///
  /// Create a new, immutable instance of [FeedModel].
  const factory FeedModel({
    /// The posts in the feed.
    required List<PostEntity> posts,
    required List<String> ids,

    /// The database pagination cursor position.
    required String? cursorPos,
  }) = _FeedModel;
}
