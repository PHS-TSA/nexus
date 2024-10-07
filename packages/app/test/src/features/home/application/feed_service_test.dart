import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
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
          .equals(pageSize);

      // Act
      final postsToAdd = List.generate(
        pageSize, //@lishaduck implemented a fix here but you may want to review
        (index) => PostEntity(
          image: null,
          body: 'body',
          headline: 'headline',
          author: const UserId('1234'),
          location: const LatLng(0, 0),
          timestamp: DateTime(2024, 10, 7, 13, 53),
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
          .equals(pageSize * 2);
    });
  });
}
