/// This library hooks up the [Feed] with the [LocalFeed] feed for the router.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    @queryParam this.latitude = 0,
    @queryParam this.longitude = 0,
    super.key,
  });

  /// The latitude of a location.
  final double latitude;

  /// The longitude of a location.
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return Feed(feed: FeedEntity.local(latitude, longitude));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('latitude', latitude))
      ..add(DoubleProperty('longitude', longitude));
  }
}
