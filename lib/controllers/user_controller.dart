import 'dart:convert';

import 'package:amity/schemas/user_schema.dart';
import 'package:amity/services/user_service.dart';

class UserController {
  final UserService usersService = UserService();

  Future<UserSchema> getUser(int id) async {
    return await usersService.getUser(id);
  }

  Future<UserSchema> saveUser(UserSchema userSchema) async {
    return await usersService.saveUser(userSchema);
  }

  Future<void> updateUser(int id, UserSchema userSchema) async {
    return await usersService.updateUser(id, userSchema);
  }
}
