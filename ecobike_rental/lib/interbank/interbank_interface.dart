import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

abstract class PaymentInterface {
  // Hàm call api, trả về errorCode
  Future<String> transaction(
      {int amount,
      String typeBike,
      ProgressDialog progressDialog,
      BuildContext context,
      String nameParking,
      StopWatchTimer stopWatchTimer,
      // ignore: type_annotate_public_apis
      value});
  // call api reset tiền trong thẻ
  Future<void> resetMoney();
}
