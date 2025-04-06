import 'package:checks/checks.dart';
import 'package:flutter_checks/flutter_checks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_hub/src/features/map/presentation/items/map_page.dart';

import '../../../../../helpers/accessibility.dart';
import '../../../../../helpers/pump_app.dart';

void main() {
  group('SampleItemDetailsPage', () {
    testWidgets('should display more information', (tester) async {
      const widget = MapPage();

      // Pump the widget to build it
      // Pumping the widget will run the build method and return the widget
      // that was built
      await tester.pumpApp(widget);

      // Verify that the widget displays the expected information
      check(find.byType(FlutterMap)).findsOne();
    });
  });

  testAccessibilityGuidelines(
    const MapPage(),
    expectedFailures: const ExpectedFailures(
      buttons: true, // `flutter_map` does not have accessible buttons.
    ),
  );
}
