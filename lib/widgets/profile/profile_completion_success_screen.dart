import 'dart:async';

import 'package:flutter/material.dart';
import 'package:amity/widgets/discover/discover_profiles_screen.dart';

class ProfileCompletionSuccessScreen extends StatefulWidget {
  static String routeName = "profile/success";

  const ProfileCompletionSuccessScreen({super.key});

  @override
  State<ProfileCompletionSuccessScreen> createState() =>
      _ProfileCompletionSuccessScreenState();
}

class _ProfileCompletionSuccessScreenState
    extends State<ProfileCompletionSuccessScreen> {
  Widget getHeadlineContent(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .displayLarge
          ?.merge(TextStyle(fontSize: 34)),
    );
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => DiscoverProfilesScreen())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getHeadlineContent(context, "And that's it!"),
            Padding(padding: EdgeInsets.all(24.0)),
            getHeadlineContent(context, "Go find some interesting people.")
          ],
        ),
      ),
    );
  }
}
