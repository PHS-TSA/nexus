import 'package:checks/checks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_checks/flutter_checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'pump_app.dart';

part 'accessibility.freezed.dart';

@immutable
@freezed
class ExpectedFailures with _$ExpectedFailures {
  const factory ExpectedFailures({
    @Default(false) bool androidTap,
    @Default(false) bool iosTap,
    @Default(false) bool textContrast,
    @Default(false) bool buttons,
  }) = _ExpectedFailures;
}

String expectedFailureMessage({required bool expectedToFail}) {
  return expectedToFail ? ' (SKIPPED)' : '';
}

void testAccessibilityGuidelines(
  Widget widget, {
  List<Override> overrides = const [],
  ExpectedFailures expectedFailures = const ExpectedFailures(),
}) {
  group('is accessible', () {
    testWidgets(
        'on Android.${expectedFailureMessage(expectedToFail: expectedFailures.androidTap)}',
        (tester) async {
      await tester.pumpApp(widget, overrides: overrides);

      final handle = tester.ensureSemantics();

      if (expectedFailures.androidTap) {
        await check(tester).doesNotMeetGuideline(androidTapTargetGuideline);
      } else {
        await check(tester).meetsGuideline(androidTapTargetGuideline);
      }

      handle.dispose();
    });
    testWidgets(
        'on iOS.${expectedFailureMessage(expectedToFail: expectedFailures.iosTap)}',
        (tester) async {
      await tester.pumpApp(widget, overrides: overrides);

      final handle = tester.ensureSemantics();

      if (expectedFailures.iosTap) {
        await check(tester).doesNotMeetGuideline(iOSTapTargetGuideline);
      } else {
        await check(tester).meetsGuideline(iOSTapTargetGuideline);
      }

      handle.dispose();
    });
    testWidgets(
        'according to the WCAG.${expectedFailureMessage(expectedToFail: expectedFailures.textContrast)}',
        (tester) async {
      await tester.pumpApp(widget, overrides: overrides);

      final handle = tester.ensureSemantics();

      if (expectedFailures.textContrast) {
        await check(tester).doesNotMeetGuideline(textContrastGuideline);
      } else {
        await check(tester).meetsGuideline(textContrastGuideline);
      }

      handle.dispose();
    });
    testWidgets(
        'with regard to labeling buttons.${expectedFailureMessage(expectedToFail: expectedFailures.buttons)}',
        (tester) async {
      await tester.pumpApp(widget, overrides: overrides);

      final handle = tester.ensureSemantics();

      if (expectedFailures.buttons) {
        await check(tester).doesNotMeetGuideline(labeledTapTargetGuideline);
      } else {
        await check(tester).meetsGuideline(labeledTapTargetGuideline);
      }

      handle.dispose();
    });
  });
}
