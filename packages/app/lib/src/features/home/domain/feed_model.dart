/// This library contains a data class for a feed of posts.
library;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'post_id.dart';

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
    /// The IDs of the posts in the feed.
    required IList<PostId> ids,

    /// The database pagination cursor position.
    required PostId? cursorPos,
  }) = _FeedModel;
}
