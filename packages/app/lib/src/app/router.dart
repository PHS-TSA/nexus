/// This library handles routing for the application declaratively.
library;

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/auth/application/auth_service.dart';
import 'router.gr.dart';

/// The router for the application.
@AutoRouterConfig(replaceInRouteName: 'Page,Route', deferredLoading: true)
class AppRouter extends RootStackRouter {
  /// Instantiate a new instance of [AppRouter].
  AppRouter(this.ref); // A [Ref] so that we can use Riverpod.

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
                RedirectRoute(path: '*', redirectTo: 'local'),
              ],
            ),
          ],
        ),
        AutoRoute(
          page: PostViewRoute.page,
          path: '/post',
          title: (context, data) => 'Post',
        ),
        AutoRoute(
          // TODO(lishaduck): Add a guard to prevent logged in users from accessing this page.
          page: LogInRoute.page,
          path: '/log-in',
          title: (context, data) => 'Log In',
          keepHistory: false,
        ),
        AutoRoute(
          // TODO(lishaduck): Add a guard to prevent logged in users from accessing this page.
          page: SignUpRoute.page,
          path: '/sign-up',
          title: (context, data) => 'Sign Up',
        ),
        RedirectRoute(path: '/*', redirectTo: '/local'),
      ];

  @override
  List<AutoRouteGuard> get guards => [
        /*
         * How this guard works:
         * 1. The guard contacts the `authRepositoryProvider` to check if the user is logged in. If they are, it allows them to go to the requested page.
         * 2. Otherwise, we’ll send the user to the “log in” page and save the original page the user wanted to go to in the `onResult` closure.
         * 3. Once the user successfully logs in, `didLogIn` is set to `true` and `onResult` is run, sending them to their originally requested page.
         */
        AutoRouteGuard.simple((resolver, router) async {
          final authenticated = ref.read(authServiceProvider).requireValue;

          if (
              // TODO(MattsAttack): check implementation, is this right?
              authenticated != null ||
                  // If the user is trying to log in or sign up, let them through.
                  resolver.routeName == LogInRoute.name ||
                  resolver.routeName == SignUpRoute.name) {
            resolver.next();
          } else {
            await resolver.redirect(
              LogInRoute(
                // The parameter brings them back to the page they were trying to access.
                onResult: ({
                  // AutoRoute is buggy here, this is actually required.
                  // ignore: avoid_types_on_closure_parameters
                  bool? didLogIn,
                }) =>
                    resolver.next(didLogIn ?? false),
              ),
            );
          }
        }),
      ];
}
