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
        final routerSubscription = container.listen(
          routerProvider,
          (_, __) {},
        );
        final tested = routerSubscription.read();

        check(tested.defaultRouteType).isA<MaterialRouteType>();
      });

      test('should contain the correct number of routes.', () {
        final container = createContainer();
        final routerSubscription = container.listen(
          routerProvider,
          (_, __) {},
        );
        final tested = routerSubscription.read();

        check(tested.routes.length).equals(2);
      });
    });

    group('path', () {
      test('should be correct for WrapperRoute.', () {
        final container = createContainer();
        final routerSubscription = container.listen(
          routerProvider,
          (_, __) {},
        );
        final tested = routerSubscription.read();

        final wrapperRoute = tested.routes[0];
        check(wrapperRoute.path).equals('/');
      });
      test('should be correct for SampleItemListRoute.', () {
        final container = createContainer();
        final routerSubscription = container.listen(
          routerProvider,
          (_, __) {},
        );
        final tested = routerSubscription.read();

        final sampleItemListRoute =
            tested.routes[0].children?.routes.toList()[0];
        check(sampleItemListRoute?.path).equals('sample');
      });
      test('should be correct for SampleItemDetailsRoute.', () {
        final container = createContainer();
        final routerSubscription = container.listen(
          routerProvider,
          (_, __) {},
        );
        final tested = routerSubscription.read();

        final sampleItemDetailsRoute =
            tested.routes[0].children?.routes.toList()[1];
        check(sampleItemDetailsRoute?.path).equals('sample-item');
      });
      test('should be correct for SettingsRoute.', () {
        final container = createContainer();
        final routerSubscription = container.listen(
          routerProvider,
          (_, __) {},
        );
        final tested = routerSubscription.read();

        final settingsRoute = tested.routes[0].children?.routes.toList()[2];
        check(settingsRoute?.path).equals('settings');
      });
      test("should be correct for ShellRoute('Feed')", () {
        final container = createContainer();
        final routerSubscription = container.listen(
          routerProvider,
          (_, __) {},
        );
        final tested = routerSubscription.read();

        final sampleItemDetailsRoute =
            tested.routes[0].children?.routes.toList()[3];
        check(sampleItemDetailsRoute?.path)
            // Home
            .equals('');
      });
      test('should redirect on 404', () {
        final container = createContainer();
        final routerSubscription = container.listen(
          routerProvider,
          (_, __) {},
        );
        final tested = routerSubscription.read();

        final redirectRoute = tested.routes[1];
        check(redirectRoute.path).equals('/*');
      });
    });
  });
}
