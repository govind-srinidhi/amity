import 'dart:async';

import 'package:flutter/material.dart';
import 'package:amity/widgets/authentication/login_screen.dart';

class SignupSuccessScreen extends StatefulWidget {
  static String routeName = "auth/sign-up/success";

  const SignupSuccessScreen({super.key});

  @override
  State<SignupSuccessScreen> createState() => _SignupSuccessScreenState();
}

class _SignupSuccessScreenState extends State<SignupSuccessScreen> {
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
      Duration(seconds: 5),
      () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen())),
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
            getHeadlineContent(context, "We\'ve sent you an email!"),
            Padding(padding: EdgeInsets.all(24.0)),
            getHeadlineContent(
                context, "You\'ll need that before you can continue.")
          ],
        ),
      ),
    );
  }
}
