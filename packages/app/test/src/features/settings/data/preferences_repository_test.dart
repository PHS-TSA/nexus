import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_hub/src/features/settings/application/settings_service.dart';
import 'package:harvest_hub/src/features/settings/data/preferences_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/riverpod.dart';

void main() {
  group('PreferencesRepository', () {
    test('should update the theme mode', () async {
      // Arrange
      final mockSharedPreferences = MockSharedPreferences();

      final container = createContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
          initialSettingsProvider.overrideWithValue(defaultSettings),
        ],
      );

      // Act
      final repo = container.read(preferencesRepositoryProvider);
      final settings = await repo.load();

      // Assert
      check(settings.themeMode).equals(ThemeMode.system);
    });

    test('should decode the theme mode', () async {
      // Arrange
      final mockSharedPreferences = MockSharedPreferences();

      when(
        () => mockSharedPreferences.getString('prefs'),
      ).thenReturn('{"themeMode":"dark"}');

      final container = createContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
          initialSettingsProvider.overrideWithValue(defaultSettings),
        ],
      );

      // Act
      final repo = container.read(preferencesRepositoryProvider);
      final settings = await repo.load();

      // Assert
      check(settings.themeMode).equals(ThemeMode.dark);
    });
  });

  group('sharedPreferences', () {
    test('should throw an error if SharedPreferences is not provided', () {
      // Arrange
      final container = createContainer();

      // Act
      PreferencesRepository call() =>
          container.read(preferencesRepositoryProvider);

      // Assert
      check(call).throws<UnimplementedError>();
    });
  });
}
