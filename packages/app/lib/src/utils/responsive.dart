import 'package:flutter/material.dart';

/// Extension on [BuildContext] for responsive design.
extension Responsive on BuildContext {
  // cSpell:ignore mobileish
  /// Returns true if the current screen size is mobileish.
  bool get isMobile {
    return MediaQuery.sizeOf(this).width <= 680;
  }
}
