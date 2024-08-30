/// This library contains utilities for configuring a [WidgetTester].
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/src/l10n/l10n.dart';
import 'package:nexus/src/utils/design.dart';

import 'riverpod.dart';

/// Extension method for [WidgetTester.pumpWidget].
extension PumpApp on WidgetTester {
  /// Pump a [Widget] in a [ProviderScope].
  Future<void> pumpApp(
    Widget child, {
    Overrides overrides = const [],
    List<ProviderObserver>? observers,
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        observers: observers,
        child: _Widget(
          child: child,
        ),
      ),
    );

    await pumpAndSettle();
  }
}

class _Widget extends StatelessWidget {
  const _Widget({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: child,
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: theme,
      locale: const Locale('en', 'US'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
