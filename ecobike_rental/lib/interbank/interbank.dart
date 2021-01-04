import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../Helper/constant.dart';
import '../Helper/widget.dart';
import '../Model/bike_model.dart';

class Interbank {
  // Hàm call api, trả về errorCode
  static Future<String> transaction(
      {int amount,
        String typeBike,
        ProgressDialog progressDialog,
        BuildContext context,
        String nameParking,
        BikeModel bikeModel,
        StopWatchTimer stopWatchTimer,
        // ignore: type_annotate_public_apis
        value}) async {
    String value;
    try {
      //Hỗ trợ call sang java
      value = await Constant.platform.invokeMethod('transaction', {
        "command": "pay",
        "codeCard": Constant.codeCard,
        "owner": Constant.owner,
        "cvvCode": Constant.cvvCode,
        "dateExpired": Constant.dateExpired,
        "transactionContent": "Thanh toán trả $typeBike",
        "amount": amount,
        "createdAt": Helper.formatDate(),
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return value;
  }
  // call api reset tiền trong thẻ
  static Future<void> resetMoney() async {
    try {
      await Constant.platform.invokeMethod('resetMoney', {
        "command": "refund",
        "codeCard": Constant.codeCard,
        "owner": Constant.owner,
        "cvvCode": Constant.cvvCode,
        "dateExpired": Constant.dateExpired,
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}