import 'dart:io';

import "package:amity/schemas/configuration_schema.dart";
import "package:amity/services/configuration_service.dart";

// This is  controller for all the API calls operations performed on channel.
class ConfigurationController {
  late ConfigurationService configurationService;

  ConfigurationController(String fileName) {
    configurationService = ConfigurationService(fileName);
  }

  Future<File> saveConfigurationsToFile(
      List<ConfigurationSchema> configurationData) async {
    return await configurationService
        .saveFileConfiguration(configurationData.toString());
  }

  /// + method: readFileConfiguration.
  /// + parameters: encryptionKeyTwo.
  /// + description: Read socio configuration from file.
  /// + returns: List of configuration schema type.
  Future<List<ConfigurationSchema>> readFileConfiguration() async {
    try {
      return await configurationService.readFileConfiguration();
    } catch (exception) {
      return <ConfigurationSchema>[];
    }
  }

  Future<void> deleteConfigurationFile() async {
    return await configurationService.deleteConfigurationFile();
  }
}
