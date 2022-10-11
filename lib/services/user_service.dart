import 'package:amity/app_config.dart';
import 'package:amity/constants/app_constants.dart';
import 'package:amity/schemas/user_schema.dart';
import 'package:amity/utils/http_utils.dart';

class UserService {
  final String path = "/user";

  Future<UserSchema> getUser(int userId) async {
    HttpHandler<UserSchema> httpUtils =
        HttpHandler(modelObject: UserSchema(userId: userId));

    return await httpUtils.HttpGetReponse(
        AppConfig.properties[Constants.DOMAIN_URL], "$path/$userId");
  }

  Future<UserSchema> saveUser(UserSchema userSchema) async {
    HttpHandler<UserSchema> httpUtils = HttpHandler(modelObject: userSchema);

    return await httpUtils.HttpPost(
        AppConfig.properties[Constants.DOMAIN_URL],
        path,
        {'Content-Type': 'application/json', 'Accept': 'application/json'});
  }

  Future<void> updateUser(int userId, UserSchema userSchema) async {
    HttpHandler<UserSchema> httpUtils =
        HttpHandler(modelObject: UserSchema(userId: userSchema.userId));

    await httpUtils.HttpPut(
        AppConfig.properties[Constants.DOMAIN_URL], "$path/$userId");
  }
}
