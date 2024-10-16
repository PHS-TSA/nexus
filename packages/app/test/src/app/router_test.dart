import 'package:auto_route/auto_route.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/src/utils/router.dart';

import '../../helpers/riverpod.dart';

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
      test('should be correct for WrapperRoute.', () {
        final container = createContainer();
        final routerSubscription = container.listen(routerProvider, (_, __) {});
        final tested = routerSubscription.read();

        final wrapperRoute = tested.routes[0];
        check(wrapperRoute.path).equals('/');
      });
      test('should be correct for SampleItemsListRoute.', () {
        final container = createContainer();
        final routerSubscription = container.listen(routerProvider, (_, __) {});
        final tested = routerSubscription.read();

        final sampleItemListRoute =
            tested.routes[0].children?.routes.toList()[0];
        check(sampleItemListRoute?.path).equals('sample');
      });
      test('should be correct for SampleItemDetailsRoute.', () {
        final container = createContainer();
        final routerSubscription = container.listen(routerProvider, (_, __) {});
        final tested = routerSubscription.read();

        final sampleItemDetailsRoute =
            tested.routes[0].children?.routes.toList()[1];
        check(sampleItemDetailsRoute?.path).equals('sample-item');
      });
      test('should be correct for MapRoute.', () {
        final container = createContainer();
        final routerSubscription = container.listen(
          routerProvider,
          (_, __) {},
        );
        final tested = routerSubscription.read();

        final sampleItemListRoute =
            tested.routes[0].children?.routes.toList()[2];
        check(sampleItemListRoute?.path).equals('');
      });
      test('should be correct for MapInfoRoute.', () {
        final container = createContainer();
        final routerSubscription = container.listen(
          routerProvider,
          (_, __) {},
        );
        final tested = routerSubscription.read();

        final sampleItemDetailsRoute =
            tested.routes[0].children?.routes.toList()[3];
        check(sampleItemDetailsRoute?.path).equals('info');
      });
      test('should be correct for SettingsRoute.', () {
        final container = createContainer();
        final routerSubscription = container.listen(routerProvider, (_, __) {});
        final tested = routerSubscription.read();

        final settingsRoute = tested.routes[0].children?.routes.toList()[4];
        check(settingsRoute?.path).equals('settings');
      });
      test("should be correct for ShellRoute('Feed')", () {
        final container = createContainer();
        final routerSubscription = container.listen(routerProvider, (_, __) {});
        final tested = routerSubscription.read();

        final sampleItemDetailsRoute =
            tested.routes[0].children?.routes.toList()[5];
        check(sampleItemDetailsRoute?.path)
            // Home
            .equals('');
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
