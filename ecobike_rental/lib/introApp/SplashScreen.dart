import 'dart:async';
import 'package:EcobikeRental/DropletLoader/AutomatedAnimator.dart';
import 'package:EcobikeRental/DropletLoader/WaveLoadingBubble.dart';
import 'package:EcobikeRental/introApp/Landing.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 10),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Landing())));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset("images/hello1.gif",fit: BoxFit.fill),
            AutomatedAnimator(
              animateToggle: true,
              doRepeatAnimation: true,
              duration: const Duration(seconds: 10),
              buildWidget: (double animationPosition) {
                return WaveLoadingBubble(
                  foregroundWaveColor: Colors.redAccent,
                  backgroundWaveColor: Colors.red,
                  loadingWheelColor: Colors.white,
                  period: animationPosition,
                  backgroundWaveVerticalOffset: 90 - animationPosition * 200,
                  foregroundWaveVerticalOffset: 90 +
                      reversingSplitParameters(
                        position: animationPosition,
                        numberBreaks: 6,
                        parameterBase: 8.0,
                        parameterVariation: 8.0,
                        reversalPoint: 0.75,
                      ) -
                      animationPosition * 200,
                  waveHeight: reversingSplitParameters(
                    position: animationPosition,
                    numberBreaks: 5,
                    parameterBase: 12,
                    parameterVariation: 8,
                    reversalPoint: 0.75,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
