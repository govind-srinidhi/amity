//Maintains state for channel
import "dart:collection";
import 'dart:io';

import "package:flutter/material.dart";
import "package:amity/controllers/configuration_controller.dart";
import "package:amity/schemas/configuration_schema.dart";

// This class actually maintains state for users.
class UserDetailsProvider extends ChangeNotifier {
  final Map<String, ConfigurationSchema> _userDetails = {};
  final ConfigurationController _configurationController =
      ConfigurationController("user_details");

  UnmodifiableListView<ConfigurationSchema> get userDetails =>
      UnmodifiableListView(_userDetails.values);

// This method adds new configuration to store.
  void add(ConfigurationSchema configuration) {
    _userDetails[configuration.key as String] = configuration;
  }

  void loadUserDetailsProviderFromList(
      List<ConfigurationSchema> configurationSchemaList) {
    for (ConfigurationSchema configurationSchema in configurationSchemaList) {
      _userDetails[configurationSchema.key as String] = configurationSchema;
    }
  }

  ConfigurationSchema? getUserDetail(String key) {
    return _userDetails[key];
  }

  Future<List<ConfigurationSchema>> getUserDetails() async {
    List<ConfigurationSchema> configurationSchemaList =
        await _configurationController.readFileConfiguration();

    return configurationSchemaList;
  }

// This method gets configurations from repository and loads it on to store.
  Future<void> loadUserDetails() async {
    List<ConfigurationSchema> configurationSchemaList = await getUserDetails();

    for (ConfigurationSchema configurationSchema in configurationSchemaList) {
      _userDetails[configurationSchema.key as String] = configurationSchema;
    }
  }

  Future<File> saveUserDetailsToFile(
      List<ConfigurationSchema> configurations) async {
    return await _configurationController
        .saveConfigurationsToFile(configurations);
  }
}
