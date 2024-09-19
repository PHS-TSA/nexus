import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/sample_item_entity.dart';
import '../domain/sample_items_model.dart';

part 'sample_items_service.g.dart';

/// Provide sample items.
@riverpod
base class SampleItemsService extends _$SampleItemsService {
  @override
  SampleItemsModel build() {
    return const SampleItemsModel(
      items: [
        SampleItemEntity(1),
        SampleItemEntity(2),
        SampleItemEntity(3),
      ],
    );
  }
}
