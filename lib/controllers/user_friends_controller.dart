import 'package:amity/schemas/user_friends_schema.dart';
import 'package:amity/schemas/user_interests_schema.dart';
import 'package:amity/schemas/user_schema.dart';
import 'package:amity/services/user_friends_service.dart';

class UserFriendsController {
  final UserFriendsService userFriendsService = UserFriendsService();

  Future<List<UserFriendsSchema>> getFriends(int userId) async {
    return await userFriendsService.getFriends(userId);
    // await Future.delayed(Duration(seconds: 1));
    // return [
    //   UserFriendsSchema(
    //       user: UserSchema(
    //           userId: 100,
    //           firstName: "Micheal",
    //           lastName: "Scott",
    //           age: 57,
    //           bio:
    //               "I serve as the regional manager of the Scranton, Pennsylvania branch of paper company, Dunder Mifflin Inc."),
    //       userInterest: UserInterestsSchema(
    //           userId: 100,
    //           interests: ["Paper", "Dancing", "Skiing", "Paintball"]),
    //       matchedInterests:
    //           UserInterestsSchema(userId: 100, interests: ["Paintball"])),
    //   UserFriendsSchema(
    //       user: UserSchema(
    //           userId: 90,
    //           firstName: "Dwight",
    //           lastName: "Schrute",
    //           age: 50,
    //           bio:
    //               "Whenever I'm about to do something, I think, 'Would an idiot do that?' And if they would, I do not do that thing."),
    //       userInterest: UserInterestsSchema(
    //           userId: 90,
    //           interests: ["Paper", "Farming", "Paintball", "Karate"]),
    //       matchedInterests:
    //           UserInterestsSchema(userId: 90, interests: ["Paintball"])),
    //   UserFriendsSchema(
    //       user: UserSchema(
    //           userId: 91,
    //           firstName: "Jim",
    //           lastName: "Halpert",
    //           age: 40,
    //           bio: "I'm a sales representative at Scranton branch"),
    //       userInterest: UserInterestsSchema(
    //           userId: 91, interests: ["Paper", "Pulling pranks", "Cycling"]),
    //       matchedInterests:
    //           UserInterestsSchema(userId: 91, interests: ["Cycling"])),
    // ];
  }
}
