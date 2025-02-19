/// This library contains utilities for the Appwrite API.
///
/// {@category Server}
library;

// cSpell:ignore realtime

import 'package:appwrite/appwrite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../env/env.dart';

part 'api.g.dart';

/// Get the Appwrite client.
@Riverpod(keepAlive: true)
Client client(Ref ref) {
  return Client()
      .setEndpoint(Env.apiEndpoint)
      .setProject(Env.projectId)
      .setSelfSigned(status: Env.selfSigned);
}

/// Get the Appwrite session for the current account.
@Riverpod(keepAlive: true)
Account accounts(Ref ref) {
  final client = ref.watch(clientProvider);

  return Account(client);
}

/// Get the Appwrite databases.
@Riverpod(keepAlive: true)
Databases databases(Ref ref) {
  final client = ref.watch(clientProvider);

  return Databases(client);
}

/// Get the Appwrite Buckets
@Riverpod(keepAlive: true)
Storage storage(Ref ref) {
  final client = ref.watch(clientProvider);

  return Storage(client);
}

/// Get the Appwrite avatars.
@Riverpod(keepAlive: true)
Avatars avatars(Ref ref) {
  final client = ref.watch(clientProvider);

  return Avatars(client);
}

/// Get the Appwrite realtime subscriptions.
@Riverpod(keepAlive: true)
Realtime realtime(Ref ref) {
  final client = ref.watch(clientProvider);

  return Realtime(client);
}
