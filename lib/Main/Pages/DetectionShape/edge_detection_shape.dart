import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_edge_detection/edge_detection.dart';
import 'package:taxdocs/Provider/app_state.dart';

import 'edge_painter.dart';
import 'touch_bubble.dart';

class EdgeDetectionShape extends StatefulWidget {
  EdgeDetectionShape({
    required this.renderedImageSize,
    required this.originalImageSize,
    required this.edgeDetectionResult,
    required this.onDrag
  });

  final Size renderedImageSize;
  final Size originalImageSize;
  final Function(Offset,int) onDrag;
  final EdgeDetectionResult edgeDetectionResult;

  @override
  _EdgeDetectionShapeState createState() => _EdgeDetectionShapeState();
}

class _EdgeDetectionShapeState extends State<EdgeDetectionShape> {
  double? edgeDraggerSize;

  EdgeDetectionResult? edgeDetectionResult;
  List<Offset>? points;

  double? renderedImageWidth;
  double? renderedImageHeight;
  double? top;
  double? left;

  Offset? currentDragPosition;

  @override
  void didChangeDependencies() {
    double shortestSide = min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    edgeDraggerSize = shortestSide / 12;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    edgeDetectionResult = widget.edgeDetectionResult;
    _calculateDimensionValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _getTouchBubbles(context),
        CustomPaint(
            painter: EdgePainter(
                points: points!,
                color: Theme.of(context).accentColor.withOpacity(0.5)
            ),
        )
      ],
    );
  }

  void _calculateDimensionValues() {
    top = 0.0;
    left = 0.0;

    double widthFactor = widget.renderedImageSize.width / widget.originalImageSize.width;
    double heightFactor = widget.renderedImageSize.height / widget.originalImageSize.height;
    double sizeFactor = min(widthFactor, heightFactor);

    renderedImageHeight = widget.originalImageSize.height * sizeFactor;
    top = ((widget.renderedImageSize.height - renderedImageHeight!) / 2);

    renderedImageWidth = widget.originalImageSize.width * sizeFactor;
    left = ((widget.renderedImageSize.width - renderedImageWidth!) / 2);

    currentDragPosition = Offset(
        left! + edgeDetectionResult!.topLeft.dx * renderedImageWidth!,
        top! + edgeDetectionResult!.topLeft.dy * renderedImageHeight!
    );
  }

  Offset _getNewPositionAfterDrag(Offset position, double renderedImageWidth, double renderedImageHeight) {
    return Offset(
        position.dx / renderedImageWidth,
        position.dy / renderedImageHeight
    );
  }

  Offset _clampOffset(Offset givenOffset) {
    double absoluteX = givenOffset.dx * renderedImageWidth!;
    double absoluteY = givenOffset.dy * renderedImageHeight!;

    return Offset(
        absoluteX.clamp(0.0, renderedImageWidth!) / renderedImageWidth!,
        absoluteY.clamp(0.0, renderedImageHeight!) / renderedImageHeight!
    );
  }

  Widget _getTouchBubbles(context) {
    points = [
      Offset(
          left! + edgeDetectionResult!.topLeft.dx * renderedImageWidth!,
          top! + edgeDetectionResult!.topLeft.dy * renderedImageHeight!
      ),
      Offset(
          left! + edgeDetectionResult!.topRight.dx * renderedImageWidth!,
          top! + edgeDetectionResult!.topRight.dy * renderedImageHeight!
      ),
      Offset(
          left! + edgeDetectionResult!.bottomRight.dx * renderedImageWidth!,
          top! + (edgeDetectionResult!.bottomRight.dy * renderedImageHeight!)
      ),
      Offset(
          left! + edgeDetectionResult!.bottomLeft.dx * renderedImageWidth!,
          top! + edgeDetectionResult!.bottomLeft.dy * renderedImageHeight!
      ),
      Offset(
          left! + edgeDetectionResult!.topLeft.dx * renderedImageWidth!,
          top! + edgeDetectionResult!.topLeft.dy * renderedImageHeight!
      ),
    ];
    // final app = Provider.of<appState>(context,listen: true);

    // print(points);

    final Function onDragFinished = () {

        // Add Your Code here.
    };

    return Container(
      width: widget.renderedImageSize.width,
      height: widget.renderedImageSize.height,
      child: Stack(
        children: [
          Positioned(
              child: TouchBubble(
                  size: edgeDraggerSize!,
                  onDrag: (position) {
                    // print(position);
                    setState(() {
                      currentDragPosition = Offset(points![0].dx, points![0].dy);
                      Offset newTopLeft = _getNewPositionAfterDrag(
                          position, renderedImageWidth!, renderedImageHeight!
                      );
                      widget.onDrag(newTopLeft, 0);
                      edgeDetectionResult!.topLeft = _clampOffset(
                          edgeDetectionResult!.topLeft + newTopLeft
                      );
                      widget.onDrag(edgeDetectionResult!.topLeft, 0);
                    });
                  },
                  onDragFinished: onDragFinished
              ),
              left: points![0].dx - (edgeDraggerSize! / 2),
              top: points![0].dy - (edgeDraggerSize! / 2)
          ),
          Positioned(
              child: TouchBubble(
                  size: edgeDraggerSize!,
                  onDrag: (position) {
                    // print(position);
                    setState(() {
                      Offset newTopRight = _getNewPositionAfterDrag(
                          position, renderedImageWidth!, renderedImageHeight!
                      );

                      edgeDetectionResult!.topRight = _clampOffset(
                          edgeDetectionResult!.topRight + newTopRight
                      );
                      widget.onDrag(edgeDetectionResult!.topRight, 1);
                      currentDragPosition = Offset(points![1].dx, points![1].dy);
                    });
                  },
                  onDragFinished: onDragFinished
              ),
              left: points![1].dx - (edgeDraggerSize! / 2),
              top: points![1].dy - (edgeDraggerSize! / 2)
          ),
          Positioned(
              child: TouchBubble(
                  size: edgeDraggerSize!,
                  onDrag: (position) {
                    // print(position);
                    setState(() {
                      Offset newBottomRight = _getNewPositionAfterDrag(
                          position, renderedImageWidth!, renderedImageHeight!
                      );

                      edgeDetectionResult!.bottomRight = _clampOffset(
                          edgeDetectionResult!.bottomRight + newBottomRight
                      );
                      widget.onDrag(edgeDetectionResult!.bottomRight, 2);
                      currentDragPosition = Offset(points![2].dx, points![2].dy);
                    });
                  },
                  onDragFinished: onDragFinished
              ),
              left: points![2].dx - (edgeDraggerSize! / 2),
              top: points![2].dy - (edgeDraggerSize! / 2)
          ),
          Positioned(
              child: TouchBubble(
                  size: edgeDraggerSize!,
                  onDrag: (position) {
                    // print(position);
                    setState(() {
                      Offset newBottomLeft = _getNewPositionAfterDrag(
                          position, renderedImageWidth!, renderedImageHeight!
                      );

                      edgeDetectionResult!.bottomLeft = _clampOffset(
                          edgeDetectionResult!.bottomLeft + newBottomLeft
                      );
                      widget.onDrag(edgeDetectionResult!.bottomLeft, 3);
                      currentDragPosition = Offset(points![3].dx, points![3].dy);
                    });
                  },
                  onDragFinished: onDragFinished
              ),
              left: points![3].dx - (edgeDraggerSize! / 2),
              top: points![3].dy - (edgeDraggerSize! / 2)
          ),
        ],
      ),
    );
  }
}