import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'uploaded_image_entity.freezed.dart';

/// {@template nexus.features.home.domain.uploaded_image}
/// Class for uploaded images. Contains imageIds and file data.
/// {@endtemplate}
@immutable
@freezed
class UploadedImageEntity with _$UploadedImageEntity {
  /// {@macro nexus.features.home.domain.uploaded_image}
  const factory UploadedImageEntity({
    required String imageId,
    required XFile file,
  }) = _UploadedImageEntity;
}
