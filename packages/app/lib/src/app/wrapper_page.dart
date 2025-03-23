/// This library provides shared context for the scaffold.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'router.gr.dart';

/// {@template nexus.app.wrapper_page}
/// Wrap the pages in a Material Design scaffold.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class WrapperPage extends ConsumerWidget {
  /// {@macro nexus.app.wrapper_page}
  ///
  /// Construct a new [WrapperPage] widget.
  const WrapperPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsRouter(
      routes: const [FeedRoutingRoute(), MapRoute(), SettingsRoute()],
      builder: (context, child) => child,
    );
  }
}
