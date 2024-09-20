/// This library provides the app's router to state management.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app/router.dart';

part 'router.g.dart';

/// Get the app's router.
@Riverpod(keepAlive: true)
Raw<AppRouter> router(RouterRef ref) {
  return AppRouter();
}
