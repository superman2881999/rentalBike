import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../controller/intro_app/splash_screen_controller.dart';
import '../../model/bike_model.dart';
import '../../model/credit_card_model.dart';
import '../../model/history_transaction_model.dart';
import '../../model/notification_model.dart';
import '../../model/parking_model.dart';
import 'droplet_loader/automated_animator.dart';
import 'droplet_loader/wave_loading_bubble.dart';
import 'landing.dart';

/// Lớp này sẽ hiện màn hình splash screen để đợi load data của app
/// @return: Trả về instance của class _SplashScreenState extend từ State<>

class SplashScreen extends StatefulWidget {
  //Biến lưu vị trí hiện tại của người dùng
  static Position currentLocation;
  //Khai báo các biến để lưu trữ list dữ liệu trả về từ server
  static List<ParkingModel> listParking = [];
  static List<BikeModel> listSingleBike = [];
  static List<BikeModel> listDoubleBike = [];
  static List<BikeModel> listElectricBike = [];
  static List<NotificationModel> listNotification = [];
  static List<HistoryTransaction> listHistoryTransaction = [];
  static List<Map<int, bool>> listIsCheck = [];
  //Biến lưu giá trị của thẻ tín dụng
  static CreditCardModel creditCardModelInfo;
  static int totalMoney;
  static String totalTime;
  //Trả về instance của class _SplashScreenState extend từ State<>
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

///Trả về kết quả lấy được từ server vào các biến đã khai báo ở class trên
class _SplashScreenState extends State<SplashScreen> {

 // SplashScreenController splashScreenController = SplashScreenController();

  //Hàm khởi tạo chạy khi class đc tạo
  @override
  void initState() {
    super.initState();
    SplashScreenController.getUserLocation();
    // ignore: cascade_invocations
    SplashScreenController.getListParking();

    // ignore: cascade_invocations
    SplashScreenController.getCard();
    // ignore: cascade_invocations
    SplashScreenController.getListNotification();
    // ignore: cascade_invocations
    SplashScreenController.getTotalMoneyAndTime();
    // ignore: cascade_invocations
    SplashScreenController.getListHistoryTransaction();
    // ignore: cascade_invocations
    SplashScreenController.getListBike();
    //Sau 10 giây thì sẽ chuyển hướng vào màn hình giới thiệu app
    Timer(
        const Duration(seconds: 10),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Landing())));
  }

  //Hàm build trả về giao diện của màn hình
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset("images/hello1.gif", fit: BoxFit.fill),
            AutomatedAnimator(
              animateToggle: true,
              doRepeatAnimation: true,
              duration: const Duration(seconds: 10),
              buildWidget: (animationPosition) {
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
                        parameterBase: 8,
                        parameterVariation: 8,
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
