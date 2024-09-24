/// This library handles routing for the application declaratively.
library;

import 'package:auto_route/auto_route.dart';

import 'router.gr.dart';

/// The router for the application.
@AutoRouterConfig(replaceInRouteName: 'Page,Route', deferredLoading: true)
class AppRouter extends RootStackRouter {
  /// Instantiate a new instance of [AppRouter].
  AppRouter();

  @override
  final defaultRouteType = const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: WrapperRoute.page,
          path: '/home/',
          children: [
            AutoRoute(
              page: SampleItemsListRoute.page,
              path: 'sample',
              title: (context, data) => 'Sample Items',
            ),
            AutoRoute(
              page: SampleItemDetailsRoute.page,
              path: 'sample-item',
              title: (context, data) => 'Item Details',
            ),
            AutoRoute(
              page: SettingsRoute.page,
              path: 'settings',
              title: (context, data) => 'Settings',
            ),
            AutoRoute(
              page: const EmptyShellRoute('Feeds'),
              path: '',
              children: [
                AutoRoute(
                  page: LocalFeedRoute.page,
                  path: '', // FIXME: This should be 'local'.
                  title: (context, data) => 'Test',
                ),
                AutoRoute(
                  page: WorldFeedRoute.page,
                  path: 'world',
                  title: (context, data) => 'Test',
                ),
              ],
            ),
          ],
        ),
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
          title: (context, data) => 'Login',
        ),
        AutoRoute(
          page: SignupRoute.page,
          path: '/sign_up',
          title: (context, data) => 'Sign Up',
        ),
        AutoRoute(
          page: CheckUserAuth.page,
          path: '/',
          title: (context, data) => 'Login',
        ),
        RedirectRoute(path: '/*', redirectTo: '/'),
      ];
}
