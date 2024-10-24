/// This library contains the app's primary entrypoint.
library;

import 'package:flutter/widgets.dart';

import 'src/app/app.dart';
import 'src/app/bootstrap.dart';
import 'src/utils/api.dart';

/// The primary entrypoint of the app.
///
/// This uses [Bootstrap] to launch [App].
Future<void> main() async {
  const env = (runApp: runApp, createClient: createClient);

  await const App().bootstrap(env);
}
