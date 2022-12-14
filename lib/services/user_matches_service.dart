import 'package:amity/app_config.dart';
import 'package:amity/constants/app_constants.dart';
import 'package:amity/schemas/matched_user_info.dart';
import 'package:amity/schemas/user_matches_schema.dart';
import 'package:amity/utils/http_utils.dart';

class UserMatchesService {
  String path = "/user-matches";

  Future<List<MatchedUserInfoSchema>> getMatchedUsers(int userId) async {
    HttpHandler<MatchedUserInfoSchema> httpUtils =
        HttpHandler(modelObject: MatchedUserInfoSchema());
    return await httpUtils.HttpGetListReponse(
        AppConfig.properties[Constants.DOMAIN_URL], "$path/$userId");
  }

  Future<UserMatchesSchema> addMatchedUser(
      int userId, int matchedUserId) async {
    HttpHandler<UserMatchesSchema> httpUtils =
        HttpHandler(modelObject: UserMatchesSchema());
    return await httpUtils.HttpPost(AppConfig.properties[Constants.DOMAIN_URL],
        "$path/$userId/matched-with/$matchedUserId");
  }

  Future<bool> deleteMatchedUser(int userId, int matchedUserId) async {
    HttpHandler httpUtils = HttpHandler();
    return await httpUtils.HttpDelete(
        AppConfig.properties[Constants.DOMAIN_URL],
        "$path/$userId/matched-with/$matchedUserId");
  }
}
