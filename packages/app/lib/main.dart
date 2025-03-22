/// This library contains the app's primary entrypoint.
library;

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'src/app/app.dart';
import 'src/app/bootstrap.dart';

/// The primary entrypoint of the app.
///
/// This uses [Bootstrap] to launch [App].
Future<void> main() async {
  //Set minimum window size for desktop
  WidgetsFlutterBinding.ensureInitialized();

  // Only initialize window manager on desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    await WindowManager.instance.setMinimumSize(const Size(1200, 600));
    await WindowManager.instance.setMaximumSize(const Size(1920, 1080));
  }

  await const App().bootstrap((
    runApp: runApp,
    getSharedPreferences: SharedPreferencesWithCache.create,
  ));
}
