import '../../helper/database.dart';
import '../../model/history_transaction_model.dart';
import '../../view/intro_app/splash_screen.dart';

class TransactionHistoryController {
  // Lấy total time và total money
  void getTotalMoneyAndTime() {
    DatabaseService.getTotalMoneyAndTime().then((value) {
      value.once().then((snapshot) {
        SplashScreen.totalMoney = snapshot.value['totalMoney'];
        SplashScreen.totalTime = snapshot.value["totalTime"];
      });
    });
  }

  //Lấy danh sách lịch sử giao dịch
  void getListHistoryTransaction() {
    DatabaseService.getListHistoryTransaction().then((value) {
      SplashScreen.listHistoryTransaction.clear();
      SplashScreen.listIsCheck.clear();
      value.once().then((snapshot) {
        snapshot.value?.forEach((key, values) {
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
  }
}
