import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/api.dart';

part 'auth_repository.g.dart';

abstract interface class AuthRepository {
  Future<String> createUser(String name, String email, String password);
  Future<bool> loginUser(String email, String password);
  Future<void> logoutUser();
  Future<bool> checkUserAuth();
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
  Future<bool> loginUser(String email, String password) async {
    try {
      final user = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      print('User logged in');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<void> logoutUser() async {
    await account.deleteSession(sessionId: 'current');
    print('User Logged out');
  }

  // check User is authenticated or not
  @override
  Future<bool> checkUserAuth() async {
    try {
      print('Trying to checkUserAuth func');
      //Checks if session exist or not
      await account.getSession(sessionId: 'current');
      //If exist return true
      return true;
    } on AppwriteException catch (e) {
      print(e);
      return false;
    }
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final accountService = ref.watch(accountsProvider);

  return _AppwriteAuthRepository(accountService);
}
