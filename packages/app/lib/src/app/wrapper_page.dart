/// This library wraps the application in a shared scaffold.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
        onPressed: () async => _dialogBuilder(context),
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

  Future<void> _dialogBuilder(BuildContext context, WidgetRef ref) {
    // final formKey = useMemoized(GlobalKey<FormState>.new);

    // final headline = useState('');
    // final description = useState('');
    // TODOadd images

    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    final postRepo = ref.watch(
      postRepositoryProvider(const UserId('0')),
    ); // Add user id here

    return showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Add New Todo'),
            ),
            body: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(label: Text('Title')),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(label: Text('Description')),
                ),
                ElevatedButton(
                  onPressed: () {
                    // provider.createNewTodo(
                    //     titleController.text, descriptionController.text,);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Todo Added')),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Create Todo'),
                ),
              ],
            ),
          ),
          // child: Scaffold(
          //   appBar: AppBar(
          //     title: const Text('Add New Todo'),
          //   ),
          //   body: Form( // Maybe change structure to be closer to login page (container)
          //     key: formKey,
          //     child: Column(
          //       children: [
          //         TextFormField(
          //           initialValue: headline.value,
          //           onSaved: (value) {
          //             if (value == null) return;

          //             headline.value = value;
          //           },
          //           decoration: const InputDecoration(label: Text('Title')),
          //         ),
          //         TextFormField(
          //           initialValue: description.value,
          //           onSaved: (value) {
          //             if (value == null) return;

          //             description.value = value;
          //           },
          //           decoration:
          //               const InputDecoration(label: Text('Description')),
          //         ),
          //         ElevatedButton(
          //           onPressed: () {
          //             // provider.createNewTodo(
          //             //   titleController.text,
          //             //   descriptionController.text,
          //             // );
          //             ScaffoldMessenger.of(context).showSnackBar(
          //               const SnackBar(content: Text('Post Created!')),
          //             );
          //             Navigator.of(context).pop();
          //           },
          //           child: const Text('Create Post'),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        );
      },
    );
  }
}
