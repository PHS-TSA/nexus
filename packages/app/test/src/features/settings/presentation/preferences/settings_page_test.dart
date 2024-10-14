import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_checks/flutter_checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/src/features/settings/application/settings_service.dart';
import 'package:nexus/src/features/settings/data/preferences_repository.dart';
import 'package:nexus/src/features/settings/presentation/preferences/settings_page.dart';

import '../../../../../helpers/accessibility.dart';
import '../../../../../helpers/pump_app.dart';

void main() {
  group('SettingsPage', () {
    testWidgets('changing the dropdown value should save the theme',
        (tester) async {
      await tester.pumpApp(
        const Material(child: SettingsPage()),
        overrides: [
          initialSettingsProvider.overrideWithValue(defaultSettings),
        ],
      );

      await tester.tap(find.byType(DropdownButton<ThemeMode>));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey(ThemeMode.dark)));
      await tester.pumpAndSettle();

      check(find.text('Dark Theme')).findsOne();
    });

    testAccessibilityGuidelines(
      const Material(child: SettingsPage()),
      overrides: [
        initialSettingsProvider.overrideWithValue(defaultSettings),
      ],
    );
  });
}
