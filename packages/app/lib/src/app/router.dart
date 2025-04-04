/// This library handles routing for the application declaratively.
library;

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/auth/application/auth_service.dart';
import 'router.gr.dart';

/// The router for the application.
@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
  deferredLoading: true,
  argsEquality: false,
)
class AppRouter extends RootStackRouter {
  /// Instantiate a new instance of [AppRouter].
  AppRouter(this.ref);

  /// Used in the guard to get the [authServiceProvider].
  Ref ref;

  @override
  final defaultRouteType = const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: WrapperRoute.page,
      path: '/',
      children: [
        AutoRoute(
          page: MapRoute.page,
          path: 'map',
          title: (context, data) => 'Map',
          initial: true,
        ),
        AutoRoute(
          page: MapInfoRoute.page,
          path: 'info',
          title: (context, data) => 'Location Details',
        ),
        AutoRoute(
          page: SettingsRoute.page,
          path: 'settings',
          title: (context, data) => 'Settings',
        ),
        AutoRoute(
          page: FeedRoutingRoute.page,
          path: '',
          title: (context, data) => 'Feeds',
          children: [
            AutoRoute(
              page: LocalFeedRoute.page,
              path: 'local',
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
      page: PostViewRoute.page,
      path: '/post/:id',
      title: (context, data) => 'Post',
    ),
    AutoRoute(
      page: LogInRoute.page,
      path: '/log-in',
      title: (context, data) => 'Log In',
      keepHistory: false,
    ),
    AutoRoute(
      page: SignUpRoute.page,
      path: '/sign-up',
      title: (context, data) => 'Sign Up',
    ),
    RedirectRoute(path: '/*', redirectTo: '/local'),
  ];

  @override
  List<AutoRouteGuard> get guards => [
    /*
      How this guard works:
      * 1. The guard checks the authentication state using `authServiceProvider`.
      * 2. If the user is authenticated and trying to access a protected route, or is unauthenticated and trying to access authentication routes (log in/sign up), they proceed.
      * 3. If the user is unauthenticated and tries to access a protected route, they're redirected to the login page with an `onResult` closure that returns them to their originally requested page after successful login.
      * 4. If the user is already authenticated but tries to access auth routes, they're redirected to the main application.
     */
    AutoRouteGuard.simple((resolver, router) async {
      final isAuthenticated =
          ref.read(authServiceProvider).requireValue != null;
      final isAuthenticatedRoute =
          resolver.routeName != LogInRoute.name &&
          resolver.routeName != SignUpRoute.name;

      if (isAuthenticated == isAuthenticatedRoute) {
        resolver.next();
      } else if (!isAuthenticated) {
        unawaited(
          resolver.redirectUntil(
            LogInRoute(
              // The parameter brings them back to the page they were trying to access.
              onResult: ({required didLogIn}) {
                resolver.next(didLogIn);
              },
            ),
          ),
        );
      } else if (!isAuthenticatedRoute) {
        resolver.overrideNext(children: [const WrapperRoute()]);
      }
    }),
  ];
}
