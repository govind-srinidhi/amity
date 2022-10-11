//Maintains state for channel
import "dart:collection";
import 'dart:io';

import "package:flutter/material.dart";
import "package:amity/controllers/configuration_controller.dart";
import "package:amity/schemas/configuration_schema.dart";

// This class actually maintains state for configurations.
class ConfigurationProvider extends ChangeNotifier {
  final Map<String, ConfigurationSchema> _configurations = {};
  final ConfigurationController _configurationController =
      ConfigurationController("configurations");

  UnmodifiableListView<ConfigurationSchema> get configurations =>
      UnmodifiableListView(_configurations.values);

// This method adds new configuration to store.
  void add(ConfigurationSchema configuration) {
    _configurations[configuration.key as String] = configuration;
  }

  void loadConfigurationsProviderFromList(
      List<ConfigurationSchema> configurationSchemaList) {
    for (ConfigurationSchema configurationSchema in configurationSchemaList) {
      _configurations[configurationSchema.key as String] = configurationSchema;
    }
  }

  ConfigurationSchema? getConfiguration(String key) {
    return _configurations[key];
  }

  Future<List<ConfigurationSchema>> getConfigurations() async {
    List<ConfigurationSchema> configurationSchemaList =
        await _configurationController.readFileConfiguration();

    return configurationSchemaList;
  }

// This method gets configurations from repository and loads it on to store.
  Future<void> loadConfigurations() async {
    List<ConfigurationSchema> configurationSchemaList =
        await getConfigurations();

    for (ConfigurationSchema configurationSchema in configurationSchemaList) {
      _configurations[configurationSchema.key as String] = configurationSchema;
    }
  }

  Future<File> saveConfigurationsToFile(
      List<ConfigurationSchema> configurations) async {
    return await _configurationController
        .saveConfigurationsToFile(configurations);
  }
}
