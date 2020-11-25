import 'dart:math' as math;

import 'package:flutter/material.dart';

class WavePathHorizontal {
  WavePathHorizontal({
    @required this.width,
    @required this.amplitude,
    @required this.period,
    @required this.startPoint,
    this.phaseShift = 0.0,
    this.doClosePath = false,
    this.crossAxisEndPoint = 0,
  }) : assert(crossAxisEndPoint != null || doClosePath == false,
            "if doClosePath is true you must provide an end point "
                "(crossAxisEndPoint)");

  final double width;
  final double amplitude;
  final double period;
  final Offset startPoint;
  final double crossAxisEndPoint;
  final double phaseShift;
  final bool doClosePath;

  Path build() {
    final startPointX = startPoint.dx;
    final startPointY = startPoint.dy;
    final returnPath = Path();
    // ignore: cascade_invocations
    returnPath.moveTo(startPointX, startPointY);

    for (var i = 0; i <= width; i++) {
      returnPath.lineTo(
        i + startPointX,
        startPointY +
            amplitude *
                math.sin(
                    (i * 2 * period * math.pi / width) + phaseShift * math.pi),
      );
    }
    if (doClosePath == true) {
      returnPath.lineTo(startPointX + width, crossAxisEndPoint);
      // ignore: cascade_invocations
      returnPath.lineTo(startPointX, crossAxisEndPoint);
      // ignore: cascade_invocations
      returnPath.close();
    }
    return returnPath;
  }
}
