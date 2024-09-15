import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_entity.freezed.dart';

@immutable
@freezed
sealed class FeedEntity with _$FeedEntity {
  const factory FeedEntity.local() = LocalFeed;
  const factory FeedEntity.world() = WorldFeed;
}
