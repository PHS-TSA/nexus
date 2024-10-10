import 'package:checks/checks.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/src/features/sample/domain/sample_items_model.dart';

void main() {
  group('SampleItemsModel', () {
    test('should be constant and support value equality', () {
      // Arrange
      const model = SampleItemsModel(items: IList.empty());

      // Act
      final newModel = model.copyWith(items: const IList.empty());

      // Assert
      check(newModel).equals(model);
    });
  });
}
