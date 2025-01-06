import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Creates a [GlobalKey] that will be disposed automatically.
///
/// See also:
/// - [GlobalKey]
GlobalKey<T> useGlobalKey<T extends State>() {
  return useMemoized(GlobalKey<T>.new);
}

/// Creates a [TapGestureRecognizer] that will be disposed automatically.
///
/// See also:
/// - [TapGestureRecognizer]
TapGestureRecognizer useTapGestureRecognizer({
  VoidCallback? onTap,
  String? debugLabel,
  List<Object?>? keys,
}) {
  return use(_TapGestureRecognizerHook(onTap: onTap, keys: keys));
}

class _TapGestureRecognizerHook extends Hook<TapGestureRecognizer> {
  const _TapGestureRecognizerHook({
    this.onTap,
    super.keys,
  });

  final VoidCallback? onTap;

  @override
  _TapGestureRecognizerHookState createState() =>
      _TapGestureRecognizerHookState();

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
  }
  // coverage:ignore-end
}

class _TapGestureRecognizerHookState
    extends HookState<TapGestureRecognizer, _TapGestureRecognizerHook> {
  late final TapGestureRecognizer recognizer;

  @override
  void initHook() {
    super.initHook();
    recognizer = TapGestureRecognizer();
    recognizer.onTap = hook.onTap;
  }

  @override
  TapGestureRecognizer build(BuildContext context) {
    return recognizer..onTap = hook.onTap;
  }

  @override
  void dispose() {
    recognizer.dispose();
    super.dispose();
  }

  @override
  bool get debugHasShortDescription => false;

  @override
  String get debugLabel => 'useTapGestureRecognizer';

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<TapGestureRecognizer>('recognizer', recognizer),
    );
  }
  // coverage:ignore-end
}
