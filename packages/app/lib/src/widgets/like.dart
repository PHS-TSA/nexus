import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Widget for like button
class Like extends StatelessWidget {
  //// Constructor for Like Widget
  const Like({super.key, this.onPressed});

  /// Method for liking posts. NEEDS IMPLEMENTATION
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Column(
        children: [
          Icon(Icons.lightbulb),
          Icon(Icons.thumb_up),
        ],
      ),
    );
  }

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
  }
  // coverage:ignore-end
}
