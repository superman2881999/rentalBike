import 'package:flutter/material.dart';

class AutomatedAnimator extends StatefulWidget {
  const AutomatedAnimator({
    @required this.buildWidget,
    @required this.animateToggle,
    this.duration = const Duration(milliseconds: 300),
    this.doRepeatAnimation = false,
    Key key,
  }) : super(key: key);

  final Widget Function(double animationValue) buildWidget;
  final Duration duration;
  final bool animateToggle;
  final bool doRepeatAnimation;

  @override
  _AutomatedAnimatorState createState() => _AutomatedAnimatorState();
}

class _AutomatedAnimatorState extends State<AutomatedAnimator>
    with SingleTickerProviderStateMixin {
  _AutomatedAnimatorState();
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}));
    if (widget.animateToggle == true) {
      controller.forward();
    }
    if (widget.doRepeatAnimation == true) {
      controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AutomatedAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animateToggle == true) {
      controller.forward();
      return;
    }
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return widget.buildWidget(controller.value);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

//*======================================================================
//* Additional functions to allow custom periodicity of animations
//*======================================================================

//*======================================================================
//* varies (parameterVariation) a paramter (parameterBase) based on an
//* animation position (position), broken into a number of parts
//* (numberBreaks).
//* the animation reverses at the halfway point (0.5)
//*
//* returns a value of 0.0 - 1.0
//*======================================================================

double reversingSplitParameters({
  @required double position,
  @required double numberBreaks,
  @required double parameterBase,
  @required double parameterVariation,
  @required double reversalPoint,
}) {
  assert(reversalPoint <= 1.0 && reversalPoint >= 0.0,
      "reversalPoint must be a number between 0.0 and 1.0");
  final finalAnimationPosition = breakAnimationPosition(position, numberBreaks);

  if (finalAnimationPosition <= 0.5) {
    return parameterBase - (finalAnimationPosition * 2 * parameterVariation);
  } else {
    return parameterBase -
        ((1 - finalAnimationPosition) * 2 * parameterVariation);
  }
}

//*======================================================================
//* Breaks down a long animation controller value into a number of
//* smaller animations,
//* used for creating a single looping animation with multiple
//* sub animations with different periodicites that are able to
//* maintain a consistent unbroken loop
//*
//* Returns a value of 0.0 - 1.0 based on a given animationPosition
//* split into a discrete number of breaks (numberBreaks)
//*======================================================================

double breakAnimationPosition(double position, double numberBreaks) {
  var finalAnimationPosition = 0.0;
  final breakPoint = 1.0 / numberBreaks;

  for (var i = 0; i < numberBreaks; i++) {
    if (position <= breakPoint * (i + 1)) {
      finalAnimationPosition = (position - i * breakPoint) * numberBreaks;
      break;
    }
  }

  return finalAnimationPosition;
}
