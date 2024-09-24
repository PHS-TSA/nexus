import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/src/features/home/application/feed_service.dart';
import 'package:nexus/src/features/home/domain/feed_entity.dart';
import 'package:nexus/src/features/home/domain/post_entity.dart';

import '../../../../helpers/riverpod.dart';

void main() {
  group('Feed service', () {
    test('allows mutating the posts locally', () async {
      // Arrange
      final container = createContainer();
      final feedServiceSubscription = container.listen(
        feedServiceProvider(const FeedEntity.world(), 1),
        (_, __) {},
      );

      // Assert
      check(feedServiceSubscription.read())
          .isData()
          .has((i) => i.posts, 'posts')
          .length
          .equals(20);

      // Act
      final postsToAdd = List.generate(
        20,
        (index) => const PostEntity(
          image: null,
          body: 'body',
        ),
      );

      await container
          .read(feedServiceProvider(const FeedEntity.world(), 1).notifier)
          .addPosts(postsToAdd);

      // Assert
      check(feedServiceSubscription.read())
          .isData()
          .has((i) => i.posts, 'posts')
          .length
          .equals(40);
    });
  });
}
