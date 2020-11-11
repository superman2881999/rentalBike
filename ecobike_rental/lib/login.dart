import 'package:EcobikeRental/home.dart';
import 'package:EcobikeRental/widget.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final Function toggle;
  Login(this.toggle);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void login(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/background2.png"),
                    fit: BoxFit.cover)),
            child: Center(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
                        child: Card(
                          elevation: 5.0,
                          shape: new RoundedRectangleBorder(
                              side: new BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Form(
                            // key: formKey,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 10.0),
                                  child: TextFormField(
                                      validator: (value) {
                                        return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value)
                                            ? null
                                            : "Please provide a valid email";
                                      },
                                      // controller: emailUser,
                                      style: simpleTextFieldStyle(Colors.black, 16.0),
                                      decoration: textFieldInputDecoration("Email")
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 30.0),
                                  child: TextFormField(
                                      obscureText: true,
                                      validator: (value) {
                                        return value.length > 6
                                            ? null
                                            : "Please provide password 6+ characters";
                                      },
                                      // controller: passWordUser,
                                      style: simpleTextFieldStyle(Colors.black, 16.0),
                                      decoration: textFieldInputDecoration("Password")
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text("Forgot Password ?",
                            style: simpleTextFieldStyle(Color(0xFFEF5350), 14.0)),
                        padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                                login();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: MediaQuery.of(context).size.width/6),
                              alignment: Alignment.center,
                              child: Text("Sign In", style: simpleTextFieldStyle(Colors.white, 17.0)),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  gradient: LinearGradient(
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter,
                                      colors: [
                                        const Color(0xFFEF9A9A),
                                        const Color(0xFFEF5350),
                                      ])),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 60.0,
                              height: 60.0,
                              child: Image.asset('images/facebook.png')
                            ),
                          ),
                          Expanded(
                            child: Container(
                                width: 60.0,
                                height: 60.0,
                                child: Image.asset('images/google.png')
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have account?",
                              style: simpleTextFieldStyle(Colors.black54, 12.0),
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: Text(" Register now",
                                  style: simpleTextFieldStyle(Color(0xFFEF5350), 13.0)),
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),
                )
            )
        )
    );
  }
}
