import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_checks/flutter_checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_hub/src/features/home/data/post_repository.dart';
import 'package:harvest_hub/src/features/home/domain/feed_entity.dart';
import 'package:harvest_hub/src/features/home/presentation/home/feed.dart';

import '../../../../../helpers/accessibility.dart';
import '../../../../../helpers/pump_app.dart';

void main() {
  group('Feed', () {
    testWidgets('contains a page of items', (tester) async {
      // Arrange
      const widget = Feed(feed: FeedEntity.local(0, 0));

      // Act

      // Pumping the widget will run the build method and return the widget that was built.
      await tester.pumpApp(widget);

      // Assert

      // Verify that the widget contains a full page of items.
      check(find.byType(Card)).findsExactly(PostRepository.pageSize);
    });

    testWidgets('handles errors by posting about it', (tester) async {
      // Arrange
      const widget = Feed(feed: FeedEntity.world());

      // Act

      // Pumping the widget will run the build method and return the widget that was built.
      await tester.pumpApp(widget);

      // Assert

      // Verify the widget contains an error message.
      check(
        find.text('UnimplementedError'),
      ).findsExactly(PostRepository.pageSize);
    });
  });

  testAccessibilityGuidelines(const Feed(feed: FeedEntity.local(0, 0)));
}
