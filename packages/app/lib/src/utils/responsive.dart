import 'package:flutter/material.dart';

import 'enum_index_ordering.dart';

/// Extension on [BuildContext] for responsive design.
extension Responsive on BuildContext {
  /// Returns the current [MaterialWindowSizeClass] based on the screen width.
  MaterialWindowSizeClass get sizeClass {
    return switch (MediaQuery.sizeOf(this).width) {
      < 600 => MaterialWindowSizeClass.compact,
      < 840 => MaterialWindowSizeClass.medium,
      < 1200 => MaterialWindowSizeClass.expanded,
      < 1600 => MaterialWindowSizeClass.large,
      _ => MaterialWindowSizeClass.extraLarge,
    };
  }
}

/// A [Material Design window size class](https://m3.material.io/foundations/layout/applying-layout/window-size-classes).
enum MaterialWindowSizeClass with EnumIndexOrdering {
  /// A phone in portrait mode.
  compact,

  /// A tablet in portrait mode.
  medium,

  /// A phone or tablet in landscape mode, or a non-maximized desktop.
  expanded,

  /// A maximized desktop.
  large,

  /// An ultra-wide desktop.
  extraLarge,
}
