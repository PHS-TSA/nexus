import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app/app.dart';
import 'src/app/bootstrap.dart';

/// The primary entrypoint of the app.
///
/// This uses [Bootstrap] to launch [MyApp].
Future<void> main() async {
  await const MyApp().bootstrap(
    (
      runApp: runApp,
      getSharedPreferences: SharedPreferencesWithCache.create,
    ),
  );
}
