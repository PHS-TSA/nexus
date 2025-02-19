/// This library hooks up the [Feed] with the [LocalFeed] feed for the router.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/location_service.dart';
import '../../domain/feed_entity.dart';
import 'feed.dart';

/// {@template nexus.features.home.presentation.home.local_feed_page}
/// A page that displays a feed of posts from the area nearby the user.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class LocalFeedPage extends ConsumerWidget {
  /// {@macro nexus.features.home.presentation.home.local_feed_page}
  ///
  /// Construct a new [LocalFeedPage] widget.
  const LocalFeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pos = ref.watch(locationServiceProvider);

    return switch (pos) {
      AsyncData(:final value) => Feed(
        feed: FeedEntity.local(value.latitude, value.longitude),
      ),
      AsyncError(:final error) => Center(child: Text('Error: $error')),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
