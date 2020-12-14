import 'package:flutter/material.dart';

import '../IntroApp/splash_screen.dart';
import '../Model/history_transaction_model.dart';
import 'database.dart';
import 'widget.dart';

class TransactionHistory extends StatefulWidget {
  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  @override
  void initState() {
    // lấy total time và total money
    DatabaseService.getTotalMoneyAndTime().then((value) {
      value.once().then((snapshot) {
        SplashScreen.totalMoney = snapshot.value["totalMoney"];
        SplashScreen.totalTime = snapshot.value["totalTime"];
      });
    });
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
        // ignore: lines_longer_than_80_chars
        for (var i = 0; i < SplashScreen.listHistoryTransaction.length; i++) {
          SplashScreen.listIsCheck.add({i: false});
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 5;
    return Scaffold(
      appBar: appBarMain(const Text("Lịch sử thuê xe"), context),
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
                      style: especiallyTextFieldStyle(Colors.black, 23),
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
                              Text("${SplashScreen.totalMoney}",
                                  style: especiallyTextFieldStyle(
                                      Colors.black, 14)),
                              const Expanded(child: Text("Tổng tiền"))
                            ],
                          ),
                          Column(
                            children: [
                              Text("${SplashScreen.totalTime}",
                                  style: especiallyTextFieldStyle(
                                      Colors.black, 14)),
                              const Expanded(child: Text("Tổng thời gian"))
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
                                            child: Image.asset(
                                                "images/facebook.png"),
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
                                                            SplashScreen.listIsCheck[index][index] = !SplashScreen.listIsCheck[index][index];
                                                          });
                                                        })
                                                    : IconButton(
                                                        icon: const Icon(Icons
                                                            // ignore: lines_longer_than_80_chars
                                                            .keyboard_arrow_down),
                                                        onPressed: () {
                                                          setState(() {
                                                            // ignore: lines_longer_than_80_chars
                                                            SplashScreen.listIsCheck[index][index] = !SplashScreen.listIsCheck[index][index];
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
                                                                simpleTextFieldStyle(
                                                                    Colors
                                                                        .black,
                                                                    16)),

                                                        Text(
                                                          // ignore: lines_longer_than_80_chars
                                                            SplashScreen.listHistoryTransaction[index].timeRentBike,
                                                            style:
                                                            // ignore: lines_longer_than_80_chars
                                                                simpleTextFieldStyle(Colors.black, 16))
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
                                                            style: simpleTextFieldStyle(Colors.black, 16)),
                                                        Text(
                                                            SplashScreen
                                                            // ignore: lines_longer_than_80_chars
                                                                .listHistoryTransaction[
                                                                    index]
                                                                .typeBike,
                                                            style:
                                                            // ignore: lines_longer_than_80_chars
                                                                simpleTextFieldStyle(
                                                                    Colors
                                                                        .black,
                                                                    16))
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
                                                                simpleTextFieldStyle(
                                                                    Colors
                                                                        .black,
                                                                    16)),
                                                        Text(
                                                            // ignore: lines_longer_than_80_chars
                                                            SplashScreen
                                                            // ignore: lines_longer_than_80_chars
                                                                .listHistoryTransaction[
                                                                    index]
                                                                .licensePlate,
                                                            style:
                                                            // ignore: lines_longer_than_80_chars
                                                                simpleTextFieldStyle(
                                                                    Colors
                                                                        .black,
                                                                    16))
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
