import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import "package:amity/constants/app_constants.dart";
import "package:amity/providers/security_provider.dart";
import 'package:amity/widgets/authentication/signup_screen.dart';
import "package:provider/provider.dart";

class WelcomeScreen extends StatelessWidget {
  static String routeName = "auth/welcome/";
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  WelcomeScreen({super.key});

  void proceedWithSignUp(BuildContext context) async {
    bool initCompleted =
        await Provider.of<SecurityProvider>(context, listen: false)
            .initCompleted;
    if (!initCompleted) {
      await Provider.of<SecurityProvider>(context, listen: false)
          .initSecurity();
    }

    await Navigator.of(_scaffoldKey.currentContext as BuildContext)
        .pushReplacementNamed(
      SignupScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final paddingAllDirection = MediaQuery.of(context).size.width / 14;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: paddingAllDirection, vertical: paddingAllDirection),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              "assets/images/logo.svg",
              fit: BoxFit.contain,
            ),
            Padding(
              padding: EdgeInsets.all(paddingAllDirection),
              child: Text(
                'Create a profile in 3 easy steps',
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(paddingAllDirection),
              child: ElevatedButton(
                onPressed: () => proceedWithSignUp(context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(216, 239, 243, 1)),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                      TextStyle(color: Colors.black, fontSize: 20)),
                  padding: MaterialStateProperty.all(EdgeInsets.all(15.0)),
                  minimumSize: Constants.largeSizeButton,
                  elevation: MaterialStateProperty.all<double>(0),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(6))),
                ),
                child: Text(
                  "Create my profile",
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
