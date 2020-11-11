import 'package:EcobikeRental/widget.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggle;
  Register(this.toggle);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                        return value.isEmpty || value.length < 2
                                            ? "Please provide username"
                                            : null;
                                      },
                                      //controller: userName,
                                      style: simpleTextFieldStyle(Colors.black26, 16.0),
                                      decoration:
                                      textFieldInputDecoration("UserName")),
                                ),
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
                                      style: simpleTextFieldStyle(Colors.black26, 16.0),
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
                                      style: simpleTextFieldStyle(Colors.black26, 16.0),
                                      decoration: textFieldInputDecoration("Password")
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: MediaQuery.of(context).size.width/6),
                            alignment: Alignment.center,
                            child: Text("Register", style: simpleTextFieldStyle(Colors.white, 17.0)),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Do you have account?",
                              style: simpleTextFieldStyle(Colors.black54, 12.0),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  widget.toggle();
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(" Login now",
                                        style: simpleTextFieldStyle(Color(0xFFEF5350), 13.0))),
                              ),
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
