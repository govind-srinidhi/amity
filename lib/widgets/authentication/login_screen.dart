/// Sign in page. Will be redirected, if pin is already available.
import "package:amazon_cognito_identity_dart_2/cognito.dart";
import "package:flutter/material.dart";
import "package:amity/constants/app_constants.dart";
import "package:amity/controllers/authentication_controller.dart";
import "package:amity/providers/configuration_provider.dart";
import "package:amity/providers/security_provider.dart";
import 'package:amity/providers/user_details_provider.dart';
import "package:amity/utils/widget_utils.dart";
import "package:amity/widgets/authentication/welcome_screen.dart";
import "package:provider/provider.dart";
import "package:loading_overlay/loading_overlay.dart";
import 'package:amity/widgets/profile/personal_details_screen.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "auth/login";

  const LoginScreen({super.key});

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showLoader = false;
  bool isAttemptsExceeded = false;
  // Helper added to render snack-bar

  /// Keyed in pin is validated against the password stored in cognito.
  void _validatePin(pinInput, context) async {
    try {
      setState(() {
        showLoader = true;
      });
      ;
      if (await AuthenticationController()
          .signIn(context, pinInput.toString())) {
        await Provider.of<ConfigurationProvider>(context, listen: false)
            .loadConfigurations();

        await Provider.of<UserDetailsProvider>(context, listen: false)
            .loadUserDetails();

        await Provider.of<SecurityProvider>(context, listen: false)
            .setUserPin();

        await Provider.of<SecurityProvider>(context, listen: false)
            .resetAttempts();

        Navigator.of(_scaffoldKey.currentContext as BuildContext)
            .pushNamedAndRemoveUntil(
                PersonalDetailsScreen.routeName, (route) => false);

        // Navigate to profile creation
      } else {
        if (Provider.of<SecurityProvider>(context, listen: false)
            .devicePinSet) {
          await Provider.of<SecurityProvider>(context, listen: false)
              .decrementAttemps();
          CommonWidgets.showSnackbar(
              "Your password is invalid. Please try again.",
              Constants.MESSAGE_ERROR,
              _scaffoldKey.currentContext as BuildContext);
        } else {
          CommonWidgets.showSnackbar(
              "Login attempts exceeded your information will be deleted. Please set your password again.",
              Constants.MESSAGE_ERROR,
              _scaffoldKey.currentContext as BuildContext);
        }
        setState(() {
          showLoader = false;
        });
      }
    } on CognitoClientException catch (e) {
      setState(() {
        showLoader = false;
      });
      if (e.message == Constants.PASSWORD_ATTEMPTS_EXCEEDED) {
        setState(() {
          isAttemptsExceeded = true;
        });
      }

      if (Provider.of<SecurityProvider>(context, listen: false).devicePinSet) {
        await Provider.of<SecurityProvider>(context, listen: false)
            .decrementAttemps();
        CommonWidgets.showSnackbar(
            "Your password is invalid. Please try again.",
            Constants.MESSAGE_ERROR,
            _scaffoldKey.currentContext as BuildContext);
      } else {
        CommonWidgets.showSnackbar(
            "Login attempts exceeded your information will be deleted. Please set your pin again.",
            Constants.MESSAGE_ERROR,
            _scaffoldKey.currentContext as BuildContext);

        await Navigator.of(_scaffoldKey.currentContext as BuildContext)
            .pushNamedAndRemoveUntil(WelcomeScreen.routeName, (route) => false);
      }
    } catch (e) {
      setState(() {
        showLoader = false;
      });
      if (!Provider.of<SecurityProvider>(context, listen: false).devicePinSet) {
        await Navigator.of(_scaffoldKey.currentContext as BuildContext)
            .pushNamedAndRemoveUntil(
                WelcomeScreen.routeName, (predicate) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final paddingAllDirection = MediaQuery.of(context).size.width / 14;
    TextEditingController userPassword = TextEditingController();

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        key: _scaffoldKey,
        body: LoadingOverlay(
            isLoading: showLoader,
            progressIndicator: CircularProgressIndicator(
              color: Color.fromRGBO(231, 240, 117, 1),
            ),
            color: Color.fromRGBO(252, 245, 227, 1),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: paddingAllDirection,
                  vertical: paddingAllDirection),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/login_app.png"),
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomCenter),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: Text(
                          "Log in with your password",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      )),
                  Expanded(
                      flex: 8,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: userPassword,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            validator: (String? value) {
                              String password = value?.trim() ?? '';
                              if (password.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 48.0),
                            child: ElevatedButton(
                              onPressed: () =>
                                  _validatePin(userPassword.text, context),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(216, 239, 243, 1)),
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                    TextStyle(
                                        color: Colors.black, fontSize: 20)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(15.0)),
                                minimumSize: Constants.largeSizeButton,
                                elevation: MaterialStateProperty.all<double>(0),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                        RoundedRectangleBorder(
                                            side:
                                                BorderSide(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(6))),
                              ),
                              child: Text(
                                "Login",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                          ),
                          if (isAttemptsExceeded)
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              alignment: Alignment.center,
                              child: Text(
                                "Login is temporary disabled. Please wait and try again.",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.merge(TextStyle(
                                      color: Constants.MATERIAL_COLORS[
                                          Constants.COLOR_ERROR],
                                    )),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (!isAttemptsExceeded &&
                              Provider.of<SecurityProvider>(context).attempts <=
                                  5)
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              alignment: Alignment.center,
                              child: Text(
                                "After ${Provider.of<SecurityProvider>(context).attempts} more failed login attempts, you won’t be able to access the app. ",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.merge(TextStyle(
                                      color: Constants.MATERIAL_COLORS[
                                          Constants.COLOR_ERROR],
                                    )),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      )),
                ],
              ),
            )));
  }
}
