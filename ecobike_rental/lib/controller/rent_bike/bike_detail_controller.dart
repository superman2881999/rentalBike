import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../Helper/database.dart';
import '../../Helper/widget.dart';
import '../../model/bike_model.dart';
import '../../view/rent_bike/after_rent_bike.dart';
import '../Notification/notification_controller.dart';

class BikeDetailController {
  int money;
  void getMoneyCard() {
    DatabaseService.getMoneyCard(1).then((value) async {
      await value.once().then((snapshot) {
        money = snapshot.value;
      });
    });
  }

  Future<void> handleRentBike(
      {BuildContext context,
      BikeModel bikeModel,
      String nameParking,
      TextEditingController codeBike,
      StopWatchTimer stopWatchTimer,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      ProgressDialog pr,
      String time,
      Position location}) async {
    String dateRentBike;
    if (codeBike.text == bikeModel.codeBike) {
      await pr.show();
      if (bikeModel.deposit <= money) {
        //update trạng thái xe thành chưa sẵn sàng
        await DatabaseService.updateStateActionBike(
            bikeModel.bikeId, "Chưa Sẵn Sàng");
        stopWatchTimer.onExecute.add(StopWatchExecute.start);
        // trừ tiền cọc vào tài khoản
        await DatabaseService.updateMoneyCard(money - bikeModel.deposit);
        // upload thông báo thuê xe thành công
        await DatabaseService.uploadNotiActionBike(
                bikeId: bikeModel.bikeId,
                parkingId: bikeModel.parkingId,
                codeBike: bikeModel.codeBike,
                typeBike: bikeModel.typeBike,
                nameParking: nameParking,
                time: time,
                action: "Thuê")
            .whenComplete(() async {
          await pr.hide();
          //Gửi thông báo thuê xe thành công cho người dùng
          await NotifyController.showNotificationWithDefaultSound(
              flutterLocalNotificationsPlugin,
              "Thuê ${bikeModel.typeBike} thành công",
              "Tên bãi xe: $nameParking "
                  "- Mã xe: ${bikeModel.codeBike}");
          dateRentBike = Helper.formatDate();
          // Chuyển sang giao diện Bản đồ Thuê Xe
          await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => RentBike(dateRentBike, stopWatchTimer,
                      location, bikeModel, flutterLocalNotificationsPlugin)),
              (route) => false);
        });
      } else {
        //Hiện toast báo người dùng k đủ tiền cọc xe
        await pr.hide();
        await Helper.alertDialogNotiStateBike(
            context, "Thẻ không đủ tiền để trả cọc xe");
      }
    } else {
      //Hiện toast báo người dùng nhập sai mã xe
      await Helper.alertDialogNotiStateBike(context, "Nhập lại mã số xe");
    }
  }
}
