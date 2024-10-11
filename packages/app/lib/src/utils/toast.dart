/// This library contains utilities for using snackbars.
library;

import 'package:flutter/material.dart';

/// Extension method for [BuildContext], for showing uniform snackbars.
extension ShowSnackBar on BuildContext {
  /// Show a [SnackBar] with the given [content].
  ///
  /// ```dart
  /// context.showSnackBar(
  ///   content: Text("Hello, world!"),
  /// );
  /// ```
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar({
    required Widget content,
  }) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: content,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
