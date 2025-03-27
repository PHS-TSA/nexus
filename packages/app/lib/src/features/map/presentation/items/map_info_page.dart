/// This library provides a page that hooks up a [Feed] with coordinates.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../app/wrapper.dart';
import '../../../home/domain/feed_entity.dart';
import '../../../home/presentation/home/feed.dart';

/// {@template nexus.features.map.presentation.items.map_info_page}
/// Displays a feed of posts from the area nearby the user.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class MapInfoPage extends StatelessWidget {
  /// {@macro nexus.features.map.presentation.items.map_info_page}
  ///
  /// Construct a new [MapInfoPage] widget.
  const MapInfoPage({
    super.key,
    @queryParam this.latitude = 0,
    @queryParam this.longitude = 0,
  });

  /// The latitude of a location.
  final double latitude;

  /// The longitude of a location.
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      autoRouter: context.tabsRouter,
      child: Feed(feed: FeedEntity.local(latitude, longitude)),
    );
  }

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('x', latitude))
      ..add(DoubleProperty('y', longitude));
  }

  // coverage:ignore-end
}
