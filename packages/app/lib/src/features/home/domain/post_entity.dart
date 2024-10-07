/// This library contains a data class representing a singular post.
library;

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'post_entity.freezed.dart';

extension type const UserId(String id) {}

/// {@template our_democracy.features.home.domain.post}
/// Represent a post, which is a single item in a feed.
/// {@endtemplate}
@immutable
@freezed
sealed class PostEntity with _$PostEntity {
  /// {@macro our_democracy.features.home.domain.post}
  ///
  /// Create a new, immutable instance of [PostEntity].
  const factory PostEntity({
    /// The textual content of the post.
    required String description,

    /// The title of the post.
    required String headline,

    /// The author of the post.
    required UserId author,

    ///
    required LatLng location,

    ///
    required DateTime timestamp,

    /// An optional media to display alongside the post.
    required ImageProvider? image,

    //TODO when implementing likes add numberOfLikes here
  }) = _PostEntity;
}
