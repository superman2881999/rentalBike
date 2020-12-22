import 'package:flutter/material.dart';

import 'login.dart';
import 'register.dart';

/// Lớp này để quản lý chuyển hướng login Register
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
// Trả về giao diện login hoặc register
  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return Login(toggle);
    } else {
      return Register(toggle);
    }
  }
}
