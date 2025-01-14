import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/uploaded_image_entity.dart';

part 'uploaded_image_service.g.dart';

@riverpod
class UploadedImagesService extends _$UploadedImagesService {
  @override
  IList<UploadedImageEntity> build() {
    return const IList.empty();
  }

  void addImage(UploadedImageEntity image) {
    state = state.add(image);
  }

  void removeImage(String imageId) {
    // Again, our state is immutable. So we're making a new list instead of
    // changing the existing list.
    state = state.remove(
      state.firstWhere((element) => element.imageID == imageId),
    );
  }
}
