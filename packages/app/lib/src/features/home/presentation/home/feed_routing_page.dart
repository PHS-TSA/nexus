/// This library wraps the application in a shared scaffold.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router.gr.dart';

// import '../../auth/application/auth_service.dart';
// import '../features/home/application/location_service.dart';
// import '../features/home/data/post_repository.dart';
// import '../features/home/domain/feed_entity.dart';

@RoutePage(deferredLoading: true)

/// NavigationBar that manages routing between local and world feeds
class FeedRoutingPage extends ConsumerWidget {
  ///  NavigationBar that manages routing between local and world feeds
  const FeedRoutingPage({super.key});

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
