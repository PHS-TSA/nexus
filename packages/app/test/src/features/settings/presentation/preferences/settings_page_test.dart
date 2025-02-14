import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_checks/flutter_checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus/src/features/settings/application/settings_service.dart';
import 'package:nexus/src/features/settings/data/preferences_repository.dart';
import 'package:nexus/src/features/settings/domain/settings_model.dart';
import 'package:nexus/src/features/settings/presentation/preferences/settings_page.dart';

import '../../../../../helpers/accessibility.dart';
import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/pump_app.dart';

void main() {
  group('SettingsPage', () {
    testWidgets('changing the dropdown value should save the theme', (
      tester,
    ) async {
      final mockSharedPreferences = MockSharedPreferences();

      final darkMode = json.encode(
        const SettingsModel(themeMode: ThemeMode.dark).toJson(),
      );

      when(
        () => mockSharedPreferences.setString('prefs', darkMode),
      ).thenAnswer((_) async {});

      when(() => mockSharedPreferences.getString('prefs')).thenReturn(darkMode);

      await tester.pumpApp(
        const Material(child: SettingsPage()),
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
          initialSettingsProvider.overrideWithValue(defaultSettings),
        ],
      );

      await tester.tap(find.byType(DropdownMenu<ThemeMode>));
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('Dark'));
      await tester.pumpAndSettle();

      check(find.text('Dark Theme')).findsOne();

      verify(
        () => mockSharedPreferences.setString('prefs', darkMode),
      ).called(1);
    });

    testAccessibilityGuidelines(
      const Material(child: SettingsPage()),
      overrides: [
        sharedPreferencesProvider.overrideWithValue(MockSharedPreferences()),
        initialSettingsProvider.overrideWithValue(defaultSettings),
      ],
    );
  });
}
