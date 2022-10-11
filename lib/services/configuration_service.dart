import "dart:convert";
import 'dart:io';
import "package:amity/repositories/file_repository.dart";
import "package:amity/schemas/configuration_schema.dart";

// This is a configuration service class to handle configuration request to repository.
class ConfigurationService {
  String fileName;

  ConfigurationService(this.fileName);

  Future<File> saveFileConfiguration(String enconfiguration) async {
    return await FileRepository(fileName).writeData(enconfiguration);
  }

  Future<List<ConfigurationSchema>> readFileConfiguration() async {
    FileRepository fileRepository = FileRepository(fileName);
    String configurationString = await fileRepository.readData();

    if (configurationString.isNotEmpty) {
      var listReponseJson = jsonDecode(configurationString) as List;
      return listReponseJson
          .map((object) => ConfigurationSchema().fromJson(object))
          .toList()
          .cast<ConfigurationSchema>();
    }
    return [];
  }

  Future<void> deleteConfigurationFile() async {
    FileRepository fileRepository = FileRepository(fileName);
    await fileRepository.deleteFile();
  }
}
