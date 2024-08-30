import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/src/l10n/l10n.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('l10n', () {
    testWidgets('Should just be a shorthand.', (widgetTester) async {
      // Pump the widget to build it
      // Pumping the widget will run the build method and return the widget
      // that was built
      await widgetTester.pumpApp(const _Widget());
    });
  });
}

class _Widget extends StatelessWidget {
  const _Widget();

  @override
  Widget build(BuildContext context) {
    assert(
      context.l10n == AppLocalizations.of(context),
      'The context.l10n should be equal to AppLocalizations.of(context)',
    );

    return Container();
  }
}
