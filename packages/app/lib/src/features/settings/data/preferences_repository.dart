/// This library provides the ability to fetch and persist the user's settings.
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/settings_model.dart';

part 'preferences_repository.g.dart';

/// Provide access to the user's settings.
abstract interface class PreferencesRepository {
  /// Load the user's settings from a local database or the internet.
  Future<SettingsModel> load();

  /// Persist the user's settings to a local database or the internet.
  Future<void> setString(String key, String value);
}

final class _SharedPreferencesRepository implements PreferencesRepository {
  _SharedPreferencesRepository(this.prefs);

  final SharedPreferencesWithCache prefs;

  @override
  Future<SettingsModel> load() => loadSettings(prefs);

  @override
  Future<void> setString(String key, String value) async =>
      await prefs.setString(key, value);
}

/// Get the user's preferences.
@Riverpod(keepAlive: true)
PreferencesRepository preferencesRepository(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return _SharedPreferencesRepository(prefs);
}

/// Load a from a local database.
Future<SettingsModel> loadSettings(SharedPreferencesWithCache prefs) async {
  final data = prefs.getString('prefs');
  final Object? decoded = data == null ? null : json.decode(data);

  return decoded is Map<String, Object?>
      ? SettingsModel.fromJson(decoded)
      : defaultSettings;
}

/// Get a [SharedPreferencesWithCache] instance.
@Riverpod(keepAlive: true)
SharedPreferencesWithCache sharedPreferences(Ref ref) {
  throw UnimplementedError();
}

/// The default settings, in case the user has none or they are corrupted.
const defaultSettings = SettingsModel(themeMode: ThemeMode.system);
