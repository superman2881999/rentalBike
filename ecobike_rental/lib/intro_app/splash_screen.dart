import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../DropletLoader/automated_animator.dart';
import '../DropletLoader/wave_loading_bubble.dart';
import '../Model/bike_model.dart';
import '../Model/credit_card_model.dart';
import '../Model/history_transaction_model.dart';
import '../Model/notification_model.dart';
import '../Model/parking_model.dart';
import '../service/database.dart';
import 'landing.dart';

class SplashScreen extends StatefulWidget {
  static Position currentLocation;
  static List<ParkingModel> listParking = [];
  static List<BikeModel> listSingleBike = [];
  static List<BikeModel> listDoubleBike = [];
  static List<BikeModel> listElectricBike = [];
  static List<NotificationModel> listNotification = [];
  static List<HistoryTransaction> listHistoryTransaction = [];
  static List<Map<int, bool>> listIsCheck = [];
  static CreditCardModel creditCardModelInfo;
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // ignore: missing_return
  static Future<LatLng> getUserLocation() async {
    await Geolocator.getCurrentPosition().then((currloc) {
      SplashScreen.currentLocation = currloc;
    });
  }

  void getData() {
    DatabaseService.getListParking().then((value) {
      SplashScreen.listParking.clear();
      value.once().then((snapshot) {
        final Map<dynamic, dynamic> values = snapshot.value;
        // ignore: cascade_invocations
        values.forEach((key, values) {
          SplashScreen.listParking.add(ParkingModel(values["parkingId"],
              values["description"], values["nameParking"]));
        });
      });
    });

    DatabaseService.getCard(1).then((value) {
      value.once().then((snapshot) {
        final Map<dynamic, dynamic> values = snapshot.value;
        SplashScreen.creditCardModelInfo = CreditCardModel(
            userId: values["userId"],
            amountMoney: values["amountMoney"],
            appCode: values["appCode"],
            cardId: values["cardId"],
            codeCard: values["codeCard"],
            cvvCode: values["cvvCode"],
            dateExprited: values["dateExprited"],
            secretKey: values["secretKey"]);
      });
    });

    DatabaseService.getListNotification();

    DatabaseService.getListHistoryTransaction().then((value) {
      SplashScreen.listHistoryTransaction.clear();
      SplashScreen.listIsCheck.clear();
      value.once().then((snapshot) {
        final Map<dynamic, dynamic> values = snapshot.value;
        // ignore: cascade_invocations
        values.forEach((key, values) {
          SplashScreen.listHistoryTransaction.add(HistoryTransaction(
              userId: values["userId"],
              bikeId: values["bikeId"],
              transactionName: values["transactionName"],
              timeRentBike: values["timeRentBike"],
              paymentMoney: values["paymentMoney"],
              dateRentBike: values["dateRentBike"],
              licensePlate: values["licensePlate"],
              typeBike: values["typeBike"]));
        });
        for (var i = 0; i < SplashScreen.listHistoryTransaction.length; i++) {
          SplashScreen.listIsCheck.add({i: false});
        }
      });
    });

    DatabaseService.getListBike().then((value) {
      SplashScreen.listSingleBike.clear();
      SplashScreen.listElectricBike.clear();
      SplashScreen.listDoubleBike.clear();
      value.once().then((snapshot) {
        final Map<dynamic, dynamic> values = snapshot.value;
        // ignore: cascade_invocations
        values.forEach((key, values) {
          if (values["typeBike"] == "Xe Đạp") {
            SplashScreen.listSingleBike.add(BikeModel(
                bikeId: values["bikeId"],
                batteryCapacity: values["batteryCapacity"],
                typeBike: values["typeBike"],
                nameBike: values["nameBike"],
                codeBike: values["codeBike"],
                deposit: values["deposit"],
                state: values["state"],
                licensePlate: values["licensePlate"],
                parkingId: values["parkingId"]));
          } else if (values["typeBike"] == "Xe Đạp Điện") {
            SplashScreen.listElectricBike.add(BikeModel(
                bikeId: values["bikeId"],
                batteryCapacity: values["batteryCapacity"],
                typeBike: values["typeBike"],
                nameBike: values["nameBike"],
                codeBike: values["codeBike"],
                deposit: values["deposit"],
                state: values["state"],
                licensePlate: values["licensePlate"],
                parkingId: values["parkingId"]));
          } else {
            SplashScreen.listDoubleBike.add(BikeModel(
                bikeId: values["bikeId"],
                typeBike: values["typeBike"],
                nameBike: values["nameBike"],
                codeBike: values["codeBike"],
                deposit: values["deposit"],
                state: values["state"],
                parkingId: values["parkingId"]));
          }
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _SplashScreenState.getUserLocation();
    getData();
    Timer(
        const Duration(seconds: 10),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Landing())));
  }

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
