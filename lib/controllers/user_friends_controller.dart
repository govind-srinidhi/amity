import 'package:amity/schemas/user_friends_schema.dart';
import 'package:amity/services/user_friends_service.dart';

class UserFriendsController {
  final UserFriendsService userFriendsService = UserFriendsService();

  Future<List<UserFriendsSchema>> getFriends(int userId) async {
    return await userFriendsService.getFriends(userId);
  }
}
