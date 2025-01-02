import 'package:auto_route/auto_route.dart';
import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus/src/app/router.dart';
import 'package:nexus/src/app/router.gr.dart';
import 'package:nexus/src/app/wrapper_page.dart';
import 'package:nexus/src/app/wrapper_page.dart';
import 'package:nexus/src/features/auth/application/auth_service.dart';
import 'package:nexus/src/features/auth/data/auth_repository.dart';
import 'package:nexus/src/features/auth/presentation/auth/login_page.dart';
import 'package:nexus/src/features/auth/presentation/auth/signup_page.dart';
import 'package:nexus/src/features/map/presentation/items/map_info_page.dart';
import 'package:nexus/src/features/map/presentation/items/map_page.dart';
import 'package:nexus/src/features/sample/presentation/items/sample_item_details_page.dart';
import 'package:nexus/src/features/sample/presentation/items/sample_items_list_page.dart';
import 'package:nexus/src/features/settings/application/settings_service.dart';
import 'package:nexus/src/features/settings/data/preferences_repository.dart';
import 'package:nexus/src/features/settings/presentation/preferences/settings_page.dart';
import 'package:nexus/src/l10n/l10n.dart';
import 'package:nexus/src/utils/design.dart';
import 'package:nexus/src/utils/router.dart';

import '../../helpers/mocks.dart';
import '../../helpers/riverpod.dart';

extension _WidgetTesterX on WidgetTester {
  Future<AppRouter> pumpWidgetPage(
    List<PageRouteInfo<Object?>> routeStack,
  ) async {
    final mockSharedPreferences = MockSharedPreferences();
    final mockAuthRepository = MockAuthRepository();
    when(mockAuthRepository.checkUserAuth)
        .thenAnswer((_) => Future.value(fakeUser));

    final container = createContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        initialSettingsProvider.overrideWithValue(defaultSettings),
      ],
    )
      // Prime the authServiceProvider to ensure the state is flushed.
      ..read(authServiceProvider);

    await pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, ref, child) {
            return MaterialApp.router(
              routerConfig: ref.watch(routerProvider).config(),
              onGenerateTitle: (context) => context.l10n.appTitle,
              theme: theme,
              locale: const Locale('en', 'US'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    final router = container.read(routerProvider);

    await router.pushAll(routeStack);
    await pumpAndSettle();

    debugDumpApp();

    return router;
  }
}

// class MockRouteData extends Mock implements RouteData {}

void main() {
  group('router', () {
    group('config', () {
      test('uses Material transitions.', () {
        final container = createContainer();
        final routerSubscription = container.listen(routerProvider, (_, __) {});
        final tested = routerSubscription.read();

        check(tested.defaultRouteType).isA<MaterialRouteType>();
      });

      test('should contain the correct number of top level routes.', () {
        final container = createContainer();
        final routerSubscription = container.listen(routerProvider, (_, __) {});
        final tested = routerSubscription.read();

        // Wrapper, log in, sign up, and 404 redirect.
        check(tested.routes.length).equals(4);
      });
    });

    group('path', () {
      testWidgets('should be correct for WrapperRoute.', (tester) async {
        final router = await tester.pumpWidgetPage(const [WrapperRoute()]);
        final router = await tester.pumpWidgetPage(const [WrapperRoute()]);

        final context = tester.element(find.byType(WrapperPage));
        final context = tester.element(find.byType(WrapperPage));

        check(router)
          ..has((router) => router.urlState.path, 'path').equals('/feed/local')
          ..has((router) => router.topRoute.title(context), 'title')
              .equals('Local Feed');
          ..has((router) => router.urlState.path, 'path').equals('/feed/local')
          ..has((router) => router.topRoute.title(context), 'title')
              .equals('Local Feed');
      });
      testWidgets('should be correct for SampleItemsListRoute.',
          (tester) async {
        final router =
            await tester.pumpWidgetPage(const [SampleItemsListRoute()]);

        final context = tester.element(find.byType(SampleItemsListPage));

        check(router)
          ..has((router) => router.urlState.path, 'path').equals('/sample')
          ..has((router) => router.topRoute.title(context), 'title')
              .equals('Sample Items');
      testWidgets('should be correct for SampleItemsListRoute.',
          (tester) async {
        final router =
            await tester.pumpWidgetPage(const [SampleItemsListRoute()]);

        final context = tester.element(find.byType(SampleItemsListPage));

        check(router)
          ..has((router) => router.urlState.path, 'path').equals('/sample')
          ..has((router) => router.topRoute.title(context), 'title')
              .equals('Sample Items');
      });
      testWidgets('should be correct for SampleItemDetailsRoute.',
          (tester) async {
        final router =
            await tester.pumpWidgetPage(const [SampleItemDetailsRoute()]);

        final context = tester.element(find.byType(SampleItemDetailsPage));

        check(router)
          ..has((router) => router.urlState.path, 'path').equals('/sample-item')
          ..has((router) => router.topRoute.title(context), 'title')
              .equals('Item Details');
      testWidgets('should be correct for SampleItemDetailsRoute.',
          (tester) async {
        final router =
            await tester.pumpWidgetPage(const [SampleItemDetailsRoute()]);

        final context = tester.element(find.byType(SampleItemDetailsPage));

        check(router)
          ..has((router) => router.urlState.path, 'path').equals('/sample-item')
          ..has((router) => router.topRoute.title(context), 'title')
              .equals('Item Details');
      });
      testWidgets('should be correct for MapRoute.', (tester) async {
        final router = await tester.pumpWidgetPage(const [MapRoute()]);

        final context = tester.element(find.byType(MapPage));

        check(router)
          ..has((router) => router.urlState.path, 'path').equals('/')
          ..has((router) => router.topRoute.title(context), 'title')
              .equals('Map');

        // Test `initial: true`.
        await router.pushNamed('/some/path/that/does/not/exist');
        await tester.pumpAndSettle();

        check(router)
          ..has((router) => router.urlState.path, 'path').equals('/')
          ..has((router) => router.topRoute.title(context), 'title')
              .equals('Map');
      });
      testWidgets('should be correct for MapInfoRoute.', (tester) async {
        final router = await tester.pumpWidgetPage([MapInfoRoute()]);

        final context = tester.element(find.byType(MapInfoPage));

        check(router)
          ..has((router) => router.urlState.path, 'path').equals('/info')
          ..has((router) => router.topRoute.title(context), 'title')
              .equals('Location Details');
      });
      testWidgets('should be correct for SettingsRoute.', (tester) async {
        final router = await tester.pumpWidgetPage(const [SettingsRoute()]);

        final context = tester.element(find.byType(SettingsPage));

        check(router)
          ..has((router) => router.urlState.path, 'path').equals('/settings')
          ..has((router) => router.topRoute.title(context), 'title')
              .equals('Settings');
      });
      testWidgets('should be correct for LoginRoute', (tester) async {
        final router = await tester.pumpWidgetPage([LoginRoute()]);

        final context = tester.element(find.byType(LoginPage));

        check(router)
          ..has((router) => router.urlState.path, 'path').equals('/log-in')
          ..has((router) => router.topRoute.title(context), 'title')
              .equals('Log In');
      });
      testWidgets('should be correct for SignupRoute', (tester) async {
        final router = await tester.pumpWidgetPage([SignupRoute()]);

        final context = tester.element(find.byType(SignupPage));

        check(router)
          ..has((router) => router.urlState.path, 'path').equals('/sign-up')
          ..has((router) => router.topRoute.title(context), 'title')
              .equals('Sign Up');
      });
    });
  });
}
