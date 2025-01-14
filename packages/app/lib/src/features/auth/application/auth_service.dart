/// This library provides a service to handle user authentication.
library;

import 'package:appwrite/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';
import '../domain/user.dart';

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

/// Get the current user's name.
///
/// Named as such to prevent a naming conflict with riverpod.
@riverpod
String? userName(Ref ref) => ref.watch(authServiceProvider).requireValue?.name;

/// Get the current user's email address.
@riverpod
String? email(Ref ref) => ref.watch(authServiceProvider).requireValue?.email;

/// Get the current user's id.
@riverpod
UserId? id(Ref ref) {
  final appwriteId = ref.watch(authServiceProvider).requireValue?.$id;

  return appwriteId != null ? UserId(appwriteId) : null;
}
