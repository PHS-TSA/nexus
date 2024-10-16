/// This library contains an enum for feed ranking and sorting algorithms.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_entity.freezed.dart';

/// A type of feed.
@immutable
@freezed
sealed class FeedEntity with _$FeedEntity {
  /// A feed that features content nearby the user.
  const factory FeedEntity.local(double lat, double lng) = LocalFeed;

  /// A feed that features content from around the world.
  const factory FeedEntity.world() = WorldFeed;
}
