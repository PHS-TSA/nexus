import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/router.gr.dart';
import '../../../../utils/tile_layers.dart';

/// {@template our_democracy.features.map.presentation.items.map_page}
/// Displays a map that allows users to view and interact with locations.
/// {@endtemplate}
@RoutePage()
class MapPage extends HookWidget {
  /// {@macro our_democracy.features.map.presentation.items.map_page}
  ///
  /// Construct a new [MapPage] widget.
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: const LatLng(38.657457, -95.560048),
        initialZoom: 4.5,
        onTap: (_, pos) async {
          print('pressed');
          await context.router.navigate(
            LocalFeedRoute(
              latitude: pos.latitude,
              longitude: pos.longitude,
            ),
          );
        },
      ),
      children: [
        openStreetMapLayer(),
      ],
    );
  }
}
