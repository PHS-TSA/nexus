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
  const FeedRoutingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsRouter.tabBar(
      routes: const [LocalFeedRoute(), WorldFeedRoute()],
      builder: (context, child, tabController) {
        return Column(
          children: [
            TabBar(
              controller: tabController,
              tabs: const [
                Tab(icon: Icon(Icons.pin_drop), text: 'Local'),
                Tab(icon: Icon(Icons.public), text: 'World'),
              ],
            ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
