import 'dart:convert';

import 'package:amity/schemas/user_schema.dart';
import 'package:amity/utils/json_converter.dart';

class UserMatchesSchema extends JSONConverter {
  final UserSchema? user;
  final UserSchema? matchedUser;

  UserMatchesSchema({this.user, this.matchedUser});

  // Convert a user interests into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {"user": user, "matchedUser": matchedUser};
  }

  @override
  UserMatchesSchema fromJson(Map<String, dynamic> json) {
    return UserMatchesSchema(
      user: json["user"],
      matchedUser: json["matchedUser"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      stringify("user"): jsonEncode(user),
      stringify("matchedUser"): jsonEncode(matchedUser)
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
