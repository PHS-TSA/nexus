/// This library hooks up the [Feed] with the [LocalFeed] feed for the router.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/feed_entity.dart';
import 'feed.dart';

/// {@template our_democracy.features.home.presentation.home.local_feed_page}
/// A page that displays a feed of posts from the area nearby the user.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class LocalFeedPage extends StatelessWidget {
  /// {@macro our_democracy.features.home.presentation.home.local_feed_page}
  ///
  /// Construct a new [LocalFeedPage] widget.
  const LocalFeedPage({
    required this.location,
    super.key,
  });

  final LatLng location;

  @override
  Widget build(BuildContext context) {
    return Feed(feed: FeedEntity.local(location));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<LatLng>('location', location));
  }
}
