import 'package:flutter/cupertino.dart';

//custom lại clippath
class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final controlPoint = Offset(size.width / 4, size.height / 2);
    final endPoint = Offset(0, size.height);
    final path = Path();
    // ignore: cascade_invocations
    path.moveTo(0, 0);
    // ignore: cascade_invocations
    path.lineTo(0, 0);
    // ignore: cascade_invocations
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    // ignore: cascade_invocations
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}