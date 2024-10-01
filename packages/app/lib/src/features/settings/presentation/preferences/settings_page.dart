/// This library
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router.gr.dart';
import '../../../auth/application/auth_service.dart';
import '../../application/settings_service.dart';

/// {@template our_democracy.features.settings.presentation.preferences}
/// Display the various settings that can be customized by the user.
///
/// When a user changes a setting, this updates the [SettingsService] and
/// [Widget]s that watch the [SettingsService] are rebuilt.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class SettingsPage extends ConsumerWidget {
  /// {@macro our_democracy.features.settings.presentation.preferences}
  ///
  /// Construct a new [SettingsPage] widget.
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsService = ref.watch(settingsServiceProvider);
    final themeMode = settingsService.themeMode;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          // Glue the `settingsServiceProvider` to the theme selection `DropdownMenu`.
          //
          // When a user selects a theme from the dropdown list, the
          // `settingsServiceProvider` is updated, which rebuilds the `MaterialApp`.
          child: Container(
            alignment: Alignment.topLeft,
            child: DropdownMenu(
              // Read the selected themeMode from the controller
              initialSelection: themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onSelected: (theme) async {
                final newTheme = theme ?? settingsService.themeMode;

                await ref
                    .read(settingsServiceProvider.notifier)
                    .updateThemeMode(newTheme);
              },
              label: const Text('Theme'),
              dropdownMenuEntries: const [
                DropdownMenuEntry(
                  value: ThemeMode.system,
                  label: 'System Theme',
                  leadingIcon: Icon(Icons.brightness_medium),
                ),
                DropdownMenuEntry(
                  value: ThemeMode.light,
                  label: 'Light Theme',
                  leadingIcon: Icon(Icons.brightness_5),
                ),
                DropdownMenuEntry(
                  value: ThemeMode.dark,
                  label: 'Dark Theme',
                  leadingIcon: Icon(Icons.brightness_3),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            alignment: Alignment.topLeft,
            child: FilledButton(
              onPressed: () async {
                await ref.read(authServiceProvider.notifier).logOutUser();
                if (!context.mounted) return;
                await context.router.push(LoginRoute());
              },
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              child: const Text('Log Out'),
            ),
          ),
        ),
      ],
    );
  }
}
