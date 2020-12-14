import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../IntroApp/splash_screen.dart';
import '../Model/bike_model.dart';
import '../Service/credit_card_info.dart';
import '../Service/widget.dart';
import '../Station/home.dart';
import '../service/database.dart';

class ReturnBike extends StatefulWidget {
  const ReturnBike(this.timeRentBike, this.bikeModel, this.paymentMoney);
  final String timeRentBike;
  final BikeModel bikeModel;
  final int paymentMoney;
  @override
  _ReturnBikeState createState() => _ReturnBikeState();
}

class _ReturnBikeState extends State<ReturnBike> {
  DateTime now;
  DateFormat formatter;
  String dateRentBike;
  int totalMoney;
  int moneyCardIssue;
  @override
  void initState() {
    totalMoney = widget.bikeModel.deposit - widget.paymentMoney;
    DatabaseService.getMoneyCard(1).then((value) {
      value.once().then((snapshot) {
        moneyCardIssue = snapshot.value;
      }).whenComplete(() {
        final moneyCard = totalMoney + moneyCardIssue;
        DatabaseService.updateMoneyCard(moneyCard);
      });
    });
    // lấy total time và total money
    DatabaseService.getTotalMoneyAndTime().then((value) {
      value.once().then((snapshot) {
        SplashScreen.totalMoney = snapshot.value["totalMoney"];
        DatabaseService.updateTotalMoney(
            SplashScreen.totalMoney + widget.paymentMoney);
        SplashScreen.totalTime = snapshot.value["totalTime"];
        final seconds = changeTime(SplashScreen.totalTime) +
            changeTime2(widget.timeRentBike);
        DatabaseService.updateTotalTime(
            hour: seconds ~/ 3600,
            minutes: (seconds - (seconds ~/ 3600) * 3600) ~/ 60);
      });
    });

    super.initState();
  }

  int changeTime(String time) {
    final list = time.split(" ");
    final minutes = int.parse(list[0]) * 3600 + int.parse(list[2]) * 60;
    return minutes;
  }

  int changeTime2(String time) {
    final list = time.split(":");
    final minutes = int.parse(list[0]) * 3600 +
        int.parse(list[1]) * 60 +
        int.parse(list[2]);
    return minutes;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      now = DateTime.now();
      formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      dateRentBike = formatter.format(now);
    });
    return Scaffold(
        appBar: appBarMain(const Text("Thông tin hoá đơn"), context),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 15, top: 10, bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Thông tin dịch vụ",
                                    style: especiallyTextFieldStyle(
                                        Colors.black, 18)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Ngày thuê",
                                        style: simpleTextFieldStyle(
                                            Colors.black, 16)),
                                    Text(dateRentBike,
                                        style: simpleTextFieldStyle(
                                            Colors.black, 16))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Thời gian thuê",
                                        style: simpleTextFieldStyle(
                                            Colors.black, 16)),
                                    Text(widget.timeRentBike,
                                        style: simpleTextFieldStyle(
                                            Colors.black, 16))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Loại xe",
                                        style: simpleTextFieldStyle(
                                            Colors.black, 16)),
                                    Text(widget.bikeModel.typeBike,
                                        style: simpleTextFieldStyle(
                                            Colors.black, 16))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Biển số xe",
                                        style: simpleTextFieldStyle(
                                            Colors.black, 16)),
                                    if (widget.bikeModel.licensePlate == null)
                                      Text("Không có",
                                          style: simpleTextFieldStyle(
                                              Colors.black, 16))
                                    else
                                      Text(widget.bikeModel.licensePlate,
                                          style: simpleTextFieldStyle(
                                              Colors.black, 16))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 15, top: 5, bottom: 30),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Chi phí",
                                    style: especiallyTextFieldStyle(
                                        Colors.black, 18)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Tiền cọc",
                                        style: simpleTextFieldStyle(
                                            Colors.black, 16)),
                                    Text("+ ${widget.bikeModel.deposit} đ",
                                        style: simpleTextFieldStyle(
                                            Colors.black, 16))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Tiền thuê xe",
                                        style: simpleTextFieldStyle(
                                            Colors.black, 16)),
                                    Text("- ${widget.paymentMoney} đ",
                                        style: simpleTextFieldStyle(
                                            Colors.black, 16))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Chi phí phụ",
                                        style: simpleTextFieldStyle(
                                            Colors.black, 16)),
                                    Text("- 0 đ",
                                        style: simpleTextFieldStyle(
                                            Colors.black, 16))
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      "Đã thanh toán",
                                      style: especiallyTextFieldStyle(
                                          Colors.red, 16),
                                    )),
                                    Text("+ $totalMoney đ",
                                        style: especiallyTextFieldStyle(
                                            Colors.red, 16))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  DatabaseService.saveTransaction(
                      bikeId: widget.bikeModel.bikeId,
                      dateRentBike: dateRentBike,
                      paymentMoney: widget.paymentMoney,
                      timeRentBike: widget.timeRentBike,
                      licensePlate: widget.bikeModel.licensePlate ?? "Không có",
                      typeBike: widget.bikeModel.typeBike,
                      transactionName:
                          "Thuê ${widget.bikeModel.typeBike} đi Bách Khoa");
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Home()),
                      (route) => false);
                },
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.redAccent),
                    child: ButtonTheme(
                        child: Center(
                      child: Text("Hoàn tất dịch vụ",
                          style: simpleTextFieldStyle(Colors.white, 17)),
                    ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreditCardInfo()));
                },
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.redAccent),
                    child: ButtonTheme(
                        child: Center(
                      child: Text("Kiểm tra tài khoản",
                          style: simpleTextFieldStyle(Colors.white, 17)),
                    ))),
              ),
            ),
          ],
        ));
  }
}
