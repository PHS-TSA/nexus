/// This library wraps the application in a shared scaffold.
library;

import 'dart:io';
import 'dart:math';

import 'package:appwrite/appwrite.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/auth/application/auth_service.dart';
import '../features/home/application/location_service.dart';
import '../features/home/application/uploaded_image_service.dart';
import '../features/home/data/post_repository.dart';
import '../features/home/domain/post_entity.dart';
import '../features/home/domain/uploaded_image_entity.dart';
import '../utils/hooks.dart';
import 'router.gr.dart';

// final uploadedImageProvider = StateProvider<PlatformFile?>((ref) => null);

/// {@template nexus.app.wrapper_page}
/// Wrap the pages in a Material Design scaffold.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class WrapperPage extends ConsumerWidget {
  /// {@macro nexus.app.wrapper_page}
  ///
  /// Construct a new [WrapperPage] widget.
  const WrapperPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsScaffold(
      routes: const [
        FeedRoutingRoute(),
        MapRoute(),
        SettingsRoute(), // Make a new feed route page that has an app bar that routes between local and world
      ],
      floatingActionButton: FloatingActionButton(
        onPressed:
            () async => showDialog<void>(
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
                Tab(icon: Icon(Icons.my_location), text: 'Local'),
                Tab(icon: Icon(Icons.public), text: 'World'),
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
            NavigationDestination(icon: Icon(Icons.feed), label: 'Feeds'),
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
  const _Dialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useGlobalKey<FormState>();
    final title = useState('');
    final description = useState('');
    final userId = ref.watch(idProvider);
    final userName = ref.watch(userNameProvider);

    ///
    // PlatformFile? selectedFile;

    final handleSubmit = useCallback(() async {
      final uploadedImages = ref.watch(uploadedImagesServiceProvider);
      final location = await ref.read(locationServiceProvider.future);
      var lat = location.latitude.roundToDouble();
      var lng = location.longitude.roundToDouble();
      final random = Random();

      // Coords can't be greater than 180.
      if (lat < 179) lat += random.nextDouble();
      if (lng < 179) lng += random.nextDouble();

      if (!(formKey.currentState?.validate() ?? false)) return;

      formKey.currentState?.save();

      // Create a list off all uploaded images ids
      final List<String> uploadedImageIDs =
          uploadedImages.map((image) => image.imageID).toList();

      await ref
          .read(postRepositoryProvider)
          .createNewPost(
            PostEntity(
              headline: title.value,
              description: description.value,
              author: userId!,
              authorName: userName!,
              lat: lat,
              lng: lng,
              timestamp: DateTime.timestamp(),
              likes: const IList.empty(),
              id: PostId(ID.unique()),
              imageID: uploadedImageIDs, //Read in list of uploaded images ids
            ),
          );

      if (!context.mounted) return;
      await context.router.maybePop();

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post Created!')));
    }, [formKey]);

    return Dialog(
      // insetPadding: EdgeInsets.symmetric(
      //   horizontal: MediaQuery.sizeOf(context).width / 8,
      //   vertical: MediaQuery.sizeOf(context).height / 8,
      // ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Scaffold(
          appBar: AppBar(title: const Text('Create a New Post')),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  //TODOcreate guards against creating empty posts
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
                    decoration: const InputDecoration(
                      label: Text('Description'),
                    ),
                  ),
                  const _UploadedImagesView(),
                  ElevatedButton(
                    onPressed: () async {
                      //TODOupload max image count. probably 10
                      //Would also need to update post entity
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: [
                          'jpg',
                          'jpeg',
                          'png',
                          'webp',
                        ], // Might be weird on iPhones with HEIC. Could convert to png with some library
                        allowMultiple: true,
                      );

                      if (result == null) return;
                      if (result.files.length > 1) {
                        for (var i = 0; i < result.files.length; i++) {
                          ref
                              .read(uploadedImagesServiceProvider.notifier)
                              .addImage(
                                UploadedImageEntity(
                                  imageID: ID.unique(),
                                  file: result.files[i],
                                ),
                              );
                        }
                      } else {
                        ref
                            .read(uploadedImagesServiceProvider.notifier)
                            .addImage(
                              UploadedImageEntity(
                                imageID: ID.unique(),
                                file: result.files.first,
                              ),
                            );
                      }
                    },
                    child: const Text('Upload Image'),
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

class _UploadedImagesView extends HookConsumerWidget {
  const _UploadedImagesView({super.key});
  //Need to build a list of images. have it so you can horizontally scroll through images and have an x to remove them
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('this is running fr');
    final uploadedImages = ref.watch(uploadedImagesServiceProvider);
    if (uploadedImages.isEmpty) {
      return const SizedBox();
    }

    //TODOmake this scale better
    return SizedBox(
      height: 500,
      width: 500,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            uploadedImages.map((image) {
              final file = image.file;
              //TODOadd a way to remove an image
              if (kIsWeb && file.bytes != null) {
                return Image.memory(file.bytes!, width: 400, height: 400);
              } else if (file.path != null) {
                return Image.file(File(file.path!), width: 400, height: 400);
              }

              return const Placeholder();
            }).toList(),
      ),
    );
  }
}
