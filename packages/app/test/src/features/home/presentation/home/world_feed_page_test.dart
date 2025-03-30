import 'package:checks/checks.dart';
import 'package:flutter_checks/flutter_checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_hub/src/features/home/presentation/home/feed.dart';
import 'package:harvest_hub/src/features/home/presentation/home/world_feed_page.dart';

import '../../../../../helpers/accessibility.dart';
import '../../../../../helpers/pump_app.dart';

void main() {
  group('WorldFeedPage', () {
    testWidgets('should display more information', (tester) async {
      // Arrange
      const widget = WorldFeedPage();

      // Act

      // Pumping the widget will run the build method and return the widget that was built.
      await tester.pumpApp(widget);

      // Assert

      // Should display a Feed to the user.
      check(find.byType(Feed)).findsOne();
    });
  });

  testAccessibilityGuidelines(const WorldFeedPage());
}
