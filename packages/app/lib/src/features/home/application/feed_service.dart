import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../gen/assets.gen.dart';
import '../domain/feed_entity.dart';
import '../domain/feed_model.dart';
import '../domain/post_entity.dart';

part 'feed_service.g.dart';

@riverpod //You can only change state inside of this class
class FeedService extends _$FeedService {
  @override
  FutureOr<FeedModel> build(FeedEntity feed, int page) {
    return FeedModel(
      posts: List.generate(
        25,
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

  //newPosts is the newly generated posts
  Future<void> replacePosts(List<PostEntity> newPosts) async {
    // :(
    state = await AsyncValue.guard(
      () async => switch (state) {
        AsyncData(:final value) => value.copyWith(
            //This is basically a setter function. We're changing the value here since we cant do it in the other class
            posts: [
              //Combine the new list with the generated list
              ...value.posts,
              ...newPosts,
            ],
          ),
        _ => const FeedModel(posts: [])
      },
    );
  }
}
