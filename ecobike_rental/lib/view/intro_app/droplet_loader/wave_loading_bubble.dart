import 'package:flutter/material.dart';

import 'wave_loading_bubble_painter.dart';

class WaveLoadingBubble extends StatelessWidget {
  const WaveLoadingBubble({
    this.bubbleDiameter = 200.0,
    this.loadingCircleWidth = 10.0,
    this.waveInsetWidth = 5.0,
    this.waveHeight = 10.0,
    this.foregroundWaveColor = Colors.lightBlue,
    this.backgroundWaveColor = Colors.blue,
    this.loadingWheelColor = Colors.white,
    this.foregroundWaveVerticalOffset = 10.0,
    this.backgroundWaveVerticalOffset = 0.0,
    this.period = 0.0,
    Key key,
  }) : super(key: key);

  final double bubbleDiameter;
  final double loadingCircleWidth;
  final double waveInsetWidth;
  final double waveHeight;
  final Color foregroundWaveColor;
  final Color backgroundWaveColor;
  final Color loadingWheelColor;
  final double foregroundWaveVerticalOffset;
  final double backgroundWaveVerticalOffset;
  final double period;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaveLoadingBubblePainter(
        bubbleDiameter: bubbleDiameter,
        loadingCircleWidth: loadingCircleWidth,
        waveInsetWidth: waveInsetWidth,
        waveHeight: waveHeight,
        foregroundWaveColor: foregroundWaveColor,
        backgroundWaveColor: backgroundWaveColor,
        loadingWheelColor: loadingWheelColor,
        foregroundWaveVerticalOffset: foregroundWaveVerticalOffset,
        backgroundWaveVerticalOffset: backgroundWaveVerticalOffset,
        period: period,
      ),
    );
  }
}