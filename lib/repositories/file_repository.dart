import "dart:io";
import "package:path_provider/path_provider.dart";

class FileRepository {
  String fileName;

  FileRepository(this.fileName);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/$fileName.txt");
  }

  Future<File> writeData(String configurationData) async {
    final file = await _localFile;
    return await file.writeAsString(configurationData.toString());
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        String contents = await file.readAsString();
        return contents;
      }
      throw Exception("File Not loaded");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFile() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      rethrow;
    }
  }
}
