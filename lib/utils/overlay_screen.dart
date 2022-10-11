import 'dart:async';

import 'package:flutter/material.dart';

class OverlayScreen extends ModalRoute<void> {
  final Color color;
  final String message;
  final Icon icon;

  OverlayScreen(
      {required this.color, required this.message, required this.icon});
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => "";

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  startTime(BuildContext context) async {
    Timer(
      Duration(seconds: 3),
      () => Navigator.pop(context),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    startTime(context);
    return Container(
      color: color,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            icon,
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                message,
                style: Theme.of(context).textTheme.headline2,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
