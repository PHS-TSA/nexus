/// This library provides composable tile layers for maps.
library;

import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

/// Create an TileLayer for OpenStreetMap.
TileLayer openStreetMapLayer([Dio? dio]) {
  return TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'org.psdr3.harvest_hub',
    // Use the recommended flutter_map_cancellable_tile_provider package to
    // support the cancellation of loading tiles.
    tileProvider: CancellableNetworkTileProvider(dioClient: dio),
  );
}
