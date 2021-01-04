import 'package:geolocator/geolocator.dart';

import '../Helper/database.dart';
import '../Model/bike_model.dart';
import '../Model/credit_card_model.dart';
import '../Model/history_transaction_model.dart';
import '../Model/parking_model.dart';
import 'splash_screen.dart';

class SplashScreenController {
  //Trả về vị trí của người dùng
   Future<void> getUserLocation() async {
    await Geolocator.getCurrentPosition().then((currloc) {
      SplashScreen.currentLocation = currloc;
    });
  }
  // Lấy danh sách bãi xe
  void getListParking() {
    DatabaseService.getListParking().then((values) {
      SplashScreen.listParking.clear();
      values.once().then((snapshot) {
        snapshot.value.forEach((key, value) {
          SplashScreen.listParking.add(ParkingModel(
              value["parkingId"], value["description"], value["nameParking"]));
        });
      });
    });
  }

  // Lấy thông tin thẻ
  void getCard() {
    DatabaseService.getCard(1).then((value) {
      value.once().then((snapshot) {
        final Map<dynamic, dynamic> values = snapshot.value;
        SplashScreen.creditCardModelInfo = CreditCardModel(
            userId: values["userId"],
            amountMoney: values["amountMoney"],
            appCode: values["appCode"],
            cardId: values["cardId"],
            codeCard: values["codeCard"],
            cvvCode: values["cvvCode"],
            dateExpired: values["dateExpired"],
            secretKey: values["secretKey"]);
      });
    });
  }

  // Lấy danh sách thông báo
  void getListNotification() {
    DatabaseService.getListNotification();
  }

  // Lấy total time và total money
  void getTotalMoneyAndTime() {
    DatabaseService.getTotalMoneyAndTime().then((value) {
      value.once().then((snapshot) {
        SplashScreen.totalMoney = snapshot.value["totalMoney"];
        SplashScreen.totalTime = snapshot.value["totalTime"];
      });
    });
  }

  // Lấy danh sách giao dịch thuê xe
  void getListHistoryTransaction() {
    DatabaseService.getListHistoryTransaction().then((v) {
      SplashScreen.listHistoryTransaction.clear();
      SplashScreen.listIsCheck.clear();
      v.once().then((snapshot) {
        final Map<dynamic, dynamic> values = snapshot.value;
        // ignore: cascade_invocations
        values?.forEach((key, value) {
          SplashScreen.listHistoryTransaction.add(HistoryTransaction(
              userId: value["userId"],
              bikeId: value["bikeId"],
              transactionName: value["transactionName"],
              timeRentBike: value["timeRentBike"],
              paymentMoney: value["paymentMoney"],
              dateRentBike: value["dateRentBike"],
              licensePlate: value["licensePlate"],
              typeBike: value["typeBike"]));
        });
        for (var i = 0; i < SplashScreen.listHistoryTransaction.length; i++) {
          SplashScreen.listIsCheck.add({i: false});
        }
      });
    });
  }

  // Lấy danh sách xe trong bãi
  void getListBike() {
    DatabaseService.getListBike().then((value) {
      SplashScreen.listSingleBike.clear();
      SplashScreen.listElectricBike.clear();
      SplashScreen.listDoubleBike.clear();
      value.once().then((snapshot) {
        final Map<dynamic, dynamic> values = snapshot.value;
        // ignore: cascade_invocations
        values.forEach((key, values) {
          if (values["typeBike"] == "Xe Đạp") {
            SplashScreen.listSingleBike.add(BikeModel(
                bikeId: values["bikeId"],
                batteryCapacity: values["batteryCapacity"],
                typeBike: values["typeBike"],
                urlImage: values["colorBike"],
                nameBike: values["nameBike"],
                codeBike: values["codeBike"],
                deposit: values["deposit"],
                state: values["state"],
                licensePlate: values["licensePlate"],
                parkingId: values["parkingId"]));
          } else if (values["typeBike"] == "Xe Đạp Điện") {
            SplashScreen.listElectricBike.add(BikeModel(
                bikeId: values["bikeId"],
                batteryCapacity: values["batteryCapacity"],
                typeBike: values["typeBike"],
                urlImage: values["colorBike"],
                nameBike: values["nameBike"],
                codeBike: values["codeBike"],
                deposit: values["deposit"],
                state: values["state"],
                licensePlate: values["licensePlate"],
                parkingId: values["parkingId"]));
          } else {
            SplashScreen.listDoubleBike.add(BikeModel(
                bikeId: values["bikeId"],
                batteryCapacity: values["batteryCapacity"],
                typeBike: values["typeBike"],
                urlImage: values["colorBike"],
                nameBike: values["nameBike"],
                codeBike: values["codeBike"],
                deposit: values["deposit"],
                state: values["state"],
                licensePlate: values["licensePlate"],
                parkingId: values["parkingId"]));
          }
        });
      });
    });
  }
}
