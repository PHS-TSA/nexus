import 'dart:typed_data';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/uploaded_image_entity.dart';

part 'uploaded_image_service.g.dart';

/// Contains all currently [UploadedImageEntity]s.
@riverpod
class UploadedImagesService extends _$UploadedImagesService {
  @override
  IList<UploadedImageEntity> build() {
    return const IList.empty();
  }

  /// Add an image to the upload queue.
  void addImage(UploadedImageEntity image) {
    state = state.add(image);
  }

  /// Remove image from the upload queue by id.
  void removeImage(String imageId) {
    // Again, our state is immutable. So we're making a new list instead of
    // changing the existing list.
    state = state.removeWhere((element) => element.imageId == imageId);
  }
}

/// Contains the cached bytes of a currently [UploadedImageEntity] by id.
@riverpod
Future<Uint8List> uploadedImagesBytes(Ref ref, String imageId) async {
  final uploadedImages = ref.watch(uploadedImagesServiceProvider);
  final image = uploadedImages.firstWhere((img) => img.imageId == imageId);

  return await image.file.readAsBytes();
}
