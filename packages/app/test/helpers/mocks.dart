// Mocktail requires discarding futures.
// ignore_for_file: discarded_futures

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite/src/enums.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus/src/features/auth/data/auth_repository.dart';

void registerFallbacks() {
  registerFallbackValue(HttpMethod.get);
}

class MockClient extends Mock implements Client {}

extension MockClientX on MockClient {
  void mockCall<T>({
    required String path,
    required Response<T> response,
  }) {
    when(
      () => call(
        any(),
        path: path,
        headers: any(named: 'headers'),
        params: any(named: 'params'),
        responseType: any(named: 'responseType'),
      ),
    ).thenAnswer((_) => Future.value(response));
  }
}

class MockAuthRepository extends Mock implements AuthRepository {}

/// A fake user.
/// Taken from the [Appwrite docs](https://appwrite.io/docs/references/cloud/models/user).
final fakeUser = User(
  $id: '5e5ea5c16897e',
  $createdAt: '2020-10-15T06:38:00.000+00:00',
  $updatedAt: '2020-10-15T06:38:00.000+00:00',
  name: 'John Doe',
  password:
      // cspell: disable-next-line
      r'$argon2id$v=19$m=2048,t=4,p=3$aUZjLnliVWRINmFNTWMudg$5S+x+7uA31xFnrHFT47yFwcJeaP0w92L/4LdgrVRXxE',
  hash: 'argon2',
  hashOptions: {
    'type': 'argon2',
    'memoryCost': 65536,
    'timeCost': 4,
    'threads': 3,
  },
  registration: '2020-10-15T06:38:00.000+00:00',
  status: true,
  labels: [
    'vip',
  ],
  passwordUpdate: '2020-10-15T06:38:00.000+00:00',
  email: 'john@appwrite.io',
  phone: '+4930901820',
  emailVerification: true,
  phoneVerification: true,
  mfa: true,
  prefs: Preferences(data: {}),
  targets: [
    Target(
      $id: '259125845563242502',
      $createdAt: '2020-10-15T06:38:00.000+00:00',
      $updatedAt: '2020-10-15T06:38:00.000+00:00',
      name: 'Aegon apple token',
      userId: '259125845563242502',
      providerId: '259125845563242502',
      providerType: 'email',
      identifier: 'token',
    ),
  ],
  accessedAt: '2020-10-15T06:38:00.000+00:00',
);
