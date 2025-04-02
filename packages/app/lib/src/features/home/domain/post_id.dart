import 'package:meta/meta.dart';

/// Represent the unique id of a post.
@immutable
extension type const PostId(String id) {
  /// Convert a JSON [String] to a [PostId].
  factory PostId.fromJson(String json) => PostId(json);

  /// Convert a [PostId] to a JSON [String].
  String toJson() => id;
}
