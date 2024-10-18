import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_checks/flutter_checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus/src/app/app.dart';
import 'package:nexus/src/features/auth/data/auth_repository.dart';
import 'package:nexus/src/features/settings/application/settings_service.dart';
import 'package:nexus/src/features/settings/data/preferences_repository.dart';
import 'package:nexus/src/l10n/l10n.dart';

import '../../helpers/mocks.dart';

extension _WidgetTesterX on WidgetTester {
  Future<void> pumpWidgetPage() async {
    final mockAuthRepository = MockAuthRepository();
    when(mockAuthRepository.checkUserAuth).thenAnswer((_) => Future.value());

    await pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          initialSettingsProvider.overrideWithValue(defaultSettings),
        ],
        child: const App(),
      ),
    );
    await pumpAndSettle(); // FIXME: Fails on CI runners, but works fine locally.
  }
}

void main() {
  group('App (SKIPPED)', skip: 'Fails in CI', () {
    testWidgets('should build MaterialApp.router', (tester) async {
      await tester.pumpWidgetPage();
      check(find.byType(MaterialApp)).findsOne();
    });

    testWidgets('should have correct restorationScopeId', (tester) async {
      await tester.pumpWidgetPage();
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      check(app.restorationScopeId).equals('app');
    });

    testWidgets('should have correct localizationsDelegates', (tester) async {
      await tester.pumpWidgetPage();
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      check(app.localizationsDelegates)
          .equals(AppLocalizations.localizationsDelegates);
    });

    testWidgets('should have correct supportedLocales', (tester) async {
      await tester.pumpWidgetPage();
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      check(app.supportedLocales).equals(AppLocalizations.supportedLocales);
    });
  });
}
