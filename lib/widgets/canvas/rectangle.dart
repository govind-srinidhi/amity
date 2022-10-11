import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Rectangle extends CustomPainter {
  Color fillColor;
  Offset offset;
  Size size;

  Rectangle(this.fillColor, this.offset, this.size);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    //a rectangle
    canvas.drawRect(offset & size, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
