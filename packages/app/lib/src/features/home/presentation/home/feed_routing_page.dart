/// This library wraps the application in a shared scaffold.
// ignore_for_file: prefer_expression_function_bodies

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
class FeedRoutingPage extends ConsumerWidget {
  const FeedRoutingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsScaffold(
      routes: const [LocalFeedRoute(), WorldFeedRoute()],
      appBarBuilder: (context, autoRouter) {
        return AppBar(
          //TODOfix coloring
          title: NavigationBar(
            selectedIndex: autoRouter.activeIndex,
            onDestinationSelected: autoRouter.setActiveIndex,
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
