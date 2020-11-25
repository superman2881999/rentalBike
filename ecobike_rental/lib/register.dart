import 'package:flutter/material.dart';

import 'widget.dart';

class Register extends StatefulWidget {
  const Register(this.toggle);
  final Function toggle;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/background2.png"),
                    fit: BoxFit.cover)),
            child: Center(
                child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 3),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Form(
                        // key: formKey,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              child: TextFormField(
                                  validator: (value) {
                                    return value.isEmpty || value.length < 2
                                        ? "Please provide username"
                                        : null;
                                  },
                                  //controller: userName,
                                  style:
                                      simpleTextFieldStyle(Colors.black26, 16),
                                  decoration:
                                      textFieldInputDecoration("UserName")),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              child: TextFormField(
                                  validator: (value) {
                                    return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value)
                                        ? null
                                        : "Please provide a valid email";
                                  },
                                  // controller: emailUser,
                                  style:
                                      simpleTextFieldStyle(Colors.black26, 16),
                                  decoration:
                                      textFieldInputDecoration("Email")),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 30),
                              child: TextFormField(
                                  obscureText: true,
                                  validator: (value) {
                                    return value.length > 6
                                        ? null
                                        : "Please provide password "
                                            "6+ characters";
                                  },
                                  // controller: passWordUser,
                                  style:
                                      simpleTextFieldStyle(Colors.black26, 16),
                                  decoration:
                                      textFieldInputDecoration("Password")),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: MediaQuery.of(context).size.width / 6),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                                  Color(0xFFEF9A9A),
                                  Color(0xFFEF5350),
                                ])),
                        child: Text("Register",
                            style: simpleTextFieldStyle(Colors.white, 17)),
                      ),
                      Expanded(
                        child: Container(
                            width: 60,
                            height: 60,
                            child: Image.asset('images/facebook.png')),
                      ),
                      Expanded(
                        child: Container(
                            width: 60,
                            height: 60,
                            child: Image.asset('images/google.png')),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Do you have account?",
                          style: simpleTextFieldStyle(Colors.black54, 12),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(" Login now",
                                    style: simpleTextFieldStyle(
                                        const Color(0xFFEF5350), 13))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))));
  }
}
