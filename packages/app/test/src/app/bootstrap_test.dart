import 'package:checks/checks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus/src/app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/mocks.dart';

Future<SharedPreferencesWithCache> getSharedPreferences({
  required SharedPreferencesWithCacheOptions cacheOptions,
  Map<String, Object?>? cache,
}) async {
  return MockSharedPreferences();
}

void main() {
  setUpAll(() {
    registerFallbackValue(Container());
  });

  test('main does not throw', () async {
    const app = App();
    final env = (
      runApp: (_) {},
      getSharedPreferences: getSharedPreferences,
    );

    await check(app.bootstrap(env)).completes();
  });
}
