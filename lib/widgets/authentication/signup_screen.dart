/// Sign up page, where user can enter his desired pin.
import 'dart:ui';

import "package:flutter/material.dart";
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import "package:amity/constants/app_constants.dart";
import 'package:amity/controllers/authentication_controller.dart';
import 'package:amity/providers/security_provider.dart';
import 'package:amity/providers/user_details_provider.dart';
import 'package:amity/schemas/configuration_schema.dart';
import "package:amity/utils/widget_utils.dart";
import 'package:amity/widgets/authentication/signup_success_screen.dart';

class SignupScreen extends StatefulWidget {
  static String routeName = "auth/sign-up/";

  const SignupScreen({super.key});
  @override
  _SignupScreen createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showLoader = false;

  void _signup(email, password, context) async {
    try {
      setState(() {
        _showLoader = true;
      });

      await AuthenticationController().signUp(email, password);
      await Provider.of<SecurityProvider>(context, listen: false).setUserPin();
      await Provider.of<UserDetailsProvider>(context, listen: false)
          .saveUserDetailsToFile(
              [ConfigurationSchema(key: "emailId", value: email)]);

      Navigator.of(context).pushReplacementNamed(SignupSuccessScreen.routeName);
    } catch (e, stackTrace) {
      setState(() {
        _showLoader = false;
      });
      print(stackTrace);
      CommonWidgets.showSnackbar("User signup failed. Please try again.",
          Constants.MESSAGE_ERROR, _scaffoldKey.currentContext as BuildContext);
    }
  }

  Widget _prepareTextFormField(
      String labelText, TextEditingController controller, double paddingBottom,
      {bool obscureText = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: paddingBottom),
      child: TextFormField(
          controller: controller,
          enableSuggestions: false,
          autocorrect: false,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paddingAllDirection = MediaQuery.of(context).size.width / 14;
    final pillWidth =
        MediaQuery.of(context).size.width / 3 - paddingAllDirection;
    TextEditingController userPassword = TextEditingController();
    TextEditingController userPasswordConfirm = TextEditingController();
    TextEditingController email = TextEditingController();

    return LoadingOverlay(
      isLoading: _showLoader,
      progressIndicator: CircularProgressIndicator(
        color: Color.fromRGBO(231, 240, 117, 1),
      ),
      color: Color.fromRGBO(252, 245, 227, 1),
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          key: _scaffoldKey,
          body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: paddingAllDirection, vertical: paddingAllDirection),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: CommonWidgets.getProgressBars([
                    Color.fromRGBO(231, 240, 117, 1),
                    Colors.white,
                    Colors.white,
                  ], pillWidth, 10),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: paddingAllDirection),
                  child: Center(
                    child: Text(
                      "Step 1 of 3",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: paddingAllDirection),
                  child: Text(
                    "Fill in your login details",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      _prepareTextFormField('Email', email, paddingAllDirection,
                          obscureText: false),
                      _prepareTextFormField(
                          'Password', userPassword, paddingAllDirection),
                      _prepareTextFormField('Confirm password',
                          userPasswordConfirm, paddingAllDirection)
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () => (userPasswordConfirm.text ==
                            userPassword.text)
                        ? _signup(email.text, userPasswordConfirm.text, context)
                        : null,
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
                      "Continue",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
