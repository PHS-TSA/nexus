/// This library contains a data class for a feed of posts.
library;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'post_entity.dart';

part 'feed_model.freezed.dart';

/// {@template our_democracy.features.home.domain.feed}
/// Represent a feed of posts.
/// {@endtemplate}
@immutable
@freezed
sealed class FeedModel with _$FeedModel {
  /// {@macro our_democracy.features.home.domain.feed}
  ///
  /// Create a new, immutable instance of [FeedModel].
  const factory FeedModel({
    /// The posts in the feed.
    required IList<PostEntity> posts,

    /// The database pagination cursor position.
    required String cursorPos,
  }) = _FeedModel;
}
