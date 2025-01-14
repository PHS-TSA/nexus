import 'package:meta/meta.dart';

/// Represent the unique id of a user.
@immutable
extension type const UserId(String id) {
  /// Convert a JSON [String] to a [UserId].
  factory UserId.fromJson(String json) => UserId(json);

  /// Convert a [UserId] to a JSON [String].
  String toJson() => id;
}
