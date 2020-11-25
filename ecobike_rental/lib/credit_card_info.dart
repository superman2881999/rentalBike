import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Model/credit_card_model.dart';
import 'intro_app/splash_screen.dart';
import 'service/database.dart';
import 'widget.dart';

class CreditCardInfo extends StatefulWidget {
  @override
  _CreditCardInfoState createState() => _CreditCardInfoState();
}

class _CreditCardInfoState extends State<CreditCardInfo> {
  @override
  Widget build(BuildContext context) {
    DatabaseService.getCard(1).then((value) {
      value.once().then((snapshot) {
        final Map<dynamic, dynamic> values = snapshot.value;
        if (mounted) {
          setState(() {
            SplashScreen.creditCardModelInfo = CreditCardModel(
                userId: values["userId"],
                amountMoney: values["amountMoney"],
                appCode: values["appCode"],
                cardId: values["cardId"],
                codeCard: values["codeCard"],
                cvvCode: values["cvvCode"],
                dateExprited: values["dateExprited"],
                secretKey: values["secretKey"]);
          });
        }
      });
    });
    final codeCard =
        SplashScreen.creditCardModelInfo.codeCard.replaceRange(0, 14, '*' * 14);
    return Scaffold(
      appBar: appBarMain(const Text("Thẻ của tôi"), context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(color: Color(0xFFEF5350)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Số dư tài khoản",
                    style: simpleTextFieldStyle(Colors.white70, 15),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "${SplashScreen.creditCardModelInfo.amountMoney}",
                      style: simpleTextFieldStyle(Colors.white, 35),
                    )),
                const Divider(
                  color: Colors.white70,
                  endIndent: 10,
                  indent: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              "images/naptien.png",
                              fit: BoxFit.cover,
                              height: 40,
                              width: 40,
                            ),
                          ),
                          Text(
                            "Nạp tiền",
                            style: simpleTextFieldStyle(Colors.white70, 15),
                          )
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              "images/ruttien.png",
                              fit: BoxFit.cover,
                              height: 40,
                              width: 40,
                            ),
                          ),
                          Text(
                            "Rút tiền",
                            style: simpleTextFieldStyle(Colors.white70, 15),
                          )
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              "images/chuyentien.png",
                              fit: BoxFit.cover,
                              height: 40,
                              width: 40,
                            ),
                          ),
                          Text(
                            "Chuyển tiền",
                            style: simpleTextFieldStyle(Colors.white70, 15),
                          )
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              "images/lichsu.png",
                              fit: BoxFit.cover,
                              height: 40,
                              width: 40,
                            ),
                          ),
                          Text(
                            "Lịch sử",
                            style: simpleTextFieldStyle(Colors.white70, 15),
                          )
                        ],
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blueAccent),
                        child: ButtonTheme(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Image.asset(
                                            "images/BIDV.png",
                                            fit: BoxFit.cover,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                        Text(
                                          "BIDV",
                                          style: simpleTextFieldStyle(
                                              Colors.white, 15),
                                        )
                                      ],
                                    ),
                                  ),
                                  Text(
                                    codeCard,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        letterSpacing: 2),
                                  )
                                ],
                              ),
                            ),
                            const Expanded(
                                child: Icon(Icons.check_circle,
                                    color: Colors.white, size: 40))
                          ],
                        ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 45, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFF82B1FF)),
                        child: ButtonTheme(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            Text("Thêm liên kết",
                                style: simpleTextFieldStyle(Colors.white, 17))
                          ],
                        ))),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        tooltip: "Làm mới tiền",
        onPressed: () {
          DatabaseService.updateMoneyCard(1000000);
        },
        child: const Icon(Icons.autorenew),
      ),
    );
  }
}
