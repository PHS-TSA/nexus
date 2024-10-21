import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/avatar_repository.dart';

part 'avatar_service.g.dart';

/// Get the user's avatar.
@riverpod
FutureOr<Uint8List> avatarService(AvatarServiceRef ref, [String? name]) {
  final avatarRepo = ref.watch(avatarProvider);

  return avatarRepo.getAvatar(name: name);
}
