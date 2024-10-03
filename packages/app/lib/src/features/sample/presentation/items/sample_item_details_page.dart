/// This library contains a page that displays detailed information about a [SampleItemEntity].
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../domain/sample_item_entity.dart';

/// {@template our_democracy.features.sample.presentation.items.sample_items_details_page}
/// Displays detailed information about a SampleItem.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class SampleItemDetailsPage extends StatelessWidget {
  /// {@macro our_democracy.features.sample.presentation.items.sample_items_details_page}
  ///
  /// Construct a new [SampleItemDetailsPage] widget.
  const SampleItemDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('More Information Here'),
    );
  }
}
