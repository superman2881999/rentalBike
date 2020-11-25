import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Model/notification_model.dart';
import '../intro_app/splash_screen.dart';

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

  static Future<Query> getCard(int userId) async {
    return databaseReference.child("creditCards").child("creditCard$userId");
  }

  static Future<Query> getListHistoryTransaction() async {
    return databaseReference.child("transactionHistorys");
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
    final key = utf8.encode('BLSSBlwOmxo=');
    final bytes = utf8.encode({
      "bikeId": bikeId,
      "userId": 1,
      "transactionName": transactionName,
      "dateRentBike": dateRentBike,
      "paymentMoney": paymentMoney,
      "timeRentBike": timeRentBike,
      "typeBike": typeBike,
      "licensePlate": licensePlate,
    }.toString());
    final hmacMd5 = Hmac(md5, key);
    var md5Result = hmacMd5.convert(bytes);
    print(md5Result.toString());
    return databaseReference.child("transactionHistorys").push().set({
      "bikeId": bikeId,
      "userId": 1,
      "transactionName": transactionName,
      "dateRentBike": dateRentBike,
      "paymentMoney": paymentMoney,
      "timeRentBike": timeRentBike,
      "typeBike": typeBike,
      "licensePlate": licensePlate,
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

  //ko dung
  Future<void> updateStateReturnBike2(int bikeId) async {
    return databaseReference.child("bikes");
  }
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
