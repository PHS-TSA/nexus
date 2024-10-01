import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/api.dart';

part 'auth_repository.g.dart';

/// A repository for authentication.
abstract interface class AuthRepository {
  /// Register the user (sign them up).
  /// Only needed once.
  Future<User?> createUser(String name, String email, String password);

  /// Log the user in.
  Future<Session?> logInUser(String email, String password);

  /// Log the user out.
  Future<void> logOutUser();

  /// Check whether or not the user is authenticated.
  Future<User?> checkUserAuth();
}

///
final class _AppwriteAuthRepository implements AuthRepository {
  const _AppwriteAuthRepository(this.account);

  final Account account;

  @override
  Future<User?> createUser(String name, String email, String password) async {
    try {
      return await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
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
    } on AppwriteException {
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
AuthRepository authRepository(AuthRepositoryRef ref) {
  final accountService = ref.watch(accountsProvider);

  return _AppwriteAuthRepository(accountService);
}
