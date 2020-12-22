import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../IntroApp/splash_screen.dart';
import '../Model/credit_card_model.dart';
import 'database.dart';
import 'widget.dart';

///Trả về 1 instance _CreditCardInfoState
class CreditCardInfo extends StatefulWidget {
  @override
  _CreditCardInfoState createState() => _CreditCardInfoState();
}

/// Lớp quản lý thông tin của thẻ tín dụng
class _CreditCardInfoState extends State<CreditCardInfo> {
  static const platform = MethodChannel("Transaction");
  // call api reset tiền trong thẻ
  Future<String> resetMoney() async {
    String value;
    try {
      value = await platform.invokeMethod('ResetMoney', {
        "command": "refund",
        "cardCode": "118609_group5_2020",
        "owner": "Group 5",
        "cvvCode": "271",
        "dateExpired": "1125",
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      //Cập nhật lại tiền trong thẻ
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
      appBar: Service.appBarMain(const Text("Thẻ của tôi"), context),
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
                    style: Service.simpleTextFieldStyle(
                        Colors.white70, 15, FontWeight.normal),
                  ),
                ),
                if (SplashScreen.creditCardModelInfo == null)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        '0',
                        style: Service.simpleTextFieldStyle(
                            Colors.white, 35, FontWeight.normal),
                      ))
                else
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "${SplashScreen.creditCardModelInfo.amountMoney}",
                        style: Service.simpleTextFieldStyle(
                            Colors.white, 35, FontWeight.normal),
                      )),
                const Divider(
                  color: Colors.white70,
                  endIndent: 10,
                  indent: 10,
                ),
              ],
            ),
          ),
          if (SplashScreen.creditCardModelInfo == null)
            Expanded(child: Center(child: Image.asset("images/no.png")))
          else
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      // ignore: lines_longer_than_80_chars
                                      Text("CHỦ THẺ",
                                          style: Service.simpleTextFieldStyle(
                                              Colors.white38,
                                              15,
                                              FontWeight.normal)),
                                      // ignore: lines_longer_than_80_chars
                                      Text("Group 5",
                                          style: Service.simpleTextFieldStyle(
                                              Colors.white70,
                                              17,
                                              FontWeight.normal))
                                    ],
                                  ),
                                  const SizedBox(width: 50),
                                  Column(
                                    children: [
                                      // ignore: lines_longer_than_80_chars
                                      Text("CVV",
                                          style: Service.simpleTextFieldStyle(
                                              Colors.white38,
                                              15,
                                              FontWeight.normal)),
                                      // ignore: lines_longer_than_80_chars
                                      Text(
                                          SplashScreen
                                              .creditCardModelInfo.cvvCode
                                              .toString(),
                                          style: Service.simpleTextFieldStyle(
                                              Colors.white70,
                                              17,
                                              FontWeight.normal))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      // ignore: lines_longer_than_80_chars
                                      Text("HẠN SỬ DỤNG",
                                          style: Service.simpleTextFieldStyle(
                                              Colors.white38,
                                              15,
                                              FontWeight.normal)),
                                      // ignore: lines_longer_than_80_chars
                                      Text(
                                          SplashScreen
                                              .creditCardModelInfo.dateExpired,
                                          style: Service.simpleTextFieldStyle(
                                              Colors.white70,
                                              17,
                                              FontWeight.normal))
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
                                  style: Service.simpleTextFieldStyle(
                                      Colors.white, 17, FontWeight.normal))
                            ],
                          ))),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
      // nút để call api reset Tiền
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        tooltip: "Làm mới tiền",
        onPressed: () {
          resetMoney();
          DatabaseService.updateMoneyCard(1000000);
        },
        child: const Icon(Icons.autorenew),
      ),
    );
  }
}
