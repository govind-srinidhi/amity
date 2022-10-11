import "dart:io";

/// Starting point for authentication module. If pin is already registered, will be forwarded to
/// Sign-in page, otherwise will be redirected to Sign-up page.
import "package:flutter/material.dart";
import "package:amity/providers/security_provider.dart";
import "package:amity/widgets/authentication/login_screen.dart";
import "package:amity/widgets/authentication/welcome_screen.dart";
import "package:provider/provider.dart";

/// + class: Auth .
/// + description: Handles initial Route based on user authentication information
///   signup screen for first time user / signin page for existing user.
class Auth extends StatelessWidget {
  static const routeName = "/auth";

  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<SecurityProvider>(context)
        .initCompleted
        .then((value) => {
              if (value)
                {
                  if (Provider.of<SecurityProvider>(context, listen: false)
                      .devicePinSet)
                    {
                      Navigator.of(context).pushReplacementNamed(
                        LoginScreen.routeName,
                      )
                    }
                  else
                    {
                      Navigator.of(context)
                          .pushReplacementNamed(WelcomeScreen.routeName)
                    }
                }
            })
        .catchError((error) {});
    return Container();
  }
}
