// The UserInterests class to define schema of a user interests table.

import 'dart:convert';
import 'dart:core';

import "package:amity/utils/json_converter.dart";

class UserInterestsSchema extends JSONConverter {
  final int? userId;
  final List<dynamic>? interests;

  UserInterestsSchema({
    this.userId,
    this.interests,
  });

  // Convert a user interests into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "interests": interests,
    };
  }

  @override
  UserInterestsSchema fromJson(Map<String, dynamic> json) {
    return UserInterestsSchema(
      userId: json["userId"],
      interests: json["interests"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      stringify("userId"): userId,
      stringify("interests"): jsonEncode(interests),
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
