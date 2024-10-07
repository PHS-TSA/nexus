/// This library provides a service to handle user authentication.
library;

import 'package:appwrite/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';

part 'auth_service.g.dart';

// Service files are used to cache data to reduce api calls and make the software faster

/// Provides method a user?
@Riverpod(keepAlive: true)
base class AuthService extends _$AuthService {
  @override
  FutureOr<User?> build() async {
    final authRepo = ref.watch(authRepositoryProvider);

    return await authRepo.checkUserAuth();
  }

  // Methods on notifiers should be small wrappers around a repo that cache the current values.

  /// Creates a new user in the Appwrite database.
  Future<void> createUser(String name, String email, String password) async {
    // Set the state to loading.
    state = const AsyncValue.loading();

    // Try to create the user. If it fails, set the state to error.
    // Note that expected errors are already converted to null.
    state = await AsyncValue.guard(
      () async => await ref
          .read(authRepositoryProvider)
          .createUser(name, email, password),
    );
  }

  /// Logs in the user
  Future<void> logInUser(String email, String password) async {
    await ref.read(authRepositoryProvider).logInUser(email, password);

    // Invalidates the current state and awaits the rebuild.
    ref.invalidateSelf();
    await future;
  }

  /// Log outs the user
  Future<void> logOutUser() async {
    await ref.read(authRepositoryProvider).logOutUser();

    state = const AsyncValue.data(null);
  }
}

// How to get values from service provider:
// ```dart
// return ref.watch(authServiceProvider).requireValue;
// ```
