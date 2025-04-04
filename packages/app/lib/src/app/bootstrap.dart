/// The library provides a mixin to allow bootstrapping a widget into a full-fledged app.
library;

// `riverpod_lint` doesn't recognize that this is the root of the app.
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'dart:developer';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:os_detect/os_detect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import '../features/settings/application/settings_service.dart';
import '../features/settings/data/preferences_repository.dart';

/// The signature of [runApp].
typedef RunApp = void Function(Widget app);

/// The signature of [SharedPreferencesWithCache.create].
typedef GetSharedPreferences =
    Future<SharedPreferencesWithCache> Function({
      required SharedPreferencesWithCacheOptions cacheOptions,
      Map<String, Object?>? cache,
    });

/// The environment needed to bootstrap the app.
typedef BootstrapEnv =
    ({RunApp runApp, GetSharedPreferences getSharedPreferences});

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

    // Bind Flutter to the native platform.
    WidgetsFlutterBinding.ensureInitialized();

    // Constrain the window size on desktop.
    if (isWindows || isLinux || isMacOS) {
      await windowManager.ensureInitialized();
      await WindowManager.instance.setMinimumSize(const Size(1200, 600));
      await WindowManager.instance.setMaximumSize(const Size(1920, 1080));
    }

    // Load the user's preferences.
    final prefs = await getSharedPreferences(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    final initialSettings = await loadSettings(prefs);

    // Reset splash screen.
    FlutterNativeSplash.remove();
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
    );

    // Run the app.
    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          initialSettingsProvider.overrideWithValue(initialSettings),
        ],
        observers: const [if (kDebugMode) _ProviderInspector()],
        child: RestorationScope(restorationId: 'root', child: this),
      ),
    );
  }
}

class _ProviderInspector extends ProviderObserver {
  const _ProviderInspector();

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    log(
      '${provider.name ?? provider.runtimeType} added: ${_normalizedValue(value)}',
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    log(
      '${provider.name ?? provider.runtimeType} updated: ${_normalizedValue(previousValue)} -> ${_normalizedValue(newValue)}',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    log('${provider.name ?? provider.runtimeType} disposed');
  }
}

String _normalizedValue(Object? value) {
  return switch (value) {
    String _ => value,
    Uint8List _ => 'Uint8List(${value.length})',
    AsyncData<Uint8List>(:final value) =>
      'AsyncData<Uint8List>(value: ${_normalizedValue(value)})',
    final IList<Uint8List> list => '[${list.map(_normalizedValue).join(', ')}]',
    _ => value.toString(),
  };
}
