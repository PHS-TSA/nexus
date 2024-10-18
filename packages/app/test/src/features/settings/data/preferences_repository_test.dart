import 'package:appwrite/appwrite.dart';
import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus/src/features/settings/application/settings_service.dart';
import 'package:nexus/src/features/settings/data/preferences_repository.dart';
import 'package:nexus/src/utils/api.dart' show clientProvider;

import '../../../../helpers/mocks.dart';
import '../../../../helpers/riverpod.dart';

void main() {
  setUpAll(registerFallbacks);

  group('PreferencesRepository', () {
    test('should update the theme mode', () async {
      // Arrange
      final client = MockClient()
        ..mockCall(
          path: any(named: '/account/prefs'),
          response: Response(data: <String, Object?>{}),
        );

      final container = createContainer(
        overrides: [
          clientProvider.overrideWithValue(client),
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
      final client = MockClient()
        ..mockCall(
          path: any(named: '/account/prefs'),
          response: Response(data: <String, Object?>{}),
        );

      final container = createContainer(
        overrides: [
          clientProvider.overrideWithValue(client),
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
    test('should throw an error if Account is not provided', () {
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
