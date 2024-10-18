import 'package:appwrite/appwrite.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus/src/app/app.dart';

import '../../helpers/mocks.dart';

void main() {
  setUpAll(registerFallbacks);

  test('main does not throw', () async {
    const app = App();

    final env = (
      runApp: (_) {},
      createClient: () => MockClient()
        ..mockCall(
          path: any(named: '/account/prefs'),
          response: Response(data: <String, Object?>{}),
        )
    );

    await check(app.bootstrap(env)).completes();
  });
}
