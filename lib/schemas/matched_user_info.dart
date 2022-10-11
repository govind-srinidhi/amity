import 'dart:convert';

import 'package:amity/schemas/user_schema.dart';
import 'package:amity/utils/json_converter.dart';

class MatchedUserInfoSchema extends JSONConverter {
  final UserSchema? matchedUser;
  final double? distance;
  final Map<String, dynamic>? userAddress;

  MatchedUserInfoSchema({this.matchedUser, this.distance, this.userAddress});

  Map<String, dynamic> toMap() {
    return {
      "matchedUser": matchedUser,
      "userAddress": userAddress,
      "distance": distance ?? 5
    };
  }

  @override
  MatchedUserInfoSchema fromJson(Map<String, dynamic> json) {
    return MatchedUserInfoSchema(
        matchedUser: UserSchema().fromJson(json["matchedUser"]),
        userAddress: json["userAddress"],
        distance: json["distance"] ?? 5);
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      stringify("matchedUser"): jsonEncode(matchedUser),
      stringify("userAddress"): jsonEncode(userAddress),
      stringify("distance"): distance ?? 5
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
