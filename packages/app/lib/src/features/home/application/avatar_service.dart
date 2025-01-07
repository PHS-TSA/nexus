/// This library provides a service to get a user’s avatar.
library;

import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/avatar_repository.dart';

part 'avatar_service.g.dart';

/// Get the user's avatar.
///
/// Defaults to the current user if no [username] is provided.
@riverpod
FutureOr<Uint8List> avatarService(Ref ref, [String? username]) {
  final avatarRepo = ref.watch(avatarProvider);

  return avatarRepo.getAvatar(name: username);
}
