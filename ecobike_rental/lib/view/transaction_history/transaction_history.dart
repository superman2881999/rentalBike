import 'package:flutter/material.dart';

import '../../controller/transaction_history/transaction_history_controller.dart';
import '../../helper/widget.dart';
import '../intro_app/splash_screen.dart';

///Trả về 1 instance _TransactionHistoryState
class TransactionHistory extends StatefulWidget {
  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

///Lớp quản lý danh sách lịch sử giao dịch
class _TransactionHistoryState extends State<TransactionHistory> {
  TransactionHistoryController transactionHistoryController =
      TransactionHistoryController();
  @override
  void initState() {
    transactionHistoryController.getTotalMoneyAndTime();
    // ignore: cascade_invocations
    transactionHistoryController.getListHistoryTransaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 5;
    return Scaffold(
      appBar: Helper.appBarMain(const Text("Lịch sử thuê xe"), context),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: height,
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Lịch sử thuê xe",
                      // ignore: lines_longer_than_80_chars
                      style: Helper.simpleTextFieldStyle(
                          Colors.black, 23, FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              if (SplashScreen.totalMoney == null)
                                Text("0",
                                    style: Helper.simpleTextFieldStyle(
                                        Colors.black, 15, FontWeight.bold))
                              else
                                Text("${SplashScreen.totalMoney}",
                                    style: Helper.simpleTextFieldStyle(
                                        Colors.black, 15, FontWeight.bold)),
                              Expanded(
                                  child: Text("Tổng tiền",
                                      style: Helper.simpleTextFieldStyle(
                                          Colors.black, 15, FontWeight.normal)))
                            ],
                          ),
                          Column(
                            children: [
                              if (SplashScreen.totalTime == null)
                                Text("0 giờ 0 phút",
                                    style: Helper.simpleTextFieldStyle(
                                        Colors.black, 15, FontWeight.bold))
                              else
                                Text("${SplashScreen.totalTime}",
                                    style: Helper.simpleTextFieldStyle(
                                        Colors.black, 15, FontWeight.bold)),
                              Expanded(
                                  child: Text("Tổng thời gian",
                                      style: Helper.simpleTextFieldStyle(
                                          Colors.black, 15, FontWeight.normal)))
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 10,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SplashScreen.listHistoryTransaction.isEmpty
                        ? const Center(child: Text("Không có giao dịch nào"))
                        : ListView.builder(
                            itemCount:
                                SplashScreen.listHistoryTransaction.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  elevation: 10,
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 1),
                                    decoration: BoxDecoration(
                                      color: SplashScreen.listIsCheck[index]
                                              [index]
                                          ? const Color(0xFFFF8A80)
                                          : Colors.white,
                                    ),
                                    curve: Curves.fastOutSlowIn,
                                    height: SplashScreen.listIsCheck[index]
                                            [index]
                                        ? MediaQuery.of(context).size.height / 3
                                        : 100.0,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: SplashScreen
                                                    .listIsCheck[index][index]
                                                ? const Color(0xFFFF8A80)
                                                : Colors.white,
                                            maxRadius: 30,
                                            child: Image.asset(
                                                "images/icons8-payment-history-100.png"),
                                          ),
                                          title: Text(SplashScreen
                                              .listHistoryTransaction[index]
                                              .transactionName),
                                          subtitle: Text(SplashScreen
                                              .listHistoryTransaction[index]
                                              .dateRentBike),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: SplashScreen
                                                            .listIsCheck[index]
                                                        [index]
                                                    ? IconButton(
                                                        icon: const Icon(Icons
                                                            .keyboard_arrow_up),
                                                        onPressed: () {
                                                          setState(() {
                                                            // ignore: lines_longer_than_80_chars
                                                            SplashScreen.listIsCheck[
                                                                    index][
                                                                // ignore: lines_longer_than_80_chars
                                                                index] = !SplashScreen
                                                                    // ignore: lines_longer_than_80_chars
                                                                    .listIsCheck[
                                                                // ignore: lines_longer_than_80_chars
                                                                index][index];
                                                          });
                                                        })
                                                    : IconButton(
                                                        icon: const Icon(Icons
                                                            // ignore: lines_longer_than_80_chars
                                                            .keyboard_arrow_down),
                                                        onPressed: () {
                                                          setState(() {
                                                            // ignore: lines_longer_than_80_chars
                                                            SplashScreen.listIsCheck[
                                                                    index][
                                                                // ignore: lines_longer_than_80_chars
                                                                index] = !SplashScreen
                                                                    // ignore: lines_longer_than_80_chars
                                                                    .listIsCheck[
                                                                // ignore: lines_longer_than_80_chars
                                                                index][index];
                                                          });
                                                        }),
                                              ),
                                              Text(
                                                  // ignore: lines_longer_than_80_chars
                                                  "- ${SplashScreen.listHistoryTransaction[index].paymentMoney} đ"),
                                            ],
                                          ),
                                        ),
                                        if (SplashScreen.listIsCheck[index]
                                            [index])
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("Thời gian thuê",
                                                            style:
                                                                // ignore: lines_longer_than_80_chars
                                                                Helper.simpleTextFieldStyle(
                                                                  // ignore: lines_longer_than_80_chars
                                                                    Colors.black,
                                                                    16,
                                                                    FontWeight
                                                                        // ignore: lines_longer_than_80_chars
                                                                        .normal)),
                                                        Text(
                                                            // ignore: lines_longer_than_80_chars
                                                            SplashScreen
                                                                // ignore: lines_longer_than_80_chars
                                                                .listHistoryTransaction[
                                                                    index]
                                                                .timeRentBike,
                                                            style:
                                                                // ignore: lines_longer_than_80_chars
                                                                Helper.simpleTextFieldStyle(
                                                                  // ignore: lines_longer_than_80_chars
                                                                    Colors.black,
                                                                    16,
                                                                    FontWeight
                                                                        // ignore: lines_longer_than_80_chars
                                                                        .normal))
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("Loại xe",
                                                            // ignore: lines_longer_than_80_chars
                                                            style:
                                                                // ignore: lines_longer_than_80_chars
                                                                Helper.simpleTextFieldStyle(
                                                                  // ignore: lines_longer_than_80_chars
                                                                    Colors.black,
                                                                    16,
                                                                    FontWeight
                                                                        // ignore: lines_longer_than_80_chars
                                                                        .normal)),
                                                        Text(
                                                            SplashScreen
                                                                // ignore: lines_longer_than_80_chars
                                                                .listHistoryTransaction[
                                                                    index]
                                                                .typeBike,
                                                            style:
                                                                // ignore: lines_longer_than_80_chars
                                                                Helper.simpleTextFieldStyle(
                                                                  // ignore: lines_longer_than_80_chars
                                                                    Colors.black,
                                                                    16,
                                                                    FontWeight
                                                                        // ignore: lines_longer_than_80_chars
                                                                        .normal))
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        // ignore: lines_longer_than_80_chars
                                                        Text("Biển số xe",
                                                            style:
                                                                // ignore: lines_longer_than_80_chars
                                                                Helper.simpleTextFieldStyle(
                                                                  // ignore: lines_longer_than_80_chars
                                                                    Colors.black,
                                                                    16,
                                                                    FontWeight
                                                                        // ignore: lines_longer_than_80_chars
                                                                        .normal)),
                                                        Text(
                                                            // ignore: lines_longer_than_80_chars
                                                            SplashScreen
                                                                // ignore: lines_longer_than_80_chars
                                                                .listHistoryTransaction[
                                                                    index]
                                                                .licensePlate,
                                                            style:
                                                                // ignore: lines_longer_than_80_chars
                                                                Helper.simpleTextFieldStyle(
                                                                  // ignore: lines_longer_than_80_chars
                                                                    Colors.black,
                                                                    16,
                                                                    FontWeight
                                                                        // ignore: lines_longer_than_80_chars
                                                                        .normal))
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        else
                                          Container(),
                                      ],
                                    ),
                                  ));
                            },
                          )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
