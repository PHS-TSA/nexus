/// This library wraps the application in a shared scaffold.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import 'create_post.dart';

/// {@template nexus.app.wrapper}
/// Wrap the pages in a Material Design scaffold.
/// {@endtemplate}
class Wrapper extends StatelessWidget {
  /// {@macro nexus.app.wrapper}
  ///
  /// Construct a new [Wrapper] widget.
  const Wrapper({
    required this.autoRouter,
    required this.child,
    super.key,
    this.tabs,
  });

  /// The child widget to display.
  final Widget child;

  /// The [TabsRouter] to use for navigation.
  /// This is used to determine the current index of the tabs.
  final TabsRouter autoRouter;

  /// [AppBar.bottom]
  final PreferredSizeWidget? tabs;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return context.sizeClass == MaterialWindowSizeClass.compact
            ? _MobileWrapper(autoRouter: autoRouter, tabs: tabs, child: child)
            : _DesktopWrapper(autoRouter: autoRouter, tabs: tabs, child: child);
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TabsRouter>('autoRouter', autoRouter));
  }
}

class _DesktopWrapper extends StatelessWidget {
  const _DesktopWrapper({
    required this.autoRouter,
    required this.child,
    super.key,
    this.tabs,
  });

  final Widget child;

  final TabsRouter autoRouter;

  final PreferredSizeWidget? tabs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: autoRouter.activeIndex,
            onDestinationSelected: autoRouter.setActiveIndex,
            extended:
                // TODO(MattsAttack): Evaluate if this should be changed to constraints.
                context.sizeClass >= MaterialWindowSizeClass.medium,
            minExtendedWidth: 200,
            destinations: const [
              // TODO(MattsAttack): increase size of tabs.
              NavigationRailDestination(
                icon: Icon(Icons.feed),
                label: Text('Feeds'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.map_outlined),
                label: Text('Discover'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          Expanded(child: child),
        ],
      ), // TODO(MattsAttack): Implement rail here, similar to Google article.
      appBar: AppBar(
        elevation: 0,
        shadowColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        title: Text(autoRouter.current.title(context)),
        automaticallyImplyLeading: false,
        bottom: tabs,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () async => showDialog<void>(
              context: context,
              builder: (context) => const CreatePost(),
            ),
        child: const Icon(Icons.create),
      ), // TODO(MattsAttack): Change to form on top of feed for desktop.
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TabsRouter>('autoRouter', autoRouter));
  }
}

class _MobileWrapper extends StatelessWidget {
  const _MobileWrapper({
    required this.autoRouter,
    required this.child,
    super.key,
    this.tabs,
  });

  final Widget child;

  final TabsRouter autoRouter;

  final PreferredSizeWidget? tabs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed:
            () async => showDialog<void>(
              context: context,
              builder: (context) => const CreatePost(),
            ),
        child: const Icon(Icons.create),
      ),
      appBar: AppBar(
        title: Text(autoRouter.current.title(context)),
        shadowColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        bottom: tabs,
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: autoRouter.activeIndex,
        onDestinationSelected: autoRouter.setActiveIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.feed), label: 'Feeds'),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            label: 'Discover',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TabsRouter>('autoRouter', autoRouter));
  }
}
