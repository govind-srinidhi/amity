/// Starting point of the application. Localization, routes, themes are registered here.
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import 'package:amity/route_config.dart';
import 'package:amity/theme_config.dart';
import 'package:amity/widgets/authentication/auth.dart';

class Amity extends StatefulWidget {
  const Amity({super.key});

  @override
  AmityState createState() => AmityState();
}

class AmityState extends State<Amity> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Amity",
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.theme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      home: Auth(),
      routes: RouteConfig.routes,
    );
  }
}
