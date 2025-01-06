import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../utils/tile_layers.dart';
import '../../../home/domain/feed_entity.dart';
import '../../../home/presentation/home/feed.dart';

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
          await showDialog<void>(
            context: context,
            builder: (context) => _Dialog(
              latitude: pos.latitude,
              longitude: pos.longitude,
            ),
          );
        },

        //  () async => showDialog<void>(
        //   context: context,
        //   builder: (context) => const _Dialog(),
        //(_, pos) async {
        //   await context.router.push(
        //     MapInfoRoute(
        //       latitude: pos.latitude,
        //       longitude: pos.longitude,
        // ),
        // );
        // },
      ),
      children: [
        openStreetMapLayer(),
      ],
    );
  }
}

class _Dialog extends HookConsumerWidget {
  const _Dialog({
    required this.latitude,
    required this.longitude,
    // Temporary ignore, see <dart-lang/sdk#49025>.
    // ignore: unused_element
    super.key,
  });

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Feed(feed: FeedEntity.local(latitude, longitude)),
    );
  }

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('latitude', latitude))
      ..add(DiagnosticsProperty('longitude', longitude));
  }
  // coverage:ignore-end
}
