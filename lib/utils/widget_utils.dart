import "package:flutter/material.dart";
import "package:amity/constants/app_constants.dart";
import 'package:amity/widgets/canvas/rectangle.dart';

class CommonWidgets {
  /// + method: showSnackbar.
  /// + parameters: content, to be displayed on snack bar.
  ///               type, success or error type of message(Constants.MESSAGE_SUCCESS/MESSAGE_ERROR)
  ///               context, BuildContext/current context
  /// + description: shows a snack bar at the bottom of the screen.
  /// + returns: void.
  static void showSnackbar(String content, String type, BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          margin: EdgeInsets.all(0),
          child: Text(
            content,
            textAlign: TextAlign.center,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Constants.getSnackbarColor(type),
      ),
    );
  }

  static Widget getProgressBars(
      List<Color> colors, double barWidth, double barHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: colors
          .map((color) => SizedBox(
                width: barWidth,
                height: 10,
                child: CustomPaint(
                    painter: Rectangle(
                        color, Offset(0, 0), Size(barWidth, barHeight))),
              ))
          .toList(),
    );
  }

  static Widget getFooterButton(
      {required double screenWidth,
      required Icon icon,
      String? iconText,
      String? routeName,
      required BuildContext context}) {
    return SizedBox(
      width: screenWidth / 4,
      height: screenWidth / 6,
      child: ClipRect(
        child: Material(
          borderRadius: BorderRadius.circular(6),
          color: routeName == null
              ? Color.fromRGBO(177, 223, 231, 1)
              : Color.fromRGBO(216, 239, 243, 1),
          child: InkWell(
            splashColor: Color.fromRGBO(216, 239, 243, 1),
            onTap: () => routeName != null
                ? Navigator.of(context).pushReplacementNamed(routeName)
                : {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                icon,
                Text(
                  iconText ?? "",
                  style: Theme.of(context).textTheme.button,
                ), // <-- Text
              ],
            ),
          ),
        ),
      ),
    );
  }
}
