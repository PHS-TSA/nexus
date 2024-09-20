/// This library hooks up the [Feed] with the [LocalFeed] feed for the router.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../domain/feed_entity.dart';
import 'feed.dart';

/// {@template our_democracy.features.home.presentation.home.local_feed_page}
/// A page that displays a feed of posts from the area nearby the user.
/// {@endtemplate}
@RoutePage()
class LocalFeedPage extends StatelessWidget {
  /// {@macro our_democracy.features.home.presentation.home.local_feed_page}
  ///
  /// Construct a new [LocalFeedPage] widget.
  const LocalFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Feed(feed: FeedEntity.local());
  }
}
