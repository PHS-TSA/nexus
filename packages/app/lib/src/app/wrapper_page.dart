/// This library wraps the application in a shared scaffold.
// ignore_for_file: prefer_expression_function_bodies

library;

import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/auth/application/auth_service.dart';
import '../features/home/application/feed_service.dart';
import '../features/home/data/post_repository.dart';
import '../features/home/domain/post_entity.dart';
import 'router.gr.dart';

/// {@template our_democracy.app.wrapper_page}
/// Wrap the pages in a Material Design scaffold.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class WrapperPage extends ConsumerWidget {
  /// {@macro our_democracy.app.wrapper_page}
  ///
  /// Construct a new [WrapperPage] widget.
  const WrapperPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsScaffold(
      routes: const [
        // TODO(MattsAttack): fix bar.
        // const EmptyShellRoute('Feeds')(
        //   children: [
        //     const LocalFeedRoute(),
        //     const WorldFeedRoute(),
        //   ],
        // ),
        LocalFeedRoute(),
        MapRoute(),
        SettingsRoute(),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () async => showDialog<void>(
          context: context,
          builder: (context) => const _Dialog(),
        ),
        child: const Icon(Icons.create),
      ),
      appBarBuilder: (context, autoRouter) {
        return AppBar(
          title: Text(autoRouter.current.title(context)),
          automaticallyImplyLeading: false,
          // leading: const AutoLeadingButton(), // @lishaduck we should discuss this back button. personally i'm for disablling it since it leads to new bugs
          // actions: switch (autoRouter.current.path) {
          //   '' => [
          //       Builder(
          //         builder: (context) => IconButton(
          //           icon: const Icon(
          //             Icons.settings,
          //             semanticLabel: 'Settings',
          //           ),
          //           onPressed: () async {
          //             // Navigate to the settings page. If the user leaves and returns
          //             // to the app after it has been killed while running in the
          //             // background, the navigation stack is restored.
          //             await context.router.push(const SettingsRoute());
          //           },
          //         ),
          //       ),
          //     ],
          //   _ => [],
          // },
          bottom: switch (autoRouter.current.path) {
            // FIXME(lishaduck): This needs some work.
            '/' => TabBar(
                onTap: autoRouter.setActiveIndex,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.my_location),
                    text: 'Local',
                  ),
                  Tab(
                    icon: Icon(Icons.public),
                    text: 'World',
                  ),
                ],
              ),
            _ => null,
          },
        );
      },
      bottomNavigationBuilder: (context, autoRouter) {
        return NavigationBar(
          selectedIndex: autoRouter.activeIndex,
          onDestinationSelected: autoRouter.setActiveIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.feed),
              label: 'Feeds',
            ),
            NavigationDestination(
              icon: Icon(Icons.location_on),
              label: 'Discover',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        );
      },
    );
  }
}

// May want to separate to a different file
class _Dialog extends HookConsumerWidget {
  const _Dialog({
    // Temporary ignore, see <dart-lang/sdk#49025>.
    // ignore: unused_element
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final title = useState('');
    final description = useState('');
    final id = ref.watch(authServiceProvider).requireValue?.$id;

    final handleSubmit = useCallback(
      () async {
        final random = Random();
        final location = await determinePosition();
        var lat = location.latitude.roundToDouble();
        var lng = location.longitude.roundToDouble();

        if (lat < 179) {
          lat += random.nextDouble();
        }

        if (lng < 179) {
          // cords can't be greater than 180
          lng += random.nextDouble();
        }

        if (!(formKey.currentState?.validate() ?? false)) return;

        formKey.currentState?.save();

        await ref
            .read(
              postRepositoryProvider(
                UserId(id!),
                null,
              ),
            ) // TODObetter way to remove !
            .createNewPost(
              title.value,
              description.value,
              lat,
              lng,
              null,
            );

        if (!context.mounted) return;
        await context.router.maybePop();

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post Created!')),
        );
      },
      [formKey],
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create a New Post'),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  initialValue: title.value,
                  onSaved: (value) {
                    if (value == null) return;

                    title.value = value;
                  },
                  decoration: const InputDecoration(label: Text('Title')),
                ),
                TextFormField(
                  initialValue: description.value,
                  onSaved: (value) {
                    if (value == null) return;

                    description.value = value;
                  },
                  decoration: const InputDecoration(label: Text('Description')),
                ),
                ElevatedButton(
                  onPressed: handleSubmit,
                  child: const Text('Create Post'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
