/// This library provides the ability to fetch and persist the user's settings.
library;

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/api.dart';
import '../domain/settings_model.dart';

part 'preferences_repository.g.dart';

/// Provide access to the user's settings.
abstract interface class PreferencesRepository {
  /// Load the user's settings from a local database or the internet.
  Future<SettingsModel> load();

  /// Persist the user's settings to a local database or the internet.
  Future<void> update(SettingsModel newPrefs);
}

final class _AppwritePreferencesRepository implements PreferencesRepository {
  _AppwritePreferencesRepository(this.account);

  final Account account;

  @override
  Future<SettingsModel> load() => loadSettings(account);

  @override
  Future<void> update(SettingsModel newPrefs) async =>
      await account.updatePrefs(prefs: newPrefs.toJson());
}

/// Get the user's preferences.
@Riverpod(keepAlive: true)
PreferencesRepository preferencesRepository(PreferencesRepositoryRef ref) {
  final account = ref.watch(accountsProvider);

  return _AppwritePreferencesRepository(account);
}

/// Load preferences from Appwrite.
///
/// Returns [defaultSettings] if anything goes wrong.
Future<SettingsModel> loadSettings(
  Account account,
) async {
  try {
    final data = await account.getPrefs();

    return SettingsModel.fromJson(data.data);
  } on AppwriteException {
    // TODO: Also handle invalid JSON.
    return defaultSettings;
  } on CheckedFromJsonException {
    return defaultSettings;
  }
}

/// The default settings, in case the user has none or they are corrupted.
const defaultSettings = SettingsModel(themeMode: ThemeMode.system);
