import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;


class EdgePainter extends CustomPainter {
  EdgePainter({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
    required this.image,
    required this.color
  });

  Offset topLeft;
  Offset topRight;
  Offset bottomLeft;
  Offset bottomRight;

  ui.Image image;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    double top = 0.0;
    double left = 0.0;


    double renderedImageHeight = size.height;
    double renderedImageWidth = size.width;

    double widthFactor = size.width / image.width;
    double heightFactor = size.height / image.height;
    double sizeFactor = min(widthFactor, heightFactor);

    renderedImageHeight = image.height * sizeFactor;
    top = ((size.height - renderedImageHeight) / 2);

    renderedImageWidth = image.width * sizeFactor;
    left = ((size.width - renderedImageWidth) / 2);


    final points = [
      Offset(left + topLeft.dx * renderedImageWidth, top + topLeft.dy * renderedImageHeight),
      Offset(left + topRight.dx * renderedImageWidth, top + topRight.dy * renderedImageHeight),
      Offset(left + bottomRight.dx * renderedImageWidth, top + (bottomRight.dy * renderedImageHeight)),
      Offset(left + bottomLeft.dx * renderedImageWidth, top + bottomLeft.dy * renderedImageHeight),
      Offset(left + topLeft.dx * renderedImageWidth, top + topLeft.dy * renderedImageHeight),
    ];

    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawPoints(ui.PointMode.polygon, points, paint);

    for (Offset point in points) {
      canvas.drawCircle(point, 10, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}
