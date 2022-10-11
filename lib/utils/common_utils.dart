import "dart:async";
import "dart:convert";
import "package:jwt_decode/jwt_decode.dart";
import "package:path_provider/path_provider.dart";
import "package:amity/utils/json_converter_with_list.dart";
import 'package:url_launcher/url_launcher_string.dart';

class CommonUtils {
//This method returns the application documents directory path.
  static Future<String> get localPath async {
    return (await getApplicationDocumentsDirectory()).path;
  }

//This method returns http or https url, based on the base url passed in authority
  static String getUrl(
      String baseUrl, String path, Map<String, String> queryParameters) {
    String url = "$baseUrl$path";
    if (queryParameters.isNotEmpty) {
      final queryString = Uri(queryParameters: queryParameters).query;
      url = "$url?$queryString";
    }
    return url;
  }

  static List<T> convertJSONToListSchema<T>(
      String jsonInput, JSONConverterWithList modelObject) {
    var listReponseJson = jsonDecode(jsonInput) as List;
    List<T> listResponse = listReponseJson
        .map((object) => modelObject.fromJson(object))
        .toList()
        .cast<T>();
    return listResponse;
  }

  static T convertJSONToSchema<T>(
      String jsonInput, JSONConverterWithList modelObject) {
    T response = modelObject.fromJson(jsonDecode(jsonInput));
    return response;
  }

  static String getAttributeFromJWTToken(String idToken, String attributeName) {
    Map<String, dynamic> payload = Jwt.parseJwt(idToken);
    return payload[attributeName];
  }

  static Future<void> launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      launchUrlString(url);
    } else {
      throw "Could not launch $url";
    }
  }
}
