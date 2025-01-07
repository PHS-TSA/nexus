/// This library wraps the application in a shared scaffold.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router.gr.dart';

/// {@template nexus.features.home.presentation.home.feed_routing_page}
/// A page that manages routing between different feeds.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class FeedRoutingPage extends ConsumerWidget {
  /// {@macro nexus.features.home.presentation.home.feed_routing_page}
  ///
  /// Construct a new [FeedRoutingPage] widget.
  const FeedRoutingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsScaffold(
      routes: const [LocalFeedRoute(), WorldFeedRoute()],
      appBarBuilder: (context, autoRouter) {
        return AppBar(
          automaticallyImplyLeading: false,
          title: NavigationBar(
            selectedIndex: autoRouter.activeIndex,
            onDestinationSelected: autoRouter.setActiveIndex,
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.pin_drop),
                label: 'Local',
              ),
              NavigationDestination(
                icon: Icon(Icons.public),
                label: 'World',
              ),
            ],
          ),
        );
      },
    );
  }
}
