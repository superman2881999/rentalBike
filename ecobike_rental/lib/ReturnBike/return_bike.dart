import 'package:flutter/material.dart';

import '../IntroApp/splash_screen.dart';
import '../Model/bike_model.dart';
import '../Service/credit_card_info.dart';
import '../Service/database.dart';
import '../Service/widget.dart';
import '../Station/home.dart';

///Lớp này trả về 1 instance _ReturnBikeState
class ReturnBike extends StatefulWidget {
  //Constructor này nhận vào thời gian thuê xe, thông tin xe thuê, tiền phải trả
  const ReturnBike(this.timeRentBike, this.bikeModel, this.paymentMoney);
  final String timeRentBike;
  final BikeModel bikeModel;
  final int paymentMoney;
  @override
  _ReturnBikeState createState() => _ReturnBikeState();
}
///Lớp này quản lý trả xe và hiển thị thông tin cho người dùng check
class _ReturnBikeState extends State<ReturnBike> {
  //Khai báo biến lưu ngày thuê
  String dateRentBike;
  //Khai báo biến lưu tổng tiền đã thanh toán(đã công tiền cọc và trừ tiền thuê)
  int totalMoney;
  //Khai báo biến lưu tiền có sẵn trong thẻ
  int moneyCardIssue;
  @override
  void initState() {
    //Tiền đã thanh toán
    totalMoney = widget.bikeModel.deposit - widget.paymentMoney;
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
    // lấy total time và total money
    DatabaseService.getTotalMoneyAndTime().then((value) {
      value.once().then((snapshot) {

        SplashScreen.totalMoney = snapshot.value["totalMoney"];
        //update tổng số tiền người dùng đã trả khi dùng app
        DatabaseService.updateTotalMoney(
            SplashScreen.totalMoney + widget.paymentMoney);
        //lấy thời gian đã sự dụng từ trước trên server
        SplashScreen.totalTime = snapshot.value["totalTime"];
        //Cộng thêm thời gian vừa thuê
        final seconds = changeTime(SplashScreen.totalTime) +
            changeTime2(widget.timeRentBike);
        //update tổng thời gian người dùng đã trả khi dùng app
        DatabaseService.updateTotalTime(
            hour: seconds ~/ 3600,
            minutes: (seconds - (seconds ~/ 3600) * 3600) ~/ 60);
      });
    });
    super.initState();
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
  //Trả về widget hiển thị thông tin hóa đơn
  @override
  Widget build(BuildContext context) {
    setState(() {
      dateRentBike = Service.formatDate();
    });
    return Scaffold(
        appBar: Service.appBarMain(const Text("Thông tin hoá đơn"), context),
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
                                    style: Service.simpleTextFieldStyle(
                                        Colors.black, 18, FontWeight.bold)),
                                Row(
                                  //Hiển thị ngày thuê
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Ngày thuê",
                                        style: Service.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal)),
                                    Text(dateRentBike,
                                        style: Service.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal))
                                  ],
                                ),
                                Row(
                                  //Hiển thị thời gian thuê
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Thời gian thuê",
                                        style: Service.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal)),
                                    Text(widget.timeRentBike,
                                        style: Service.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal))
                                  ],
                                ),
                                Row(
                                  //Hiển thị loại xe đã thuê
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Loại xe",
                                        style: Service.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal)),
                                    Text(widget.bikeModel.typeBike,
                                        style: Service.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal))
                                  ],
                                ),
                                Row(
                                  //Hiển thị biển số xe
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Biển số xe",
                                        style: Service.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal)),
                                    if (widget.bikeModel.licensePlate == null)
                                      Text("Không có",
                                          style: Service.simpleTextFieldStyle(
                                              Colors.black,
                                              16,
                                              FontWeight.normal))
                                    else
                                      Text(widget.bikeModel.licensePlate,
                                          style: Service.simpleTextFieldStyle(
                                              Colors.black,
                                              16,
                                              FontWeight.normal))
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
                                    style: Service.simpleTextFieldStyle(
                                        Colors.black, 18, FontWeight.bold)),
                                Row(
                                  //Hiển thị tiền cọc
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Tiền cọc",
                                        style: Service.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal)),
                                    Text("+ ${widget.bikeModel.deposit} đ",
                                        style: Service.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal))
                                  ],
                                ),
                                Row(
                                  //Hiển thị tiền thuê xe
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Tiền thuê xe",
                                        style: Service.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal)),
                                    Text("- ${widget.paymentMoney} đ",
                                        style: Service.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal))
                                  ],
                                ),
                                Row(
                                  //Hiển thị các chi phí phụ khác
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Chi phí phụ",
                                        style: Service.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal)),
                                    Text("- 0 đ",
                                        style: Service.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal))
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                Row(
                                  //Hiển thị tiền đã thanh toán
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      "Đã thanh toán",
                                      style: Service.simpleTextFieldStyle(
                                          Colors.red, 16, FontWeight.bold),
                                    )),
                                    Text("+ $totalMoney đ",
                                        style: Service.simpleTextFieldStyle(
                                            Colors.red, 16, FontWeight.bold))
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
                  //Lưu lại lịch sử giao dịch thuê xe
                  DatabaseService.saveTransaction(
                      bikeId: widget.bikeModel.bikeId,
                      dateRentBike: dateRentBike,
                      paymentMoney: widget.paymentMoney,
                      timeRentBike: widget.timeRentBike,
                      licensePlate: widget.bikeModel.licensePlate ?? "Không có",
                      typeBike: widget.bikeModel.typeBike,
                      transactionName:
                          "Thuê ${widget.bikeModel.typeBike} đi Bách Khoa");
                  //Chuyển về màn hình Home
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
                          style: Service.simpleTextFieldStyle(
                              Colors.white, 17, FontWeight.normal)),
                    ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: GestureDetector(
                onTap: () {
                  //Chuyển về màn hình thẻ của người dùng để check tiền
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
                          style: Service.simpleTextFieldStyle(
                              Colors.white, 17, FontWeight.normal)),
                    ))),
              ),
            ),
          ],
        ));
  }
}
