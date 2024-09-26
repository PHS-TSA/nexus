/// This library
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router.gr.dart';
import '../../../auth/data/auth_repository.dart';
import '../../application/settings_service.dart';

/// {@template our_democracy.features.settings.presentation.preferences}
/// Display the various settings that can be customized by the user.
///
/// When a user changes a setting, this updates the [SettingsService] and
/// [Widget]s that watch the [SettingsService] are rebuilt.
/// {@endtemplate}
@RoutePage()
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
          // Glue the SettingsController to the theme selection DropdownButton.
          //
          // When a user selects a theme from the dropdown list, the
          // SettingsController is updated, which rebuilds the MaterialApp.
          child: Container(
            alignment: Alignment.topLeft,
            child: DropdownButton(
              // Read the selected themeMode from the controller
              value: themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: (theme) async {
                final newTheme = theme ?? settingsService.themeMode;

                await ref
                    .read(settingsServiceProvider.notifier)
                    .updateThemeMode(newTheme);
              },
              items: const [
                DropdownMenuItem(
                  key: ValueKey(ThemeMode.system),
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  key: ValueKey(ThemeMode.light),
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  key: ValueKey(ThemeMode.dark),
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          // Glue the SettingsController to the theme selection DropdownButton.
          //
          // When a user selects a theme from the dropdown list, the
          // SettingsController is updated, which rebuilds the MaterialApp.
          child: Container(
            alignment: Alignment.topLeft,
            child: FilledButton(
              onPressed: () async {
                await ref.read(authRepositoryProvider).logoutUser();
                await context.router.push(LoginRoute());
              } //Add log out method
              ,
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
