/// This library contains a data class representing a user's settings.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

/// {@template nexus.features.settings.domain.settings_model}
/// Represent the user's settings.
/// {@endtemplate}
@freezed
@immutable
class SettingsModel with _$SettingsModel {
  /// {@macro nexus.features.settings.domain.settings_model}
  ///
  /// Create a new, immutable instance of [SettingsModel].
  const factory SettingsModel({required ThemeMode themeMode}) = _SettingsModel;

  /// Deserialize a JSON [Map] into a new, immutable instance of [SettingsModel].
  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
}
