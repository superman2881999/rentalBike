import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../IntroApp/splash_screen.dart';
import '../Model/credit_card_model.dart';
import 'database.dart';
import 'widget.dart';

class CreditCardInfo extends StatefulWidget {
  @override
  _CreditCardInfoState createState() => _CreditCardInfoState();
}

class _CreditCardInfoState extends State<CreditCardInfo> {
  @override
  Widget build(BuildContext context) {
    setState(() {
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
                  dateExpired: values["dateExpired"],
                  secretKey: values["secretKey"]);
            });
          }
        });
      });
    });
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: AssetImage("images/cardInfo.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Image.asset(
                                        "images/iconChip.png",
                                        fit: BoxFit.fill,
                                      )),
                                  SizedBox(
                                      width: 60,
                                      height: 25,
                                      child: Image.asset(
                                        "images/logoCard.png",
                                        fit: BoxFit.fill,
                                      )),
                                ],
                              ),
                            ),
                            Text(SplashScreen.creditCardModelInfo.codeCard,
                                style: const TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 2,
                                    fontSize: 25)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    // ignore: lines_longer_than_80_chars
                                    Text("CHỦ THẺ",style: simpleTextFieldStyle(Colors.white38, 15)),
                                    // ignore: lines_longer_than_80_chars
                                    Text("Group 5",style: simpleTextFieldStyle(Colors.white70, 17))
                                  ],
                                ),
                                const SizedBox(width: 50),
                                Column(
                                  children: [
                                    // ignore: lines_longer_than_80_chars
                                    Text("CVV",style: simpleTextFieldStyle(Colors.white38, 15)),
                                    // ignore: lines_longer_than_80_chars
                                    Text(SplashScreen.creditCardModelInfo.cvvCode.toString(),style: simpleTextFieldStyle(Colors.white70, 17))
                                  ],
                                ),
                                Column(
                                  children: [
                                    // ignore: lines_longer_than_80_chars
                                    Text("HẠN SỬ DỤNG",style: simpleTextFieldStyle(Colors.white38, 15)),
                                    // ignore: lines_longer_than_80_chars
                                    Text(SplashScreen.creditCardModelInfo.dateExpired,style: simpleTextFieldStyle(Colors.white70, 17))
                                  ],
                                )
                              ],
                            )
                          ],
                        )),
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
