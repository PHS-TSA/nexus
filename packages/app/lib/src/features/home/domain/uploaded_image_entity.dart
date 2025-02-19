import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'uploaded_image_entity.freezed.dart';

@immutable
@freezed
class UploadedImageEntity with _$UploadedImageEntity {
  const factory UploadedImageEntity({
    required String imageID,
    required PlatformFile file,
  }) = _UploadedImageEntity;
}
