import 'dart:convert';

import 'package:amity/schemas/user_schema.dart';
import 'package:amity/services/user_service.dart';

class UserController {
  final UserService usersService = UserService();

  Future<UserSchema> getUser(int id) async {
    return await usersService.getUser(id);
    // return UserSchema(
    //     userId: 100,
    //     firstName: "Micheal",
    //     lastName: "Scott",
    //     age: 57,
    //     bio:
    //         "I serve as the regional manager of the Scranton, Pennsylvania branch of paper company, Dunder Mifflin Inc.",
    //     interests: ["Paper", "Dancing", "Skiing", "Paintball"],
    //     contactDetails: {"mobileNumber": "+31626238326"},
    //     address: {"zipcode": "2034SC"});
  }

  Future<UserSchema> saveUser(UserSchema userSchema) async {
    return await usersService.saveUser(userSchema);
    // await Future.delayed(Duration(seconds: 2));
    // Map<String, dynamic> json = jsonDecode(jsonEncode(userSchema));
    // json["userId"] = 100;
    // return UserSchema().fromJson(json);
  }

  Future<void> updateUser(int id, UserSchema userSchema) async {
    return await usersService.updateUser(id, userSchema);
    // await Future.delayed(Duration(seconds: 2));
  }
}
