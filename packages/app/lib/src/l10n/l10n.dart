/// This library contains the localization for the app.
library;

import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// Extension for [BuildContext] to access l10n via a getter.
extension AppLocalizationsX on BuildContext {
  /// Get the [AppLocalizations] for this [BuildContext].
  ///
  /// Recommended usage:
  ///
  /// ```dart
  /// import "../../../../l10n/l10n.dart";
  /// ...
  /// final l10n = context.l10n;
  /// ```
  AppLocalizations get l10n => AppLocalizations.of(this);
}
