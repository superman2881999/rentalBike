import 'package:EcobikeRental/login.dart';
import 'package:EcobikeRental/register.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool showSignIn = true;
  void toggle() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return Login(toggle);
    } else {
      return Register(toggle);
    }
  }
}
