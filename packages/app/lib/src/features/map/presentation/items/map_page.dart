import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/router.gr.dart';
import '../../../../utils/dio.dart';
import '../../../../utils/tile_layers.dart';

/// {@template our_democracy.features.map.presentation.items.map_page}
/// Displays a map that allows users to view and interact with locations.
/// {@endtemplate}
@RoutePage()
class MapPage extends ConsumerWidget {
  /// {@macro our_democracy.features.map.presentation.items.map_page}
  ///
  /// Construct a new [MapPage] widget.
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dio = ref.watch(dioProvider);

    return FlutterMap(
      options: MapOptions(
        initialCenter: const LatLng(38.657457, -95.560048),
        initialZoom: 4.5,
        onTap: (_, pos) async {
          await context.router.push(
            MapInfoRoute(
              latitude: pos.latitude,
              longitude: pos.longitude,
            ),
          );
        },
      ),
      children: [
        openStreetMapLayer(dio),
      ],
    );
  }
}
