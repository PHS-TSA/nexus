/// This library hooks up the [Feed] with the [WorldFeed] feed for the router.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../domain/feed_entity.dart';
import 'feed.dart';

/// {@template harvest_hub.features.home.presentation.home.world_feed_page}
/// A page that displays a feed of posts from around the world.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class WorldFeedPage extends StatelessWidget {
  /// {@macro harvest_hub.features.home.presentation.home.world_feed_page}
  ///
  /// Construct a new [WorldFeedPage] widget.
  const WorldFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Feed(feed: FeedEntity.world());
  }
}
