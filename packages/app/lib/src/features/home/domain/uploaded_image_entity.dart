import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'uploaded_image_entity.freezed.dart';

///Class for uploaded images. Contains imageID and file data
@immutable
@freezed
class UploadedImageEntity with _$UploadedImageEntity {
  ///Class for uploaded images. Contains imageID and file data
  const factory UploadedImageEntity({
    required String imageID,
    required XFile file,
  }) = _UploadedImageEntity;
}
