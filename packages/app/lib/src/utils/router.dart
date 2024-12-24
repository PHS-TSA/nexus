/// This library provides the app's router to state management.
library;

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app/router.dart';

part 'router.g.dart';

/// Get the app's router.
@Riverpod(keepAlive: true)
Raw<AppRouter> router(Ref ref) {
  return AppRouter(ref);
}
