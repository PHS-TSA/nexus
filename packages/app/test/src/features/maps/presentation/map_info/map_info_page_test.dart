import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_checks/flutter_checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/src/features/map/presentation/items/map_info_page.dart';

import '../../../../../helpers/accessibility.dart';
import '../../../../../helpers/pump_app.dart';

void main() {
  group('SampleItemListPage', () {
    testWidgets('should display information for a single page', (tester) async {
      const widget = MapInfoPage();

      // Pump the widget to build it
      // Pumping the widget will run the build method and return the widget
      // that was built
      await tester.pumpApp(const Material(child: widget));

      // Verify that the widget displays the expected information
      check(find.text('Your coordinates are (0.0000, 0.0000).')).findsOne();
    });

    testAccessibilityGuidelines(
      const Material(
        child: MapInfoPage(),
      ),
    );
  });
}
