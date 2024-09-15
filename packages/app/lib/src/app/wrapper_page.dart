import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'router.gr.dart';

@RoutePage()
class WrapperPage extends ConsumerWidget {
  const WrapperPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoRouter(
      builder: (context, child) {
        // return Scaffold(
        //   appBar: AppBar(
        //     title: Text(context.topRoute.title(context)),
        //     leading: const AutoLeadingButton(),
        //     actions: _getActions(context.router.currentUrl),
        //   ),
        //   body: child,
        // );
        return child;
      },
    );
  }
}

List<Widget> _getActions(String? path) {
  return switch (path) {
    '/' => [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.settings,
              semanticLabel: 'Settings',
            ),
            onPressed: () async {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              await context.router.push(const SettingsRoute());
            },
          ),
        ),
      ],
    _ => [],
  };
}
