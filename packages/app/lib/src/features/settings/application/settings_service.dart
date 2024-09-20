/// This file provides a service to manage local user settings.
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/preferences_repository.dart';
import '../domain/settings_model.dart';

part 'settings_service.g.dart';

/// A class that many Widgets can interact with to read user settings, update user settings, or listen to user settings changes.
///
/// Services are the part of the application layer that glues repositories from the data layer to Flutter [Widget]s in the presentation layer.
/// The SettingsService uses the PreferencesRepository to store and retrieve user settings.
@Riverpod(keepAlive: true)
class SettingsService extends _$SettingsService {
  @override
  SettingsModel build() {
    return ref.watch(initialSettingsProvider);
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode mode) async {
    // Do not perform any work if new and old ThemeMode are identical
    if (mode == state.themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    state = state.copyWith(themeMode: mode);

    // Persist the changes to a local database or the internet using the PreferencesRepository.
    await ref
        .read(preferencesRepositoryProvider)
        .setString('prefs', json.encode(state));
  }
}

/// Load the user's settings from a local database on startup.
@Riverpod(keepAlive: true)
SettingsModel initialSettings(InitialSettingsRef ref) {
  throw UnimplementedError();
}
