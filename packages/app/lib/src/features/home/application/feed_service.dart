import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../gen/assets.gen.dart';
import '../domain/feed_entity.dart';
import '../domain/feed_model.dart';
import '../domain/post_entity.dart';

part 'feed_service.g.dart';

/// Provide the values of a feed.
@riverpod //You can only change state inside of this class
base class FeedService extends _$FeedService {
  @override
  FutureOr<FeedModel> build(FeedEntity feed, int page) {
    return FeedModel(
      posts: List.generate(
        20,
        // TODO(MattsAttack): For local vs world sorting have a conditional to determine sorting method.
        (index) => PostEntity(
          image: switch (feed) {
            LocalFeed _ || WorldFeed _ => Assets.pictures.kid.provider(),
          },
          body: 'This works (#${page * 20 + index})',
        ),
      ),
      cursorPos: '',
    );
  }

  /// Replace the current posts with newly generated posts.
  Future<void> replacePosts(List<PostEntity> newPosts) async {
    final currentState = state.valueOrNull;

    if (currentState == null) return;

    state = AsyncData(
      currentState.copyWith(
        posts: [
          // Spread the new list into the generated list.
          ...currentState.posts,
          ...newPosts,
        ],
      ),
    );
  }
}
