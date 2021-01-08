import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'wave_path_horizontal.dart';

class WaveLoadingBubblePainter extends CustomPainter {
  WaveLoadingBubblePainter({
    this.bubbleDiameter,
    this.loadingCircleWidth,
    this.waveInsetWidth,
    this.waveHeight,
    this.foregroundWaveColor,
    this.backgroundWaveColor,
    this.loadingWheelColor,
    this.foregroundWaveVerticalOffset,
    this.backgroundWaveVerticalOffset,
    this.period,
  })  : foregroundWavePaint = Paint()..color = foregroundWaveColor,
        backgroundWavePaint = Paint()..color = backgroundWaveColor,
        loadingCirclePaint = Paint()
          ..shader = SweepGradient(
            colors: [
              Colors.transparent,
              loadingWheelColor,
              Colors.transparent,
            ],
            // ignore: prefer_const_literals_to_create_immutables
            stops: [0.0, 0.9, 1.0],
            startAngle: 0,
            endAngle: math.pi * 1,
            transform: GradientRotation(period * math.pi * 2 * 5),
          ).createShader(Rect.fromCircle(
            center: const Offset(0, 0),
            radius: bubbleDiameter / 2,
          ));

  final double bubbleDiameter;
  final double loadingCircleWidth;
  final double waveInsetWidth;
  final double waveHeight;
  final Paint foregroundWavePaint;
  final Paint backgroundWavePaint;
  final Paint loadingCirclePaint;
  final Color foregroundWaveColor;
  final Color backgroundWaveColor;
  final Color loadingWheelColor;
  final double foregroundWaveVerticalOffset;
  final double backgroundWaveVerticalOffset;
  final double period;

  @override
  void paint(Canvas canvas, Size size) {
    // ignore: unnecessary_parenthesis
    final loadingBubbleRadius = (bubbleDiameter / 2);
    final insetBubbleRadius = loadingBubbleRadius - waveInsetWidth;
    final waveBubbleRadius = insetBubbleRadius - loadingCircleWidth;

    final backgroundWavePath = WavePathHorizontal(
      amplitude: waveHeight,
      period: 1,
      startPoint: Offset(0.0 - waveBubbleRadius,
          0.0 + backgroundWaveVerticalOffset),
      width: bubbleDiameter,
      crossAxisEndPoint: waveBubbleRadius,
      doClosePath: true,
      phaseShift: period * 2 * 5,
    ).build();

    final foregroundWavePath = WavePathHorizontal(
      amplitude: waveHeight,
      period: 1,
      startPoint: Offset(0.0 - waveBubbleRadius,
          0.0 + foregroundWaveVerticalOffset),
      width: bubbleDiameter,
      crossAxisEndPoint: waveBubbleRadius,
      doClosePath: true,
      phaseShift: -period * 2 * 5,
    ).build();

    final circleClip = Path()..addRRect(RRect.fromLTRBXY(
        -waveBubbleRadius, -waveBubbleRadius, waveBubbleRadius,
        waveBubbleRadius, waveBubbleRadius, waveBubbleRadius));

    canvas.clipPath(circleClip, doAntiAlias: true);
    // ignore: cascade_invocations
    canvas.drawPath(backgroundWavePath, backgroundWavePaint);
    // ignore: cascade_invocations
    canvas.drawPath(foregroundWavePath, foregroundWavePaint);
  }

  @override
  bool shouldRepaint(WaveLoadingBubblePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(WaveLoadingBubblePainter oldDelegate) => false;
}