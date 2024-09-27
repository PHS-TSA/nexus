import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/api.dart';

part 'auth_repository.g.dart';

abstract interface class AuthRepository {
  Future<String> createUser(String name, String email, String password);
  Future<bool> loginUser(String email, String password);
  Future<void> logoutUser();
  Future<User?> checkUserAuth();
}

//Create a user account
class _AppwriteAuthRepository implements AuthRepository {
  const _AppwriteAuthRepository(this.account);

  final Account account;

// Register the user(Sign up)
  @override
  Future<String> createUser(String name, String email, String password) async {
    try {
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      print('New user created!');
      return 'success';
    } on AppwriteException catch (e) {
      return e.message.toString();
      print(e);
    }
  }

// Login the User

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final user = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      print('User logged in');
      return 'success';
    } catch (e) {
      print(e);
      return;
    }
  }

  @override
  Future<void> logoutUser() async {
    await account.deleteSession(sessionId: 'current');
    print('User Logged out');
  }

  // check User is authenticated or not
  @override
  Future<User?> checkUserAuth() async {
    try {
      print('Trying to checkUserAuth func');
      //Checks if session exist or not
      final user = await account.get();
      //If exist return true
      return user;
    } on AppwriteException catch (e) {
      print(e);
      return null;
    }
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final accountService = ref.watch(accountsProvider);

  return _AppwriteAuthRepository(accountService);
}
