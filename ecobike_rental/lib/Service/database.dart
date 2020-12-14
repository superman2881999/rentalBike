import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';

import '../IntroApp/splash_screen.dart';
import '../Model/notification_model.dart';

class DatabaseService {
  static DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  static Future<Query> getListParking() async {
    return databaseReference.child("parkings");
  }

  static Future<Query> getListBike() async {
    return databaseReference.child("bikes");
  }

  static Future<dynamic> getListNotification() async {
    SplashScreen.listNotification.clear();
    return databaseReference
        .child("notifications")
        .orderByChild("time")
        .onChildAdded
        .forEach((element) {
      final Map<dynamic, dynamic> values = element.snapshot.value;
      SplashScreen.listNotification.add(NotificationModel(
          userId: 1,
          time: values["time"],
          nameNotification: values["nameNotification"],
          parkingId: values["parkingId"],
          bikeId: values["bikeId"],
          description: values["description"]));
    });
  }

  static Future<Query> getTotalMoneyAndTime() async {
    return databaseReference
        .child("users")
        .child("user1");
  }

  static Future<void> updateTotalMoney(int totalMoney) async {
    return databaseReference
        .child("users")
        .child("user1")
        .update({"totalMoney": totalMoney});
  }

  static Future<void> updateTotalTime({int hour, int minutes}) async {
    return databaseReference
        .child("users")
        .child("user1")
        .update({"totalTime": "$hour giờ $minutes phút"});
  }

  static Future<Query> getCard(int userId) async {
    return databaseReference.child("creditCards").child("creditCard$userId");
  }

  static Future<Query> getMoneyCard(int userId) async {
    return databaseReference
        .child("creditCards")
        .child("creditCard$userId")
        .child("amountMoney");
  }

  static Future<Query> getListHistoryTransaction() async {
    return databaseReference
        .child("transactionHistorys");
  }

  static Future<void> updateStateRentBike(int bikeId) async {
    return databaseReference
        .child("bikes")
        .child("bike$bikeId")
        .update({"state": "Chưa Sẵn Sàng"});
  }

  static Future<void> updateStateReturnBike(int bikeId) async {
    return databaseReference
        .child("bikes")
        .child("bike$bikeId")
        .update({"state": "Sẵn Sàng"});
  }

  static Future<void> saveTransaction(
      {int bikeId,
      String transactionName,
      String dateRentBike,
      int paymentMoney,
      String timeRentBike,
      String typeBike,
      String licensePlate}) async {
    return databaseReference.child("transactionHistorys").push().set({
      "bikeId": bikeId,
      "userId": 1,
      "transactionName": transactionName,
      "dateRentBike": dateRentBike,
      "paymentMoney": paymentMoney,
      "timeRentBike": timeRentBike,
      "typeBike": typeBike,
      "licensePlate": licensePlate
    });
  }

  static Future<void> uploadNotiRentBike(
      {int bikeId,
      String time,
      int parkingId,
      String typeBike,
      String nameParking,
      String codeBike}) async {
    return databaseReference.child("notifications").push().set({
      "bikeId": bikeId,
      "userId": 1,
      "nameNotification": "Thuê $typeBike thành công",
      "time": time,
      "parkingId": parkingId,
      "description": "Tên bãi xe: $nameParking - Mã xe: $codeBike",
    });
  }

  static Future<void> uploadNotiReturnBike(
      {int bikeId,
      String time,
      int parkingId,
      String typeBike,
      String nameParking,
      String codeBike}) async {
    return databaseReference.child("notifications").push().set({
      "bikeId": bikeId,
      "userId": 1,
      "nameNotification": "Trả $typeBike thành công",
      "time": time,
      "parkingId": parkingId,
      "description": "Tên bãi xe: $nameParking - Mã xe: $codeBike",
    });
  }

  static Future<void> updateMoneyCard(int totalMoney) async {
    return databaseReference
        .child("creditCards")
        .child("creditCard1")
        .update({"amountMoney": totalMoney});
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
