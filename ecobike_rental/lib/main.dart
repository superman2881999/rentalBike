import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'view/intro_app/splash_screen.dart';

/// Khi chạy project thì đầu tiên sẽ chạy vào hàm main()
// ignore: avoid_void_async
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // bắt buộc thêm đoạn code sau trước khi chạy bất kỳ dịch vụ nào của Google.
  await Firebase.initializeApp();
  // Chạy project
  runApp(MyApp());
}
/// Lớp chứa widget gốc của app của bạn
/// @return: trả về 1 widget gốc và chạy vào màn hình splash screen
class MyApp extends StatelessWidget {
  // Đây là widget gốc của app của bạn.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'EcobikeRental',
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFFEF5350),
          scaffoldBackgroundColor: const Color(0xFFEBE3E3),
        ),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent, // transparent status bar
              systemNavigationBarColor: Colors.black, // navigation bar color
              statusBarIconBrightness:
                  Brightness.dark, // status bar icons' color
              systemNavigationBarIconBrightness:
                  Brightness.dark, //navigation bar icons' color
            ),
            child: SplashScreen()));
  }
}


