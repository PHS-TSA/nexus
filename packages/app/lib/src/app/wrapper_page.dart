import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'router.gr.dart';

/// {@template our_democracy.app.wrapper_page}
/// Wrap the pages in a Material Design scaffold.
/// {@endtemplate}
@RoutePage()
class WrapperPage extends ConsumerWidget {
  /// Create a new [WrapperPage].
  ///
  /// {@macro our_democracy.app.wrapper_page}
  const WrapperPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsScaffold(
      routes: const [
        LocalFeedRoute(),
        WorldFeedRoute(),
      ],
      appBarBuilder: (context, autoRouter) {
        final path = autoRouter.routeData.path;

        return AppBar(
          title: Text(autoRouter.routeData.title(context)),
          leading: const AutoLeadingButton(),
          actions: switch (path) {
            '/' => [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(
                      Icons.settings,
                      semanticLabel: 'Settings',
                    ),
                    onPressed: () async {
                      // Navigate to the settings page. If the user leaves and returns
                      // to the app after it has been killed while running in the
                      // background, the navigation stack is restored.
                      await context.router.push(const SettingsRoute());
                    },
                  ),
                ),
              ],
            _ => [],
          },
          bottom: switch (path) {
            '/' => TabBar(
                onTap: autoRouter.setActiveIndex,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.my_location),
                    text: 'Local',
                  ),
                  Tab(
                    icon: Icon(Icons.public),
                    text: 'World',
                  ),
                ],
              ),
            _ => null,
          },
        );
      },
      bottomNavigationBuilder: (context, autoRouter) {
        return NavigationBar(destinations: const []);
      },
    );
  }
}
