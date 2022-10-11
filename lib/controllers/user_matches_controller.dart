import 'package:amity/schemas/user_matches_schema.dart';
import 'package:amity/schemas/user_schema.dart';
import 'package:amity/services/user_matches_service.dart';

class UserMatchesController {
  final UserMatchesService userMatchesService = UserMatchesService();

  Future<List<UserSchema>> getMatchedUsers(int userId) async {
    return await userMatchesService.getMatchedUsers(userId);
    // await Future.delayed(Duration(seconds: 1));
    // return [
    //   UserSchema(
    //     userId: 100,
    //     firstName: "Micheal",
    //     lastName: "Scott",
    //     age: 57,
    //     bio:
    //         "I serve as the regional manager of the Scranton, Pennsylvania branch of paper company, Dunder Mifflin Inc.",
    //     interests: ["Paper", "Dancing", "Skiing", "Paintball"],
    //   ),
    //   UserSchema(
    //     userId: 90,
    //     firstName: "Dwight",
    //     lastName: "Schrute",
    //     age: 50,
    //     bio:
    //         "Whenever I'm about to do something, I think, 'Would an idiot do that?' And if they would, I do not do that thing.",
    //     interests: ["Paper", "Farming", "Paintball", "Karate"],
    //   )
    // ];
  }

  Future<UserMatchesSchema> addMatchedUser(
      int userId, int matchedUserId) async {
    return await userMatchesService.addMatchedUser(userId, matchedUserId);
    // await Future.delayed(Duration(seconds: 2));
    // return UserMatchesSchema(
    //   user: UserSchema(userId: userId),
    //   matchedUser: UserSchema(userId: matchedUserId),
    // );
  }

  Future<bool> deleteMatchedUser(int userId, int matchedUserId) async {
    return await userMatchesService.deleteMatchedUser(userId, matchedUserId);
    // await Future.delayed(Duration(seconds: 2));
    // return true;
  }
}
