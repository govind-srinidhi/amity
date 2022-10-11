import 'package:amity/app_config.dart';
import 'package:amity/constants/app_constants.dart';
import 'package:amity/schemas/user_friends_schema.dart';
import 'package:amity/utils/http_utils.dart';

class UserFriendsService {
  final String path = "/find-friends";

  Future<List<UserFriendsSchema>> getFriends(int userId) async {
    HttpHandler<UserFriendsSchema> httpUtils =
        HttpHandler(modelObject: UserFriendsSchema());

    return await httpUtils.HttpGetListReponse(
        AppConfig.properties[Constants.DOMAIN_URL], "$path/$userId");
  }
}
