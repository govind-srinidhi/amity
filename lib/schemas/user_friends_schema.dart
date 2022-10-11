import 'dart:convert';

import 'package:amity/schemas/user_interests_schema.dart';
import 'package:amity/schemas/user_schema.dart';
import 'package:amity/utils/json_converter.dart';

class UserFriendsSchema extends JSONConverter {
  final UserSchema? user;
  final UserInterestsSchema? userInterest;
  final UserInterestsSchema? matchedInterests;
  final double? distance;

  UserFriendsSchema(
      {this.user, this.userInterest, this.matchedInterests, this.distance});

  // Convert a user interests into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      "user": user,
      "userInterest": userInterest,
      "matchedInterests": matchedInterests,
      "distance": distance ?? 5
    };
  }

  @override
  UserFriendsSchema fromJson(Map<String, dynamic> json) {
    return UserFriendsSchema(
        user: UserSchema().fromJson(json["user"]),
        userInterest: UserInterestsSchema().fromJson(json["userInterest"]),
        matchedInterests:
            UserInterestsSchema().fromJson(json["matchedInterests"]),
        distance: json["distance"] ?? 5);
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      stringify("user"): jsonEncode(user),
      stringify("userInterest"): jsonEncode(userInterest),
      stringify("matchedInterests"): jsonEncode(matchedInterests),
      stringify("distance"): distance ?? 5
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
