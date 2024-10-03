import 'package:appwrite/models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus/src/features/auth/data/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock
    implements SharedPreferencesWithCache {}

class MockAuthRepository extends Mock implements AuthRepository {}

// TODO: Grab fake data from appwrite docs.
final fakeUser = User(
  $createdAt: '0',
  $id: 'a',
  $updatedAt: '0',
  name: '',
  registration: '0',
  status: true,
  labels: [],
  passwordUpdate: '0',
  email: '0',
  phone: '0',
  emailVerification: false,
  phoneVerification: false,
  mfa: false,
  prefs: Preferences(data: {}),
  targets: [],
  accessedAt: '0',
);
