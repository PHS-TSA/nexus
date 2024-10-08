import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Like extends StatelessWidget {
  const Like({super.key, this.onPressed});

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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
  }
}
