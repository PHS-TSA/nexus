import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_checks/flutter_checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/src/features/home/application/feed_service.dart';
import 'package:nexus/src/features/home/domain/feed_entity.dart';
import 'package:nexus/src/features/home/presentation/home/feed.dart';

import '../../../../../helpers/accessibility.dart';
import '../../../../../helpers/pump_app.dart';

void main() {
  group('Feed', () {
    testWidgets('contains a page of items', (tester) async {
      // Arrange
      const widget = Feed(feed: FeedEntity.local());

      // Act

      // Pumping the widget will run the build method and return the widget that was built.
      await tester.pumpApp(widget);

      // Assert

      // Verify that the widget contains a full page of items.
      check(find.byType(Card)).findsExactly(pageSize);
    });

    testWidgets('handles errors by posting about it', (tester) async {
      // Arrange
      const widget = Feed(feed: FeedEntity.world());

      // Act

      // Pumping the widget will run the build method and return the widget that was built.
      await tester.pumpApp(
        widget,
        // Overrides let you swap out providers with different implementations.
        overrides: [
          feedServiceProvider(const FeedEntity.world(), 1)
              .overrideWith(() => throw UnimplementedError()),
        ],
      );

      // Assert

      // Verify the widget contains an error message.
      check(find.text('UnimplementedError')).findsExactly(pageSize);
    });
  });

  testAccessibilityGuidelines(const Feed(feed: FeedEntity.local()));
}