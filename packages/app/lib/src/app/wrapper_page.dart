/// This library wraps the application in a shared scaffold.
library;

import 'dart:math';

import 'package:appwrite/appwrite.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/auth/application/auth_service.dart';
import '../features/home/application/location_service.dart';
import '../features/home/data/post_repository.dart';
import '../features/home/domain/post_entity.dart';
import '../utils/hooks.dart';
import 'router.gr.dart';

/// {@template nexus.app.wrapper_page}
/// Wrap the pages in a Material Design scaffold.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class WrapperPage extends ConsumerWidget {
  /// {@macro nexus.app.wrapper_page}
  ///
  /// Construct a new [WrapperPage] widget.
  const WrapperPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsScaffold(
      routes: const [
        FeedRoutingRoute(),
        MapRoute(),
        SettingsRoute(), // Make a new feed route page that has an app bar that routes between local and world
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
              icon: Icon(Icons.map_outlined),
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
    final formKey = useGlobalKey<FormState>();
    final title = useState('');
    final description = useState('');
    final userId = ref.watch(idProvider);
    final userName = ref.watch(userNameProvider);

    final handleSubmit = useCallback(
      () async {
        final location = await ref.read(locationServiceProvider.future);
        var lat = location.latitude.roundToDouble();
        var lng = location.longitude.roundToDouble();
        final random = Random();

        // Coords can't be greater than 180.
        if (lat < 179) lat += random.nextDouble();
        if (lng < 179) lng += random.nextDouble();

        if (!(formKey.currentState?.validate() ?? false)) return;

        formKey.currentState?.save();

        await ref.read(postRepositoryProvider).createNewPost(
              PostEntity(
                headline: title.value,
                description: description.value,
                author: userId!,
                authorName: userName!,
                lat: lat,
                lng: lng,
                timestamp: DateTime.timestamp(),
                likes: const [],
                id: PostId(ID.unique()),
              ),
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
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width / 8,
        vertical: MediaQuery.sizeOf(context).height / 8,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(40),
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
                    decoration:
                        const InputDecoration(label: Text('Description')),
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
      ),
    );
  }
}
