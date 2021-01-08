import 'package:firebase_database/firebase_database.dart';

import '../Model/notification_model.dart';
import '../view/intro_app/splash_screen.dart';

//Lớp quản lý truy vấn thêm,sửa,xóa dữ liệu trên database Firebase
// ignore: avoid_classes_with_only_static_members
class DatabaseService {
  //Khởi tạo biến lưu instance của FirebaseDatabase
  static DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();
  //Truy vấn lấy ra danh sách bãi xe
  static Future<Query> getListParking() async {
    return databaseReference.child("parkings");
  }
  //Truy vấn lấy ra danh sách xe có sẵn
  static Future<Query> getListBike() async {
    return databaseReference.child("bikes");
  }
  //Truy vấn lấy ra danh sách thông báo
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
  //Truy vấn lấy ra tổng thời gian và số tiền người dùng đã dùng cho app
  static Future<Query> getTotalMoneyAndTime() async {
    return databaseReference.child("users").child("user1");
  }
  //Update lại tổng số tiền người dùng đã dùng
  static Future<void> updateTotalMoney(int totalMoney) async {
    return databaseReference
        .child("users")
        .child("user1")
        .update({"totalMoney": totalMoney});
  }
  //Update lại tổng thời gian người dùng đã dùng
  static Future<void> updateTotalTime({int hour, int minutes}) async {
    return databaseReference
        .child("users")
        .child("user1")
        .update({"totalTime": "$hour giờ $minutes phút"});
  }
  //Truy vấn lấy ra thông tin của Card
  static Future<Query> getCard(int userId) async {
    return databaseReference.child("creditCards").child("creditCard$userId");
  }
  //Truy vấn lấy ra số tiền đang có trong thẻ
  static Future<Query> getMoneyCard(int userId) async {
    return databaseReference
        .child("creditCards")
        .child("creditCard$userId")
        .child("amountMoney");
  }
  //Truy vấn lấy ra lịch sử giao dịch
  static Future<Query> getListHistoryTransaction() async {
    return databaseReference.child("transactionHistorys");
  }
  //Update lại trạng thái của xe
  static Future<void> updateStateActionBike(int bikeId,String state) async {
    return databaseReference
        .child("bikes")
        .child("bike$bikeId")
        .update({"state": state});
  }
  //Lưu lại lịch sử giao dịch
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
  //Lưu lại thông báo thuê ,trả xe
  static Future<void> uploadNotiActionBike(
      {int bikeId,
      String time,
      int parkingId,
      String typeBike,
      String nameParking,
      String codeBike,
      String action}) async {
    return databaseReference.child("notifications").push().set({
      "bikeId": bikeId,
      "userId": 1,
      "nameNotification": "$action $typeBike thành công",
      "time": time,
      "parkingId": parkingId,
      "description": "Tên bãi xe: $nameParking - Mã xe: $codeBike",
    });
  }
  //Update lại tiền trong thẻ
  static Future<void> updateMoneyCard(int totalMoney) async {
    return databaseReference
        .child("creditCards")
        .child("creditCard1")
        .update({"amountMoney": totalMoney});
  }
}
