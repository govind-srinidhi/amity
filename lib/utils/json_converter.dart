import "package:amity/utils/json_converter_with_list.dart";

abstract class JSONConverter<T> extends JSONConverterWithList {
  @override
  T fromJson(Map<String, dynamic> json);
  @override
  Map<String, dynamic> toJson();
  @override
  List<Map<String, dynamic>> toListJson() {
    throw UnimplementedError();
  }

  @override
  T fromListJson(String jsonString) {
    throw UnimplementedError();
  }

  /// + method: stringify.
  /// + parameters: String value.
  /// + description: Adds double quotes to a string.
  /// + returns: String .
  String stringify(String? value) {
    value = value ?? "";
    return "\"$value\"";
  }
}
