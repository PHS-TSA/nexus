/// This library provides a service to handle user authentication.
library;

import 'package:appwrite/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';

part 'auth_service.g.dart';

/// Provides method a user?
@riverpod
base class AuthService extends _$AuthService {
  @override
  FutureOr<User?> build() async {
    final authRepo = ref.watch(authRepositoryProvider);

    return await authRepo.checkUserAuth();
  }

  // Methods on notifiers should be small wrappers around a repo that cache the current values.
  // Use this createUser method instead of the method in auth_repository as this one saves it to the provider

  // @lishaduck does this set the current user to the user created in the createUser method? It shouldn't unless we change the implementation to have sign up auto log them in
  Future<void> createUser(String name, String email, String password) async {
    await ref.read(authRepositoryProvider).createUser(name, email, password);

    ref.invalidateSelf();

    // Awaits the rebuild.
    await future;
  }

  //TODO create other functions for auth_service that relate to auth_repository like above

  Future<void> loginUser(String email, String password) async {
    await ref.read(authRepositoryProvider).loginUser(email, password);

    ref.invalidateSelf();

    // Awaits the rebuild.
    await future;
  }

  //   Future<void> logoutUser() async {
  //   authRepo.
  //   await account.deleteSession(sessionId: 'current');
  //   print('User Logged out');
  // }
}
