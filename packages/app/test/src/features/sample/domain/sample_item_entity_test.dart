import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:our_democracy/src/features/sample/domain/sample_item_entity.dart';

void main() {
  test('SampleItemEntity should correctly wrap an int', () {
    const entity = SampleItemEntity(1);
    check(entity).isA<int>();
    check(entity.id).equals(1);
  });
}
