import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../Model/bike_model.dart';

abstract class InterbankInterFace {
  // Hàm call api, trả về errorCode
  Future<String> transaction(
      {int amount,
      String typeBike,
      ProgressDialog progressDialog,
      BuildContext context,
      String nameParking,
      BikeModel bikeModel,
      StopWatchTimer stopWatchTimer,
      // ignore: type_annotate_public_apis
      value});
  // call api reset tiền trong thẻ
  Future<void> resetMoney();
}
