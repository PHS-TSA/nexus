import 'package:auto_route/auto_route.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/src/app/router.dart';

void main() {
  group('router', () {
    final tested = AppRouter();

    group('config', () {
      test(
        'defaultRouteType is a RouteType.material.',
        () {
          check(tested.defaultRouteType).isA<MaterialRouteType>();
        },
      );

      test('should contain the correct number of routes.', () {
        check(tested.routes.length).equals(2);
      });
    });

    group('path', () {
      test('should be correct for WrapperRoute.', () {
        final wrapperRoute = tested.routes[0];
        check(wrapperRoute.path).equals('/');
      });
      test('should be correct for SampleItemListRoute.', () {
        final sampleItemListRoute =
            tested.routes[0].children?.routes.toList()[0];
        check(sampleItemListRoute?.path).equals('');
      });
      test('should be correct for SampleItemDetailsRoute.', () {
        final sampleItemDetailsRoute =
            tested.routes[0].children?.routes.toList()[1];
        check(sampleItemDetailsRoute?.path).equals('sample-item');
      });
      test('should be correct for SettingsRoute.', () {
        final settingsRoute = tested.routes[0].children?.routes.toList()[2];
        check(settingsRoute?.path).equals('settings');
      });
      test('should redirect on 404', () {
        final redirectRoute = tested.routes[1];
        check(redirectRoute.path).equals('/*');
      });
    });
  });
}
