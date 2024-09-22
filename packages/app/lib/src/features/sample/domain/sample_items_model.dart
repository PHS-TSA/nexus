/// This library contains a data class representing a collection of sample items.
library;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'sample_item_entity.dart';

part 'sample_items_model.freezed.dart';

/// {@template our_democracy.features.sample.domain.sample}
/// Represent a collection of sample items.
/// {@endtemplate}
@freezed
@immutable
class SampleItemsModel with _$SampleItemsModel {
  /// {@macro our_democracy.features.sample.domain.sample}
  const factory SampleItemsModel({
    /// The list of sample items.
    required IList<SampleItemEntity> items,
  }) = _SampleItemModel;
}
