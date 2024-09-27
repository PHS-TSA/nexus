/// This library provides a service to handle user authentication.
library;

import 'package:appwrite/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';

part 'auth_service.g.dart';

/// Provide the values of a feed.
@riverpod
base class AuthService extends _$AuthService {
  @override
  FutureOr<User?> build() async {
    final authRepo = ref.watch(authRepositoryProvider);

    return await authRepo.checkUserAuth();
  }

  // Methods on notifiers should be small wrappers around a repo that cache the current values.
  // Use this createUser method instead of the method in auth_repository as this one saves it to the provider
  Future<void> createUser(String name, String email, String password) async {
    await ref.read(authRepositoryProvider).createUser(name, email, password);

    ref.invalidateSelf();

    // Awaits the rebuild.
    await future;
  }

  //TODO create other functions for auth_service that relate to auth_repository like above

  Future<void> loginUser(String name, String email, String password) async {
    await ref.read(authRepositoryProvider).loginUser(name, email);

    ref.invalidateSelf();

    // Awaits the rebuild.
    await future;
  }
}
