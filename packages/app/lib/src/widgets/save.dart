import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Widget for Save button
class Save extends StatelessWidget {
  /// Constructor for save button
  const Save({super.key, this.onPressed});

  /// Method that runs when pressing save button. Needs implementation
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.bookmark),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
  }
}
