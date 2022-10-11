import "dart:convert";
import "package:flutter/services.dart";

// This class is for loading application configurations on global level.
class AppConfig {
  static Map<String, dynamic> properties = {};

  static Future<void> forEnvironment(String stage) async {
    print('ENV: $stage');
    // load the json file
    final contents = await rootBundle.loadString(
      "assets/config/$stage.json",
    );
    // decode our json
    AppConfig.properties = jsonDecode(contents);
  }
}
