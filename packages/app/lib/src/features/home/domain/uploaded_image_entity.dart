import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'uploaded_image_entity.freezed.dart';

@immutable
@freezed
class UploadedImageEntity with _$UploadedImageEntity {
  const factory UploadedImageEntity({
    required String imageID,
    required XFile file,
  }) = _UploadedImageEntity;
}
