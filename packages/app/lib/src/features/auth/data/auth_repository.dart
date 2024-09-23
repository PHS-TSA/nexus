import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/api.dart';

part 'auth_repository.g.dart';

abstract interface class AuthRepository {
  Future<void> createUser(String name, String email, String password);
  Future<void> loginUser(String email, String password);
  Future<void> logoutUser();
}

//Create a user account
class _AppwriteAuthRepository implements AuthRepository {
  const _AppwriteAuthRepository(this.account);

  final Account account;

// Register the user(Sign up)
  @override
  Future<void> createUser(String name, String email, String password) async {
    await account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
  }

// Login the User

  @override
  Future<void> loginUser(String email, String password) async {
    await account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logoutUser() async {
    await account.deleteSession(sessionId: 'current');
    print('User Logged out');
  }

  // check User is authenticated or not
  Future<void> checkUserAuth() async {
    print('Trying to checkUserAuth func');
    //Checks if session exist or not
    await account.getSession(sessionId: 'current');
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final accountService = ref.watch(accountsProvider);

  return _AppwriteAuthRepository(accountService);
}
