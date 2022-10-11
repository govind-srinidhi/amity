// The Configuration class to define schema of a configuration table.

import 'dart:convert';

import "package:amity/utils/json_converter.dart";

class ConfigurationSchema extends JSONConverter {
  final String? key;
  final String? value;
  final String? type;
  final String? createdAt;
  final String? updatedAt;
  final int? id;
  final List<dynamic>? values;

  ConfigurationSchema(
      {this.id,
      this.key,
      this.value,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.values});

  // Convert a Configuration into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {"id": id, "key": key, "value": value};
  }

  factory ConfigurationSchema.fromJson(Map<String, dynamic> json) {
    return ConfigurationSchema(
        id: json["id"],
        key: json["key"],
        value: json["value"],
        values: json["values"]);
  }

  Map<String, dynamic> toMapForDatabase() {
    return <String, dynamic>{"key": key, "value": value, "values": values};
  }

  @override
  ConfigurationSchema fromJson(Map<String, dynamic> json) {
    return ConfigurationSchema(
        id: json["id"],
        key: json["key"],
        value: json["value"],
        type: json["type"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        values: json["values"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      stringify("id"): id,
      stringify("key"): stringify(key),
      stringify("value"): stringify(value),
      stringify("type"): stringify(type),
      stringify("createdAt"): stringify(createdAt),
      stringify("updatedAt"): stringify(updatedAt),
      stringify("values"): jsonEncode(values)
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
