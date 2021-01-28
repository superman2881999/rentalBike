import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../helper/constant.dart';
import '../helper/widget.dart';
import 'interbank_interface.dart';

class Interbank extends PaymentInterface {
  // Hàm call api, trả về errorCode
  @override
  Future<String> transaction(
      {int amount,
      String typeBike,
      ProgressDialog progressDialog,
      BuildContext context,
      String nameParking,
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
  @override
  Future<void> resetMoney() async {
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
