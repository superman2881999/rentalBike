import 'package:flutter/material.dart';

import '../Helper/widget.dart';
import '../Station/home.dart';

/// Lớp này để trả về 1 instance của _LoginState
class Login extends StatefulWidget {
  // Nhận vào 1 function làm biến
  const Login(this.toggle);
  final Function toggle;
  // trả về 1 instance của _LoginState
  @override
  _LoginState createState() => _LoginState();
}

///Lớp này xử lý logic và giao diện của login
class _LoginState extends State<Login> {
  //Hàm này để chuyển hướng sang Home sau khi người dùng đăng nhập thành công
  // ignore: avoid_void_async
  void login(String email, String password) async {
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  //Biến quản lý đầu vào của người dùng
  final formKey = GlobalKey<FormState>();
  final emailUser = TextEditingController();
  final passWordUser = TextEditingController();
  // Trả về giao diện Login
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        key: formKey,
                        child: Column(
                          children: [
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
                                  controller: emailUser,
                                  style: Helper.simpleTextFieldStyle(
                                      Colors.black, 16, FontWeight.normal),
                                  decoration: Helper.textFieldInputDecoration(
                                      "Email")),
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
                                  controller: passWordUser,
                                  style: Helper.simpleTextFieldStyle(
                                      Colors.black, 16, FontWeight.normal),
                                  decoration: Helper.textFieldInputDecoration(
                                      "Password")),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Forgot Password ?",
                        style: Helper.simpleTextFieldStyle(
                            const Color(0xFFEF5350), 14, FontWeight.normal)),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          login(emailUser.text, passWordUser.text);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal:
                                  MediaQuery.of(context).size.width / 6),
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
                          child: Text("Sign In",
                              style: Helper.simpleTextFieldStyle(
                                  Colors.white, 17, FontWeight.normal)),
                        ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account?",
                          style: Helper.simpleTextFieldStyle(
                              Colors.black54, 12, FontWeight.normal),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggle();
                          },
                          child: Text(" Register now",
                              style: Helper.simpleTextFieldStyle(
                                  const Color(0xFFEF5350),
                                  13,
                                  FontWeight.normal)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))));
  }
}
