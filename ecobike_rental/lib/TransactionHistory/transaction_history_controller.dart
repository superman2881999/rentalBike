import '../Helper/database.dart';
import '../IntroApp/splash_screen.dart';
import '../Model/history_transaction_model.dart';

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
        final Map<dynamic, dynamic> values = snapshot.value;
        // ignore: cascade_invocations
        values?.forEach((key, values) {
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
