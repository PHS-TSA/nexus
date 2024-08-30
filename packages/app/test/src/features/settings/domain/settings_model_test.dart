import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/src/features/settings/domain/settings_model.dart';

void main() {
  group('SettingsModel', () {
    test('should be constant and support value equality', () {
      // Arrange
      const model = SettingsModel(themeMode: ThemeMode.system);

      // Act
      final newModel = model.copyWith(themeMode: ThemeMode.system);

      // Assert
      check(newModel).equals(model);
    });

    test('should support serialization to and from JSON', () {
      // Arrange
      const model = SettingsModel(themeMode: ThemeMode.system);

      // Act
      final json = model.toJson();
      final newModel = SettingsModel.fromJson(json);

      // Assert
      check(newModel).equals(model);
    });
  });
}
