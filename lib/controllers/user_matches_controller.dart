import 'package:amity/schemas/user_matches_schema.dart';
import 'package:amity/schemas/user_schema.dart';
import 'package:amity/services/user_matches_service.dart';

class UserMatchesController {
  final UserMatchesService userMatchesService = UserMatchesService();

  Future<List<UserSchema>> getMatchedUsers(int userId) async {
    return await userMatchesService.getMatchedUsers(userId);
  }

  Future<UserMatchesSchema> addMatchedUser(
      int userId, int matchedUserId) async {
    return await userMatchesService.addMatchedUser(userId, matchedUserId);
  }

  Future<bool> deleteMatchedUser(int userId, int matchedUserId) async {
    return await userMatchesService.deleteMatchedUser(userId, matchedUserId);
  }
}
