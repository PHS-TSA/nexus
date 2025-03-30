import 'package:json_annotation/json_annotation.dart';

/// {@template harvest_hub.utils.json.DateTime}
/// Convert a [DateTime] to a JSON [String] in ISO8601 format with no offset (i.e., UTC).
/// {@endtemplate}
class DataTimeJsonConverter extends JsonConverter<DateTime, String> {
  /// {@macro harvest_hub.utils.json.DateTime}
  const DataTimeJsonConverter();

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime object) {
    /// Redundant once google/json_serializable.dart#1371 is resolved.
    return object.toUtc().toIso8601String();
  }
}
