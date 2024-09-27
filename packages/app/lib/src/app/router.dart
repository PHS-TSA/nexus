/// This library handles routing for the application declaratively.
library;

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/auth/data/auth_repository.dart';
import 'router.gr.dart';

/// The router for the application.
@AutoRouterConfig(replaceInRouteName: 'Page,Route', deferredLoading: true)
class AppRouter extends RootStackRouter {
  /// Instantiate a new instance of [AppRouter].
  AppRouter(this.ref); //creates a ref so we can use riverpod

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
          keepHistory: false,
        ),
        AutoRoute(
          page: SignupRoute.page,
          path: '/sign_up',
          title: (context, data) => 'Sign Up',
        ),
        RedirectRoute(path: '/*', redirectTo: '/'),
      ];

  @override
  List<AutoRouteGuard> get guards => [
        /* 
          How this guard works:
          1. The guard contacts the authRepositoryProvider to check if the user is logged in. If they it allows them to go to the requested page
          2. Else send user to login page with and save the page the user wanted to go to in the onResult function.
          3. Once the user successfully logs in in the login_page the didLogIN value is set to true and onResult function is ran sending them to their requested page
          */
        AutoRouteGuard.simple((resolver, router) async {
          final authenticated =
              await ref.read(authRepositoryProvider).checkUserAuth();
          if (authenticated ||
              resolver.routeName == LoginRoute.name ||
              resolver.routeName == SignupRoute.name) {
            //Add in support for
            resolver.next();
          } else {
            await resolver.redirect(
              LoginRoute(
                // AutoRoute is buggy here, this is actually required.
                // ignore: avoid_types_on_closure_parameters
                onResult: ({bool? didLogIn}) => resolver.next(
                  didLogIn ?? false,
                ),
              ),
            ); //The parameter brings them back to the page they were before
          }
        }),
      ];
}
