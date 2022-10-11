import "package:flutter/material.dart";
import "package:amity/app_config.dart";
import "package:amity/providers/configuration_provider.dart";
import "package:amity/providers/security_provider.dart";
import "package:provider/provider.dart";
import 'package:amity/providers/user_details_provider.dart';

import "amity.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const environment =
      String.fromEnvironment("environment", defaultValue: "develop");
  await AppConfig.forEnvironment(environment).then(
    (_) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ConfigurationProvider()),
          ChangeNotifierProvider(create: (context) => SecurityProvider()),
          ChangeNotifierProvider(create: (context) => UserDetailsProvider())
        ],
        child: Amity(),
      ),
    ),
  );
}
