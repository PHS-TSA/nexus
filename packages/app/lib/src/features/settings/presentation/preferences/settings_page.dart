/// This library
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/link.dart';

import '../../../../app/router.gr.dart';
import '../../../../app/wrapper.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/version.gen.dart';
import '../../../../utils/hooks.dart';
import '../../../auth/application/auth_service.dart';
import '../../application/settings_service.dart';

/// {@template nexus.features.settings.presentation.preferences}
/// Display the various settings that can be customized by the user.
///
/// When a user changes a setting, this updates the [SettingsService] and
/// [Widget]s that watch the [SettingsService] are rebuilt.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class SettingsPage extends ConsumerWidget {
  /// {@macro nexus.features.settings.presentation.preferences}
  ///
  /// Construct a new [SettingsPage] widget.
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Glue the `settingsServiceProvider` to the theme selection `DropdownMenu`.
    //
    // When a user selects a theme from the dropdown list, the
    // `settingsServiceProvider` is updated, which rebuilds the `MaterialApp`.
    final settingsService = ref.watch(settingsServiceProvider);
    final themeMode = settingsService.themeMode;

    return Wrapper(
      autoRouter: context.tabsRouter,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 8,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
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
                    await context.router.replace(LogInRoute());
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      applicationIcon: Assets.icons.logo.image(width: 50),
                      applicationName: 'Town Talk',
                      applicationVersion: packageVersion,
                      applicationLegalese: '© 2024 Eli D. and Matthew W.',
                      children: [
                        const SizedBox(height: 24),
                        Link(
                          uri: Uri.https('github.com', 'PHS-TSA/nexus'),
                          target: LinkTarget.blank,
                          builder: (context, followLink) {
                            return _AppDescription(followLink: followLink);
                          },
                        ),
                      ],
                    );
                  },
                  child: const Text('About'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppDescription extends HookWidget {
  const _AppDescription({super.key, this.followLink});

  final FollowLink? followLink;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textStyle = theme.textTheme.bodyMedium;

    final tapGestureRecognizer = useTapGestureRecognizer(onTap: followLink);

    return Text.rich(
      TextSpan(
        style: textStyle,
        children: [
          const TextSpan(
            text:
                'Town Talk is a new kind of public forum. '
                'View the source at ',
          ),
          TextSpan(
            style: textStyle?.copyWith(color: theme.colorScheme.primary),
            text: 'github:PHS-TSA/nexus',
            recognizer: tapGestureRecognizer,
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<GestureTapCallback?>.has('followLink', followLink),
    );
  }

  // coverage:ignore-end
}
