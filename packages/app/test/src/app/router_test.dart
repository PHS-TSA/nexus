import 'package:auto_route/auto_route.dart';
import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_checks/flutter_checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus/src/app/router.dart';
import 'package:nexus/src/app/router.gr.dart';
import 'package:nexus/src/app/wrapper_page.dart';
import 'package:nexus/src/features/auth/application/auth_service.dart';
import 'package:nexus/src/features/auth/data/auth_repository.dart';
import 'package:nexus/src/features/sample/presentation/items/sample_item_details_page.dart';
import 'package:nexus/src/features/sample/presentation/items/sample_items_list_page.dart';
import 'package:nexus/src/l10n/l10n.dart';
import 'package:nexus/src/utils/design.dart';
import 'package:nexus/src/utils/router.dart';

import '../../helpers/mocks.dart';
import '../../helpers/riverpod.dart';

extension _WidgetTesterX on WidgetTester {
  Future<AppRouter> pumpWidgetPage(
    List<PageRouteInfo<Object?>> routeStack,
    Type pageWidget,
  ) async {
    final mockAuthRepository = MockAuthRepository();
    when(mockAuthRepository.checkUserAuth)
        .thenAnswer((_) => Future.value(fakeUser));

    final container = createContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
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
    check(find.byType(pageWidget)).findsOne();

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
        final router = await tester.pumpWidgetPage(
          const [WrapperRoute()],
          WrapperPage,
        );

        final context = tester.element(find.byType(WrapperPage));

        check(router)
          ..has((router) => router.urlState.path, 'path').equals('/')
          ..has((router) => router.topRoute.title(context), 'title')
              .equals('Test');
      });
      testWidgets('should be correct for SampleItemsListRoute.',
          (tester) async {
        final router = await tester.pumpWidgetPage(
          const [SampleItemsListRoute()],
          SampleItemsListPage,
        );

        final context = tester.element(find.byType(SampleItemsListPage));

        check(router)
          ..has((router) => router.urlState.path, 'path').equals('/sample')
          ..has((router) => router.topRoute.title(context), 'title')
              .equals('Sample Items');
      });
      testWidgets('should be correct for SampleItemDetailsRoute.',
          (tester) async {
        final router = await tester.pumpWidgetPage(
          const [SampleItemDetailsRoute()],
          SampleItemDetailsPage,
        );

        final context = tester.element(find.byType(SampleItemDetailsPage));

        check(router)
          ..has((router) => router.urlState.path, 'path').equals('/sample-item')
          ..has((router) => router.topRoute.title(context), 'title')
              .equals('Item Details');
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
