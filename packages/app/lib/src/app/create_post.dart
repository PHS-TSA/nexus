import 'dart:math';

import 'package:appwrite/appwrite.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../features/auth/application/auth_service.dart';
import '../features/home/application/location_service.dart';
import '../features/home/application/uploaded_image_service.dart';
import '../features/home/data/post_repository.dart';
import '../features/home/domain/post_entity.dart';
import '../features/home/domain/uploaded_image_entity.dart';
import '../utils/hooks.dart';
import '../utils/responsive.dart';

/// {@template nexus.app.create_post}
/// A dialog that allows for a user to create a new post.
/// {@endtemplate}
class CreatePost extends HookConsumerWidget {
  /// {@macro nexus.app.create_post}
  ///
  /// Construct a new [CreatePost] widget.
  const CreatePost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useGlobalKey<FormState>();
    final title = useState('');
    final description = useState('');
    final userId = ref.watch(idProvider);
    final userName = ref.watch(userNameProvider);

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
              imageIds:
                  // Read in the list of uploaded images ids.
                  uploadedImages.map((image) => image.imageId).toIList(),
            ),
            uploadedImages,
          );

      if (!context.mounted) return;
      await context.router.maybePop();

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post Created!')));
    }, [formKey]);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          context.sizeClass == MaterialWindowSizeClass.compact ? 0.0 : 16.0,
        ),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal:
            context.sizeClass == MaterialWindowSizeClass.compact ? 0.0 : 64.0,
        vertical:
            context.sizeClass == MaterialWindowSizeClass.compact ? 0.0 : 48.0,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          context.sizeClass == MaterialWindowSizeClass.compact ? 0.0 : 16.0,
        ),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (context.sizeClass == MaterialWindowSizeClass.compact)
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await context.router.maybePop();
                        },
                        icon: const Icon(Icons.close),
                      ),
                      Text(
                        'Create a new post',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  )
                else
                  Text(
                    'Create a new post',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                const SizedBox(height: 16),

                // TODO(MattsAttack): guard against creating empty posts.
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
                const _UploadedImagesView(),
                const Spacer(),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // TODO(MattsAttack): Set a max image upload count, probably 10.
                        final picker = ImagePicker();
                        final pickedFiles = await picker.pickMultiImage();

                        for (var pickedFile in pickedFiles) {
                          final pickedFilePath = pickedFile.path;
                          //Handle IOS images
                          if (pickedFilePath.toLowerCase().contains('heic') ||
                              pickedFilePath.toLowerCase().contains('heif')) {
                            final tmpDir = (await getTemporaryDirectory()).path;
                            final target =
                                '$tmpDir/${DateTime.now().millisecondsSinceEpoch}.jpg';

                            pickedFile =
                                (await FlutterImageCompress.compressAndGetFile(
                                  pickedFilePath,
                                  target,
                                  quality: 100,
                                ))!;
                          }

                          ref
                              .read(uploadedImagesServiceProvider.notifier)
                              .addImage(
                                UploadedImageEntity(
                                  imageId: ID.unique(),
                                  file: pickedFile,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UploadedImagesView extends HookConsumerWidget {
  const _UploadedImagesView({super.key});
  // TODO(MattsAttack): Need to build a list of images. have it so you can horizontally scroll through images and have an x to remove them.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadedImages = ref.watch(uploadedImagesServiceProvider);

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        itemCount: uploadedImages.length,
        itemBuilder: (context, index) {
          final image = uploadedImages[index];
          final uploadedImage = ref.watch(
            uploadedImagesBytesProvider(image.imageId),
          );

          return switch (uploadedImage) {
            AsyncData(:final value) when value.isNotEmpty => Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(value, fit: BoxFit.cover),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    onPressed: () {
                      // Remove the specific image based on index.
                      ref
                          .read(uploadedImagesServiceProvider.notifier)
                          .removeImage(image.imageId);
                    },
                  ),
                ),
              ],
            ),
            AsyncLoading() => const CircularProgressIndicator(),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
