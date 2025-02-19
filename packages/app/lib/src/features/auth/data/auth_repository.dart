/// This library provides authentication fetchers.
library;

import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/api.dart';

part 'auth_repository.g.dart';

/// A repository for authentication.
abstract interface class AuthRepository {
  /// Register the user (sign them up).
  /// Only needed once.
  ///
  /// Throws an [AppwriteException] if
  /// - the user already exists, or
  /// - the password is too weak.
  Future<User?> createUser(String name, String email, String password);

  /// Log the user in.
  ///
  /// Throws an [AppwriteException] if
  /// - the email or password is incorrect.
  Future<Session?> logInUser(String email, String password);

  /// Log the user out.
  Future<void> logOutUser();

  /// Check whether or not the user is authenticated.
  ///
  /// Returns the user if there is an existing session,
  /// otherwise it returns null.
  Future<User?> checkUserAuth();
}

final class _AppwriteAuthRepository implements AuthRepository {
  const _AppwriteAuthRepository(this.account);

  final Account account;

  @override
  Future<User?> createUser(String name, String email, String password) async {
    try {
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      await logInUser(email, password);

      return user;
    } on AppwriteException {
      return null;
    }
  }

  @override
  Future<Session?> logInUser(String email, String password) async {
    try {
      return await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } on AppwriteException catch (e) {
      log('$e');
      return null;
    }
  }

  @override
  Future<void> logOutUser() async {
    await account.deleteSession(sessionId: 'current');
  }

  @override
  Future<User?> checkUserAuth() async {
    try {
      // Checks if a session exists or not.
      // If it exists, return it.
      return await account.get();
    } on AppwriteException {
      return null;
    }
  }
}

/// Get the authentication repository.
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final accountService = ref.watch(accountsProvider);

  return _AppwriteAuthRepository(accountService);
}
