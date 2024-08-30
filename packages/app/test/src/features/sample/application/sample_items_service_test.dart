import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/src/features/sample/application/sample_items_service.dart';

void main() {
  group('Sample items service', () {
    test('provides three items', () async {
      final container = ProviderContainer();

      final model = await container.read(sampleItemsServiceProvider.future);
      check(model.items.length).equals(3);
    });
  });
}
