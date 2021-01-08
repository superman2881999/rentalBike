import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../Helper/database.dart';
import '../../Helper/widget.dart';
import '../../Model/bike_model.dart';
import '../../interbank/interbank.dart';
import '../../view/return_bike/return_bike.dart';
import '../Notification/notification_controller.dart';

class RentBikeController {
  Interbank interbank = Interbank();
  //Xử lý danh sách điểm trả
   void handleListMarkers({
    bool isReturnBike,
    List<Map<String, LatLng>> listOfMarker,
    List<Map<String, String>> listOfMarkerInfo,
    Set<Marker> markers,
  }) {
    if (isReturnBike) {
      Marker marker;
      for (var i = 0; i < listOfMarker.length; i++) {
        marker = Marker(
            position: listOfMarker[i]['latLng'],
            markerId: MarkerId(listOfMarkerInfo[i]['marker']),
            infoWindow: InfoWindow(
                title: listOfMarkerInfo[i]['title'],
                snippet: listOfMarkerInfo[i]['subtitle']),
            icon: BitmapDescriptor.defaultMarker);
        markers.add(marker);
      }
    }
  }

  //Xử lý tiền thuê xe theo yêu cầu
   int calculatorMoney(int minuteTime,String typeBike) {
    double result;
    if (minuteTime > 10) {
      if (minuteTime >= 40) {
        result = 10000 + ((minuteTime - 40) / 15 + 1) * 3000;
      } else {
        result = 10000;
      }
    } else {
      result = 0;
    }
    if(typeBike == "Xe Đạp"){
      return result.round();
    }
    else{
      return (result*1.5).round();
    }
  }

  //Xử lý logic giao dịch trả xe
   Future<void> handleTransaction(
      {int amount,
      String typeBike,
      ProgressDialog progressDialog,
      BuildContext context,
      String nameParking,
      BikeModel bikeModel,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      StopWatchTimer stopWatchTimer, String dateRentBike,
      // ignore: type_annotate_public_apis
      result}) async {
    String value;
    if (amount > 10) {
      await interbank.transaction(
              amount: amount,
              typeBike: typeBike,
              progressDialog: progressDialog,
              context: context,
              nameParking: nameParking,
              stopWatchTimer: stopWatchTimer,
              bikeModel: bikeModel,
              value: result)
          .then((val) {
        value = val;
      });
      switch (value) {
        case "01":
          await returnErrorCode(progressDialog, context, 'Thẻ không hợp lệ');
          break;
        case "02":
          await returnErrorCode(progressDialog, context, 'Thẻ không đủ số dư');
          break;
        case "03":
          await returnErrorCode(
              progressDialog, context, 'Internal Server Error');
          break;
        case "04":
          await returnErrorCode(
              progressDialog, context, 'Giao dịch bị nghi ngờ gian lận');
          break;
        case "05":
          await returnErrorCode(
              progressDialog, context, 'Không đủ thông tin giao dịch');
          break;
        case "06":
          await returnErrorCode(
              progressDialog, context, 'Thiếu thông tin version');
          break;
        case "07":
          await returnErrorCode(progressDialog, context, 'Amount không hợp lệ');
          break;
        default:
          await rentBike(
              context: context,
              nameParking: nameParking,
              paymentMoney: amount,
              bikeModel: bikeModel,
              flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
              progressDialog: progressDialog,
              stopWatchTimer: stopWatchTimer,
              dateRentBike: dateRentBike,
              value: result);
          break;
      }
    } else {
      await rentBike(
          context: context,
          nameParking: nameParking,
          paymentMoney: amount,
          bikeModel: bikeModel,
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
          progressDialog: progressDialog,
          stopWatchTimer: stopWatchTimer,
          dateRentBike: dateRentBike,
          value: result);
    }
  }

  //Hàm trả về errorCode và hiện thông báo lỗi cho người dùng
  static Future<void> returnErrorCode(
      ProgressDialog progressDialog, BuildContext context, String alert) async {
    await progressDialog.hide();
    await Helper.alertDialogNotiStateBike(context, alert);
  }

  //Hàm xử lý trả xe
   Future<void> rentBike(
      {BuildContext context,
      // ignore: type_annotate_public_apis
      value,
      StopWatchTimer stopWatchTimer,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      BikeModel bikeModel,
      String nameParking,
      ProgressDialog progressDialog,
      int paymentMoney, String dateRentBike}) async {
    // Lấy thời gian thuê xe
    final timeRentBike =
        StopWatchTimer.getDisplayTime(value, milliSecond: false);
    stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    //Hiện thông báo local trả xe báo thành công
    await NotifyController.showNotificationWithDefaultSound(
        flutterLocalNotificationsPlugin,
        "Trả ${bikeModel.typeBike} thành công",
        "Tên bãi xe: $nameParking - Mã xe: ${bikeModel.codeBike}");
    //update state sẵn sàng của xe
    await DatabaseService.updateStateActionBike(bikeModel.bikeId, "Sẵn Sàng");
    //Lưu thông báo trả xe thành công
    await DatabaseService.uploadNotiActionBike(
        bikeId: bikeModel.bikeId,
        parkingId: bikeModel.parkingId,
        codeBike: bikeModel.codeBike,
        typeBike: bikeModel.typeBike,
        nameParking: nameParking,
        time: Helper.formatDate(),
        action: "Trả");
    //Ẩn progress khi đã xử lý hết
    await progressDialog.hide();
    //Chuyển sang màn hình trả xe
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ReturnBike(dateRentBike,timeRentBike, bikeModel, paymentMoney),
        ),
        (route) => false);
  }
}
