import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_checks/flutter_checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexus/src/app/router.gr.dart';
import 'package:nexus/src/app/wrapper_page.dart';
import 'package:nexus/src/features/auth/application/auth_service.dart';
import 'package:nexus/src/features/auth/data/auth_repository.dart';
import 'package:nexus/src/l10n/l10n.dart';
import 'package:nexus/src/utils/design.dart';
import 'package:nexus/src/utils/router.dart';

import '../../helpers/mocks.dart';
import '../../helpers/riverpod.dart';

extension _WidgetTesterX on WidgetTester {
  Future<void> pumpWidgetPage() async {
    final mockAuthRepository = MockAuthRepository();
    when(mockAuthRepository.checkUserAuth)
        .thenAnswer((_) => Future.value(fakeUser));

    final container = createContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
    final routerSubscription = container.listen(routerProvider, (_, __) {});
    final router = routerSubscription.read();
    container.read(authServiceProvider);

    await pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router.config(),
          onGenerateTitle: (context) => context.l10n.appTitle,
          theme: theme,
          locale: const Locale('en', 'US'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );

    await router.pushAll(const [
      WrapperRoute(),
    ]);
    await pumpAndSettle();
    check(router.urlState.url).equals('/');
    check(find.byType(WrapperPage)).findsOne();
  }
}

void main() {
  group('wrapper page', () {
    group('is accessible', () {
      testWidgets('on Android.', (tester) async {
        await tester.pumpWidgetPage();

        final handle = tester.ensureSemantics();
        await check(tester).meetsGuideline(androidTapTargetGuideline);
        handle.dispose();
      });
      testWidgets('on iOS.', (tester) async {
        await tester.pumpWidgetPage();

        final handle = tester.ensureSemantics();
        await check(tester).meetsGuideline(iOSTapTargetGuideline);
        handle.dispose();
      });
      testWidgets('according to the WCAG.', (tester) async {
        await tester.pumpWidgetPage();

        final handle = tester.ensureSemantics();
        await check(tester).meetsGuideline(textContrastGuideline);
        handle.dispose();
      });
      testWidgets('with regard to labeling buttons.', (tester) async {
        await tester.pumpWidgetPage();

        final handle = tester.ensureSemantics();
        await check(tester).meetsGuideline(labeledTapTargetGuideline);
        handle.dispose();
      });
    });
  });
}
