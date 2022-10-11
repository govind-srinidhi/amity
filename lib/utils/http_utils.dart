import "dart:convert";
import "package:http/http.dart" as http;
import "package:amity/utils/json_converter_with_list.dart";

class HttpHandler<T extends JSONConverterWithList> {
  final T? modelObject;

  HttpHandler({this.modelObject});

  Future<T> HttpPost(String url, String path,
      [Map<String, String>? headers]) async {
    final response = await http.post(
      Uri.https(url, path),
      headers: headers,
      body: modelObject?.toJson().toString(),
    );
    if (response.statusCode == 200) {
      return response.body == ""
          ? modelObject
          : modelObject?.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      throw Exception('Not possible dude!');
    }
  }

  Future<bool> HttpDelete(String url, String path,
      [Map<String, String>? headers]) async {
    final response = await http.delete(
      Uri.https(url, path),
      headers: headers,
    );
    return (response.statusCode == 204);
  }

  Future<T> HttpPut(String url, String path,
      [Map<String, String>? headers]) async {
    final response = await http.put(
      Uri.https(url, path),
      headers: headers,
      body: modelObject?.toJson().toString(),
    );

    if (response.statusCode == 204) {
      return modelObject as T;
    } else {
      throw Exception("Failed to send your request.");
    }
  }

  Future<T> HttpGetReponse(String url, String path,
      [Map<String, String>? headers,
      Map<String, String>? queryParameters]) async {
    final response =
        await http.get(Uri.https(url, path, queryParameters), headers: headers);
    ;

    if (response.statusCode == 200) {
      return modelObject?.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to send your request.");
    }
  }

  Future<List<T>> HttpGetListReponse(String url, String path,
      [Map<String, String>? headers,
      Map<String, String>? queryParameters]) async {
    final response =
        await http.get(Uri.https(url, path, queryParameters), headers: headers);

    if (response.statusCode == 200) {
      var listReponseJson = jsonDecode(response.body) as List;
      List<T> listResponse = listReponseJson
          .map((object) => modelObject?.fromJson(object))
          .toList()
          .cast<T>();
      return listResponse;
    } else {
      throw Exception("Failed to send your request.");
    }
  }
}
