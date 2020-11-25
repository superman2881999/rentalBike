import 'package:flutter/material.dart';

import 'Model/history_transaction_model.dart';
import 'intro_app/splash_screen.dart';
import 'service/database.dart';
import 'widget.dart';

class TransactionHistory extends StatefulWidget {
  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 5;
    DatabaseService.getListHistoryTransaction().then((value) {
      SplashScreen.listHistoryTransaction.clear();
      SplashScreen.listIsCheck.clear();
      value.once().then((snapshot) {
        final Map<dynamic, dynamic> values = snapshot.value;
        // ignore: cascade_invocations
        values.forEach((key, values) {
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("500.000 đ",
                                style:
                                    especiallyTextFieldStyle(Colors.black, 14)),
                            const Expanded(child: Text("Tổng tiền"))
                          ],
                        ),
                        Column(
                          children: [
                            Text("34 giờ",
                                style:
                                    especiallyTextFieldStyle(Colors.black, 14)),
                            const Expanded(child: Text("Tổng thời gian"))
                          ],
                        )
                      ],
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
                        ? const Text("Không có giao dịch nào")
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
                                                            SplashScreen.listIsCheck[
                                                                        index]
                                                                    [index] =
                                                                !SplashScreen
                                                                // ignore: lines_longer_than_80_chars
                                                                        .listIsCheck[index][index];
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
                                                                        index]
                                                                    [index] =
                                                                !SplashScreen
                                                                // ignore: lines_longer_than_80_chars
                                                                        .listIsCheck[index][index];
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
                                                            // ignore: lines_longer_than_80_chars
                                                            style: simpleTextFieldStyle(
                                                                    Colors
                                                                        .black,
                                                                    16)),
                                                        // ignore: lines_longer_than_80_chars
                                                        Text(SplashScreen.listHistoryTransaction[
                                                                    index]
                                                                // ignore: lines_longer_than_80_chars
                                                                .timeRentBike, style: simpleTextFieldStyle(
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
                                                        Text("Loại xe", style: simpleTextFieldStyle(
                                                                    Colors
                                                                        .black,
                                                                    // ignore: lines_longer_than_80_chars
                                                                    16)), Text(SplashScreen.listHistoryTransaction[
                                                                    // ignore: lines_longer_than_80_chars
                                                                    index].typeBike, style: simpleTextFieldStyle(
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
                                                        Text("Biển số xe", style: simpleTextFieldStyle(
                                                                    Colors
                                                                        .black,
                                                                    16)),
                                                        Text(
                                                            // ignore: lines_longer_than_80_chars
                                                            SplashScreen.listHistoryTransaction[
                                                                    index]
                                                                // ignore: lines_longer_than_80_chars
                                                                .licensePlate, style: simpleTextFieldStyle(
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
