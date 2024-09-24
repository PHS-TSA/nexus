import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/src/features/sample/application/sample_items_service.dart';

import '../../../../helpers/riverpod.dart';

void main() {
  group('Sample items service', () {
    test('provides three items', () async {
      final container = createContainer();

      final model = container.read(sampleItemsServiceProvider);
      check(model.items.length).equals(3);
    });
  });
}
