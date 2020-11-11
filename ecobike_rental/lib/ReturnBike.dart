import 'package:EcobikeRental/CreditCardInfo.dart';
import 'package:EcobikeRental/widget.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class ReturnBike extends StatefulWidget {
  final String timeRentBike;
  ReturnBike(this.timeRentBike);
  @override
  _ReturnBikeState createState() => _ReturnBikeState();
}

class _ReturnBikeState extends State<ReturnBike> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(Text("Thông tin hoá đơn"),context),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.only(left:25.0,right: 15.0,top: 10.0,bottom: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Thông tin dịch vụ",style: especiallyTextFieldStyle(Colors.black, 18.0)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Ngày thuê",style: simpleTextFieldStyle(Colors.black, 16.0)),
                                  Text("09/11/2020",style: simpleTextFieldStyle(Colors.black, 16.0))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Thời gian thuê",style: simpleTextFieldStyle(Colors.black, 16.0)),
                                  Text(widget.timeRentBike,style: simpleTextFieldStyle(Colors.black, 16.0))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Loại xe",style: simpleTextFieldStyle(Colors.black, 16.0)),
                                  Text("Xe đạp điện",style: simpleTextFieldStyle(Colors.black, 16.0))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Biển số xe",style: simpleTextFieldStyle(Colors.black, 16.0)),
                                  Text("29A2-13671",style: simpleTextFieldStyle(Colors.black, 16.0))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.only(left:25.0,right: 15.0,top: 10.0,bottom: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Chi phí",style: especiallyTextFieldStyle(Colors.black, 18.0)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Tiền cọc",style: simpleTextFieldStyle(Colors.black, 16.0)),
                                  Text("+ 200.000 đ",style: simpleTextFieldStyle(Colors.black, 16.0))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Tiền thuê xe",style: simpleTextFieldStyle(Colors.black, 16.0)),
                                  Text("- 70.000 đ",style: simpleTextFieldStyle(Colors.black, 16.0))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Chi phí phụ",style: simpleTextFieldStyle(Colors.black, 16.0)),
                                  Text("- 0 đ",style: simpleTextFieldStyle(Colors.black, 16.0))
                                ],
                              ),
                              Divider(color: Colors.grey,indent: 20.0,
                                endIndent: 20.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text("Đã thanh toán",style: especiallyTextFieldStyle(Colors.red, 16.0),)),
                                  Text("130.000 đ",style: especiallyTextFieldStyle(Colors.red, 16.0))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      Home()), (Route<dynamic> route) => false);
                },
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        vertical: 15.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blue),
                    child: ButtonTheme(
                        child: Center(
                          child: Text("Hoàn tất dịch vụ",
                              style: simpleTextFieldStyle(
                                  Colors.white, 17.0)),
                        ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:10.0,left: 10.0,right: 10.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreditCardInfo()));
                },
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        vertical: 15.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blue),
                    child: ButtonTheme(
                        child: Center(
                          child: Text("Kiểm tra tài khoản",
                              style: simpleTextFieldStyle(
                                  Colors.white, 17.0)),
                        ))),
              ),
            ),
          ],

        ));
  }
}
