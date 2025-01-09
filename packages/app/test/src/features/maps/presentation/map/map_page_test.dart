import 'package:checks/checks.dart';
import 'package:dio/dio.dart';
import 'package:flutter_checks/flutter_checks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus/src/features/map/presentation/items/map_page.dart';
import 'package:nexus/src/utils/dio.dart';

import '../../../../../helpers/accessibility.dart';
import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/pump_app.dart';

HttpClientAdapter _getMockAdapter() {
  final mockDioAdapter = MockDioAdapter();
  // ignore: discarded_futures - Must not be async for Mocktail to work.
  when(() => mockDioAdapter.fetch(any(), any(), any())).thenAnswer(
    (_) => Future.value(
      ResponseBody(Stream.value(TileProvider.transparentImage), 200),
    ),
  );

  return mockDioAdapter;
}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  group('MapPage', () {
    testWidgets('should display more information', (tester) async {
      const widget = MapPage();

      final mockDioAdapter = _getMockAdapter();

      // Pump the widget to build it
      // Pumping the widget will run the build method and return the widget
      // that was built
      await tester.pumpApp(
        widget,
        overrides: [
          dioAdapterProvider.overrideWithValue(mockDioAdapter),
        ],
      );

      // Verify that the widget displays the expected information
      check(find.byType(FlutterMap)).findsOne();
    });
  });

  testAccessibilityGuidelines(
    const MapPage(),
    expectedFailures: const ExpectedFailures(
      buttons: true, // `flutter_map` does not have accessible buttons.
    ),
    overrides: [
      dioAdapterProvider.overrideWith((ref) => _getMockAdapter()),
    ],
  );
}
