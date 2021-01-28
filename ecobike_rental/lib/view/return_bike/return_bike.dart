import 'package:flutter/material.dart';

import '../../controller/return_bike/return_bike_controller.dart';
import '../../helper/widget.dart';
import '../../model/bike_model.dart';
import '../credit_card/credit_card_info.dart';
import '../station/home.dart';

///Lớp này trả về 1 instance _ReturnBikeState
class ReturnBike extends StatefulWidget {
  //Constructor này nhận vào thời gian thuê xe, thông tin xe thuê, tiền phải trả
  const ReturnBike(
      this.dateRentBike, this.timeRentBike, this.bikeModel, this.paymentMoney);
  final String timeRentBike;
  final BikeModel bikeModel;
  final int paymentMoney;
  final String dateRentBike;
  @override
  _ReturnBikeState createState() => _ReturnBikeState();
}

///Lớp này quản lý trả xe và hiển thị thông tin cho người dùng check
class _ReturnBikeState extends State<ReturnBike> {

  //Khai báo biến lưu tổng tiền đã thanh toán(đã công tiền cọc và trừ tiền thuê)
  int totalMoney;

  ReturnBikeController returnBikeController = ReturnBikeController();
  @override
  void initState() {
    // lấy total time và total money
    returnBikeController.setTotalMoneyAndTime(
        timeRentBike: widget.timeRentBike, paymentMoney: widget.paymentMoney);
    //Tiền đã thanh toán
    totalMoney = widget.bikeModel.deposit - widget.paymentMoney;
    //Lấy tiền có sẵn trong thẻ
    returnBikeController.getMoneyCard(totalMoney: totalMoney);
    super.initState();
  }

  //Trả về widget hiển thị thông tin hóa đơn
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Helper.appBarMain(const Text("Thông tin hoá đơn"), context),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
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
                                    style: Helper.simpleTextFieldStyle(
                                        Colors.black, 18, FontWeight.bold)),
                                Row(
                                  //Hiển thị ngày thuê
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Ngày thuê",
                                        style: Helper.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal)),
                                    Text(widget.dateRentBike,
                                        style: Helper.simpleTextFieldStyle(
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
                                        style: Helper.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal)),
                                    Text(widget.timeRentBike,
                                        style: Helper.simpleTextFieldStyle(
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
                                        style: Helper.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal)),
                                    Text(widget.bikeModel.typeBike,
                                        style: Helper.simpleTextFieldStyle(
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
                                        style: Helper.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal)),
                                    if (widget.bikeModel.licensePlate == null)
                                      Text("Không có",
                                          style: Helper.simpleTextFieldStyle(
                                              Colors.black,
                                              16,
                                              FontWeight.normal))
                                    else
                                      Text(widget.bikeModel.licensePlate,
                                          style: Helper.simpleTextFieldStyle(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Chi phí",
                                    style: Helper.simpleTextFieldStyle(
                                        Colors.black, 18, FontWeight.bold)),
                                Row(
                                  //Hiển thị tiền cọc
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Tiền cọc",
                                        style: Helper.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal)),
                                    Text("+ ${widget.bikeModel.deposit} đ",
                                        style: Helper.simpleTextFieldStyle(
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
                                        style: Helper.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal)),
                                    Text("- ${widget.paymentMoney} đ",
                                        style: Helper.simpleTextFieldStyle(
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
                                        style: Helper.simpleTextFieldStyle(
                                            Colors.black,
                                            16,
                                            FontWeight.normal)),
                                    Text("- 0 đ",
                                        style: Helper.simpleTextFieldStyle(
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
                                      "Tiền trả lại",
                                      style: Helper.simpleTextFieldStyle(
                                          Colors.red, 16, FontWeight.bold),
                                    )),
                                    Text("+ $totalMoney đ",
                                        style: Helper.simpleTextFieldStyle(
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
                  returnBikeController.saveTransaction(
                    bikeId: widget.bikeModel.bikeId,
                    dateRentBike: widget.dateRentBike,
                    paymentMoney: widget.paymentMoney,
                    timeRentBike: widget.timeRentBike,
                    licensePlate: widget.bikeModel.licensePlate,
                    typeBike: widget.bikeModel.typeBike,
                  );
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
                    child: Center(
                      child: Text("Hoàn tất dịch vụ",
                      style: Helper.simpleTextFieldStyle(
                          Colors.white, 17, FontWeight.normal)),
                    )),
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
                    child: Center(
                      child: Text("Kiểm tra tài khoản",
                      style: Helper.simpleTextFieldStyle(
                          Colors.white, 17, FontWeight.normal)),
                    )),
              ),
            ),
          ],
        ));
  }
}
