import 'package:appwrite/appwrite.dart';

//Create a user account

class _AuthRepository {
  const _AuthRepository(this.account);

  final Account account;

// Register the user(Sign up)
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

  Future loginUser(String email, String password) async {
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

  Future logoutUser() async {
    await account.deleteSession(sessionId: 'current');
    print('User Logged out');
  }

// check User is authenticated or not

  Future checkUserAuth() async {
    try {
      print('Trying to checkUserAuth func');
      //Checks if session exist or not
      await account.getSession(sessionId: 'current');
      //If exist return true
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
