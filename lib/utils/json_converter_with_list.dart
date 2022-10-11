abstract class JSONConverterWithList<T> {
  /// + method: fromJson.
  /// + parameters: Map json.
  /// + description: converts JSON Map to Object.
  /// + returns: Object.
  T fromJson(Map<String, dynamic> json);

  /// + method: toJson.
  /// + parameters: None.
  /// + description: Converts Object to Map.
  /// + returns: Map of object as JSON name value pair.
  Map<String, dynamic> toJson();

  /// + method: toListJson.
  /// + parameters: None.
  /// + description: Converts Object to List of Map.
  /// + returns:List of Map composing object as JSON name value pair.
  List<Map<String, dynamic>> toListJson();

  /// + method: fromListJson.
  /// + parameters: String json.
  /// + description: Converts String to Object.
  /// + returns: Object.
  T fromListJson(String json);
}
