import '../../Helper/database.dart';
import '../../view/intro_app/splash_screen.dart';


class ReturnBikeController {
  //update lại tiền trong thẻ
  void getMoneyCard({int totalMoney}) {
    //Khai báo biến lưu tiền có sẵn trong thẻ
    int moneyCardIssue;
    //Lấy tiền có sẵn trong thẻ
    DatabaseService.getMoneyCard(1).then((value) {
      value.once().then((snapshot) {
        moneyCardIssue = snapshot.value;
      }).whenComplete(() {
        //update lại tiền trong thẻ
        final moneyCard = totalMoney + moneyCardIssue;
        DatabaseService.updateMoneyCard(moneyCard);
      });
    });
  }

  //  total time và total money
  void setTotalMoneyAndTime({int paymentMoney, String timeRentBike}) {
    DatabaseService.getTotalMoneyAndTime().then((value) {
      value.once().then((snapshot) {
        SplashScreen.totalMoney = snapshot.value["totalMoney"];
        //update tổng số tiền người dùng đã trả khi dùng app
        DatabaseService.updateTotalMoney(
            SplashScreen.totalMoney + paymentMoney);
        //lấy thời gian đã sự dụng từ trước trên server
        SplashScreen.totalTime = snapshot.value["totalTime"];
        //Cộng thêm thời gian vừa thuê
        final seconds =
            changeTime(SplashScreen.totalTime) + changeTime2(timeRentBike);
        //update tổng thời gian người dùng đã trả khi dùng app
        DatabaseService.updateTotalTime(
            hour: seconds ~/ 3600,
            minutes: (seconds - (seconds ~/ 3600) * 3600) ~/ 60);
      });
    });
  }

  //change thời gian có sẵn thành phút
  int changeTime(String time) {
    final list = time.split(" ");
    final minutes = int.parse(list[0]) * 3600 + int.parse(list[2]) * 60;
    return minutes;
  }

  //change thời gian đã sử dụng thành phút
  int changeTime2(String time) {
    final list = time.split(":");
    final minutes = int.parse(list[0]) * 3600 +
        int.parse(list[1]) * 60 +
        int.parse(list[2]);
    return minutes;
  }

  // Lưu lịch sử giao dịch
  void saveTransaction(
      {int bikeId,
      String transactionName,
      String dateRentBike,
      int paymentMoney,
      String timeRentBike,
      String typeBike,
      String licensePlate}) {
    DatabaseService.saveTransaction(
        bikeId: bikeId,
        dateRentBike: dateRentBike,
        paymentMoney: paymentMoney,
        timeRentBike: timeRentBike,
        licensePlate: licensePlate ?? "Không có",
        typeBike: typeBike,
        transactionName: "Thuê $typeBike đi Bách Khoa");
  }
}
