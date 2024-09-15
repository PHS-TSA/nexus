import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../gen/assets.gen.dart';
import '../domain/feed_entity.dart';
import '../domain/feed_model.dart';
import '../domain/post_entity.dart';

part 'feed_service.g.dart';

@riverpod
class FeedService extends _$FeedService {
  @override
  FeedModel build(FeedEntity feed) {
    return FeedModel(
      posts: List.generate(
        100,
        // TODO(MattsAttack): For local vs world sorting have a conditional to determine sorting method.
        (index) => PostEntity(
          image: switch (feed) {
            LocalFeed _ || WorldFeed _ => Assets.pictures.kid.provider(),
          },
          body: 'This works (#$index)',
        ),
      ),
    );
  }
}
