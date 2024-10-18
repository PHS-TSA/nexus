import 'package:auto_route/auto_route.dart';
import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/src/app/router.dart';
import 'package:nexus/src/app/router.gr.dart';
import 'package:nexus/src/app/wrapper_page.dart';
import 'package:nexus/src/utils/router.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/riverpod.dart';

Future<BuildContext> _getContext<W extends Widget>(
  WidgetTester tester,
  ProviderContainer container,
  AppRouter router,
) async {
  await tester.pumpApp(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router.config(),
      ),
    ),
  );
  return tester.element(find.byType(W));
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
        final container = createContainer();
        final routerSubscription = container.listen(routerProvider, (_, __) {});
        final router = routerSubscription.read();
        final context = await _getContext<WrapperPage>(
          tester,
          container,
          router,
        );

        // FIXME: Hangs! Yay!
        await context.router.push(const WrapperRoute());
        await tester.pumpAndSettle();

        check(router)
          ..has((router) => router.urlState.url, 'url').equals('/')
          ..has((router) => router.topRoute.title(context), 'title').equals('');
      });
      test('should be correct for MapRoute.', () {
        final container = createContainer();
        final routerSubscription = container.listen(
          routerProvider,
          (_, __) {},
        );
        final tested = routerSubscription.read();

        final mapRoute = tested.routes[0].children?.routes.toList()[0];
        check(mapRoute?.path).equals('');
      });
      test('should be correct for MapInfoRoute.', () {
        final container = createContainer();
        final routerSubscription = container.listen(
          routerProvider,
          (_, __) {},
        );
        final tested = routerSubscription.read();

        final sampleItemDetailsRoute =
            tested.routes[0].children?.routes.toList()[1];
        check(sampleItemDetailsRoute?.path).equals('info');
      });
      test('should be correct for SettingsRoute.', () {
        final container = createContainer();
        final routerSubscription = container.listen(routerProvider, (_, __) {});
        final tested = routerSubscription.read();

        final settingsRoute = tested.routes[0].children?.routes.toList()[2];
        check(settingsRoute?.path).equals('settings');
      });
      test("should be correct for ShellRoute('Feed')", () {
        final container = createContainer();
        final routerSubscription = container.listen(routerProvider, (_, __) {});
        final tested = routerSubscription.read();

        final sampleItemDetailsRoute =
            tested.routes[0].children?.routes.toList()[3];
        check(sampleItemDetailsRoute?.path).equals('local');
      });
      test('should allow logging in', () {
        final container = createContainer();
        final routerSubscription = container.listen(routerProvider, (_, __) {});
        final tested = routerSubscription.read();

        final redirectRoute = tested.routes[1];
        check(redirectRoute.path).equals('/log-in');
      });
      test('should allow signing up', () {
        final container = createContainer();
        final routerSubscription = container.listen(routerProvider, (_, __) {});
        final tested = routerSubscription.read();

        final redirectRoute = tested.routes[2];
        check(redirectRoute.path).equals('/sign-up');
      });
      test('should redirect on 404', () {
        final container = createContainer();
        final routerSubscription = container.listen(routerProvider, (_, __) {});
        final tested = routerSubscription.read();

        final redirectRoute = tested.routes[3];
        check(redirectRoute.path).equals('/*');
      });
    });
  });
}
