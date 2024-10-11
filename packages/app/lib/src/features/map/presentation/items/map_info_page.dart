import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../app/router.gr.dart';

/// {@template our_democracy.features.map.presentation.items.map_info_page}
/// Displays detailed information about a location on the map.
/// {@endtemplate}
@RoutePage()
class MapInfoPage extends StatelessWidget {
  /// {@macro our_democracy.features.map.presentation.items.map_info_page}
  ///
  /// Construct a new [MapInfoPage] widget.
  const MapInfoPage({
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
    return Column(
      children: [
        Text(
          'Your coordinates are (${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}).',
        ),
        TextButton(
          child: const Text('Back'),
          onPressed: () async {
            await context.router.navigate(const MapRoute());
          },
        ),
      ],
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
