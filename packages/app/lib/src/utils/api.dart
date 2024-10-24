/// This library contains utilities for the Appwrite API.
///
/// {@category Server}
library;

// cSpell:ignore realtime

import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../env/env.dart';
import '../app/bootstrap.dart';

part 'api.g.dart';

/// Get the Appwrite client.
@Riverpod(keepAlive: true)
Client client(ClientRef ref) {
  throw UnimplementedError();
}

/// Create an Appwrite API [Client].
///
/// > [!WARNING]
/// >
/// > Do not use this!
/// > This is used to get around a lack of Riverpod while [Bootstrap]ping.
/// > Use [clientProvider] instead.
Client createClient() {
  return Client()
      .setEndpoint(Env.apiEndpoint)
      .setProject(Env.projectId)
      .setSelfSigned(status: Env.selfSigned);
}

/// Get the Appwrite session for the current account.
@Riverpod(keepAlive: true)
Account accounts(AccountsRef ref) {
  final client = ref.watch(clientProvider);

  return Account(client);
}

/// Get the Appwrite databases.
@Riverpod(keepAlive: true)
Databases databases(DatabasesRef ref) {
  final client = ref.watch(clientProvider);

  return Databases(client);
}

/// Get the Appwrite avatars.
@Riverpod(keepAlive: true)
Avatars avatars(AvatarsRef ref) {
  final client = ref.watch(clientProvider);

  return Avatars(client);
}

/// Get the Appwrite realtime subscriptions.
@Riverpod(keepAlive: true)
Realtime realtime(RealtimeRef ref) {
  final client = ref.watch(clientProvider);

  return Realtime(client);
}
