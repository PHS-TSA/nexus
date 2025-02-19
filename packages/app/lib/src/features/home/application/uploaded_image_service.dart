import 'dart:typed_data';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/uploaded_image_entity.dart';

part 'uploaded_image_service.g.dart';

///Provider that contains all currently uploaded images files(XFiles) and IDs(Strings)
@riverpod
class UploadedImagesService extends _$UploadedImagesService {
  @override
  IList<UploadedImageEntity> build() {
    return const IList.empty();
  }

  ///Adds image to passed in image to provider
  void addImage(UploadedImageEntity image) {
    state = state.add(image);
  }

  ///Removes image from provider based on passed in ID
  void removeImage(String imageId) {
    // Again, our state is immutable. So we're making a new list instead of
    // changing the existing list.
    state = state.remove(
      state.firstWhere((element) => element.imageID == imageId),
    );
  }
}

///Provider containing bytes of all currently uploaded images
@riverpod
Future<IList<Uint8List>> uploadedImagesBytes(Ref ref) async {
  final uploadedImages = ref.watch(uploadedImagesServiceProvider);
  final bytes = await Future.wait(
    uploadedImages.map((image) async => await image.file.readAsBytes()),
  );

  return bytes.lock;
}
