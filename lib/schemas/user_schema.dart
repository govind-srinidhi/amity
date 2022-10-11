// The Configuration class to define schema of a configuration table.

import 'dart:convert';
import 'dart:core';

import "package:amity/utils/json_converter.dart";

import 'configuration_schema.dart';

class UserSchema extends JSONConverter {
  final int? userId;
  final String? firstName;
  final String? lastName;
  final int? age;
  final Map<String, dynamic>? contactDetails;
  final Map<String, dynamic>? address;
  final List<dynamic>? interests;
  final String? bio;
  final String? emailId;
  final String? gender = "N/A";

  UserSchema(
      {this.userId,
      this.firstName,
      this.lastName,
      this.age,
      this.contactDetails,
      this.address,
      this.interests,
      this.bio,
      this.emailId});

  // Convert a Configuration into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "age": age,
      "userId": userId,
      "contactDetails": contactDetails,
      "address": address,
      "interests": interests,
      "bio": bio,
      "emailId": emailId,
      "gender": gender
    };
  }

  @override
  UserSchema fromJson(Map<String, dynamic> json) {
    return UserSchema(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        age: json["age"],
        contactDetails: json["contactDetails"],
        address: json["address"],
        interests: json["interests"],
        bio: json["bio"],
        emailId: json["emailId"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      stringify("firstName"): stringify(firstName),
      stringify("lastName"): stringify(lastName),
      stringify("age"): age,
      stringify("userId"): userId,
      stringify("bio"): jsonEncode(bio),
      stringify("contactDetails"): jsonEncode(contactDetails),
      stringify("address"): jsonEncode(address),
      stringify("interests"): jsonEncode(interests),
      stringify("emailId"): stringify(emailId),
      stringify("gender"): stringify(gender)
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  static UserSchema prepareUserSchemaFromConfigurations(
      List<ConfigurationSchema> configurationSchemas) {
    try {
      Map<String, dynamic> userSchema = {};
      for (ConfigurationSchema configurationSchema in configurationSchemas) {
        print('Config: $configurationSchema');
        switch (configurationSchema.key) {
          case "postalCode":
            userSchema["address"] = {"zipcode": configurationSchema.value};
            break;
          case "phoneNumber":
            userSchema["contactDetails"] = {
              "mobileNumber": {
                "phoneNumber": int.parse(configurationSchema.value as String),
                "countryCode": 31
              }
            };
            break;
          case "age":
            userSchema["age"] = int.parse(configurationSchema.value as String);
            break;
          case "interests":
            userSchema["interests"] = configurationSchema.values;
            break;
          default:
            userSchema[configurationSchema.key as String] =
                configurationSchema.value;
        }
      }
      print('User schema: ${UserSchema().fromJson(userSchema)}');
      return UserSchema().fromJson(userSchema);
    } catch (e) {
      rethrow;
    }
  }
}
