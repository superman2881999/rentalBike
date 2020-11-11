import 'package:EcobikeRental/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreditCardInfo extends StatefulWidget {
  @override
  _CreditCardInfoState createState() => _CreditCardInfoState();
}

class _CreditCardInfoState extends State<CreditCardInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thẻ của tôi"),elevation: 0,actions: [
        IconButton(tooltip: "Thông tin của thẻ",icon: Icon(Icons.info_outline), onPressed: (){})
      ],),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(color: Color(0xFFEF5350)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Số dư tài khoản",style: simpleTextFieldStyle(Colors.white70, 15.0),),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("1.000.000",style: simpleTextFieldStyle(Colors.white, 35.0),),
                ),
                Divider(color: Colors.white70,endIndent: 10.0,indent: 10.0,),
                Padding(
                  padding: const EdgeInsets.only(top:10.0,bottom:20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset("images/naptien.png",fit: BoxFit.cover,height: 40,width: 40,),
                          ),
                          Text("Nạp tiền",style: simpleTextFieldStyle(Colors.white70, 15.0),)
                      ],)),
                      Expanded(child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("images/ruttien.png",fit: BoxFit.cover,height: 40,width: 40,),
                        ),
                        Text("Rút tiền",style: simpleTextFieldStyle(Colors.white70, 15.0),)
                      ],)),
                      Expanded(child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("images/chuyentien.png",fit: BoxFit.cover,height: 40,width: 40,),
                        ),
                        Text("Chuyển tiền",style: simpleTextFieldStyle(Colors.white70, 15.0),)
                      ],)),
                      Expanded(child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("images/lichsu.png",fit: BoxFit.cover,height: 40,width: 40,),
                        ),
                        Text("Lịch sử",style: simpleTextFieldStyle(Colors.white70, 15.0),)
                      ],)),
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
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 30.0,horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.blueAccent),
                        child: ButtonTheme(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Image.asset("images/BIDV.png",fit: BoxFit.cover,height: 40,width: 40,),
                                            ),
                                            Text("BIDV",style: simpleTextFieldStyle(Colors.white, 15.0),)
                                          ],
                                        ),
                                      ),
                                      Text("* * * * * * 2 6 5 6",style: simpleTextFieldStyle(Colors.white, 20.0),)
                                    ],
                                  ),
                                ),
                               Expanded(child: Icon(Icons.check_circle,color: Colors.white,size:40.0))
                              ],
                            ) )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 45.0,horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Color(0xFF82B1FF)),
                        child: ButtonTheme(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add,color: Colors.white,),
                              Text("Thêm liên kết",style: simpleTextFieldStyle(Colors.white, 17.0))
                          ],
                        ) )),
                  ),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}
