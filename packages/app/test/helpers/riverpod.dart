/// This library contains utilities for testing with Riverpod.
library;

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' hide isA;
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef Overrides = List<Override>;

/// A testing utility which creates a [ProviderContainer] and automatically
/// disposes it at the end of the test.
ProviderContainer createContainer({
  ProviderContainer? parent,
  Overrides overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}

extension AsyncValueChecks<T> on Subject<AsyncValue<T>> {
  Subject<T> isData() => isA<AsyncData<T>>().has((i) => i.value, 'value');
  Subject<Object> isError() =>
      isA<AsyncError<T>>().has((i) => i.error, 'error');
  void isLoading() => isA<AsyncLoading<T>>();
}
