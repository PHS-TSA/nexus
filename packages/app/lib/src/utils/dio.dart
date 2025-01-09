/// This library provides the app's http client to state management.
library;

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio.g.dart';

/// Allow overriding the default dio adapter in tests.
@visibleForTesting
@Riverpod(keepAlive: true)
HttpClientAdapter? dioAdapter(Ref ref) {
  return null;
}

/// Get the app's router.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final client = Dio();

  final testAdapter = ref.watch(dioAdapterProvider);

  if (testAdapter != null) {
    client.httpClientAdapter = testAdapter;
  }

  return client;
}
