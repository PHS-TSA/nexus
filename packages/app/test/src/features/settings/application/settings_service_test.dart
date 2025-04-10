import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_hub/src/features/settings/application/settings_service.dart';
import 'package:harvest_hub/src/features/settings/data/preferences_repository.dart';
import 'package:harvest_hub/src/features/settings/domain/settings_model.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/riverpod.dart';

void main() {
  group('SettingsService', () {
    test('should update the theme mode', () async {
      final mockSharedPreferences = MockSharedPreferences();
      when(
        () => mockSharedPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);

      final container = createContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
          initialSettingsProvider.overrideWithValue(defaultSettings),
        ],
      );

      final model = container.read(settingsServiceProvider);
      final notifier = container.read(settingsServiceProvider.notifier);

      check(model.themeMode).equals(ThemeMode.system);

      await notifier.updateThemeMode(ThemeMode.light);

      final newModel = container.read(settingsServiceProvider);
      check(newModel.themeMode).equals(ThemeMode.light);
    });
  });

  group('initialSettings', () {
    test('should throw an error if initialSettings are not provided', () {
      // Arrange
      final container = createContainer();

      // Act
      SettingsModel call() => container.read(initialSettingsProvider);

      // Assert
      check(call).throws<UnimplementedError>();
    });
  });
}
