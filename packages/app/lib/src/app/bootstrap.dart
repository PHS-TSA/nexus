import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/settings/application/settings_service.dart';
import '../features/settings/data/preferences_repository.dart';

typedef RunApp = void Function(Widget app);
typedef GetSharedPreferences = Future<SharedPreferencesWithCache> Function({
  required SharedPreferencesWithCacheOptions cacheOptions,
  Map<String, Object?>? cache,
});
typedef BootstrapEnv = ({
  RunApp runApp,
  GetSharedPreferences getSharedPreferences,
});

/// Turn any widget into a flow-blown app.
mixin Bootstrap implements Widget {
  /// Bootstrap the app given a [BootstrapEnv].
  ///
  /// This involves
  /// - setting [FlutterError.onError] to log errors to the console,
  /// - calling [usePathUrlStrategy] to use path-style URLs,
  /// - setting up the [SettingsService] and loading the user's preferences,
  /// - initializing riverpod's [ProviderScope], and
  /// - running the app with [runApp].
  Future<void> bootstrap(BootstrapEnv env) async {
    final (:runApp, :getSharedPreferences) = env;

    // Don't use hash style routes.
    usePathUrlStrategy();

    // Reset notification bar on Android.
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
    );

    // Load the user's preferences.
    final prefs = await getSharedPreferences(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    final initialSettings = await loadSettings(prefs);

    // Run the app.
    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          initialSettingsProvider.overrideWithValue(initialSettings),
        ],
        child: RestorationScope(
          restorationId: 'root',
          child: this,
        ),
      ),
    );
  }
}
