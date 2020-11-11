import 'package:EcobikeRental/widget.dart';
import 'package:flutter/material.dart';

class TransactionHistory extends StatefulWidget {
  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  List<Map<int, bool>> listIsCheck = [
    {0: false},
    {1: false},
    {2: false},
    {3: false},
    {4: false},
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 5;
    return Scaffold(
      appBar: appBarMain(Text("Lịch sử thuê xe"),context),
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
                    padding: const EdgeInsets.only(top:20.0),
                    child: Text("Lịch sử thuê xe",style: especiallyTextFieldStyle(Colors.black, 23.0),),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [Text("500.000 đ",style: especiallyTextFieldStyle(Colors.black, 14.0)), Expanded(child: Text("Tổng tiền"))],
                        ),
                        Column(
                          children: [Text("34 giờ",style: especiallyTextFieldStyle(Colors.black, 14.0)), Expanded(child: Text("Tổng thời gian"))],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Card(
              elevation: 10.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  itemCount: listIsCheck.length,
                  itemBuilder: (context, index) {
                    return Card(
                        elevation: 10.0,
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          decoration: BoxDecoration(
                            color: listIsCheck[index][index] ? Color(0xFF90CAF9) : Colors.white,
                          ),
                          curve: Curves.fastOutSlowIn,
                          height: listIsCheck[index][index] ? MediaQuery.of(context).size.height/3 : 100.0,
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  child: Image.asset("images/facebook.png"),
                                ),
                                title: Text("Thuê xe đi Bách Khoa"),
                                subtitle: Text("11/10/2020"),
                                trailing: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: listIsCheck[index][index]
                                          ? IconButton(
                                              icon:
                                                  Icon(Icons.keyboard_arrow_up),
                                              onPressed: () {
                                                setState(() {
                                                  listIsCheck[index][index] =
                                                      !listIsCheck[index]
                                                          [index];
                                                });
                                              })
                                          : IconButton(
                                              icon: Icon(
                                                  Icons.keyboard_arrow_down),
                                              onPressed: () {
                                                setState(() {
                                                  listIsCheck[index][index] =
                                                      !listIsCheck[index]
                                                          [index];
                                                });
                                              }),
                                    ),
                                    Text("-70.000 đ"),
                                  ],
                                ),
                              ),
                              listIsCheck[index][index]
                                  ? Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Thời gian thuê",
                                                      style: simpleTextFieldStyle(
                                                          Colors.black, 16.0)),
                                                  Text("00:00:05",
                                                      style: simpleTextFieldStyle(
                                                          Colors.black, 16.0))
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Loại xe",
                                                      style: simpleTextFieldStyle(
                                                          Colors.black, 16.0)),
                                                  Text("Xe đạp điện",
                                                      style: simpleTextFieldStyle(
                                                          Colors.black, 16.0))
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Biển số xe",
                                                      style: simpleTextFieldStyle(
                                                          Colors.black, 16.0)),
                                                  Text("29A2-13671",
                                                      style: simpleTextFieldStyle(
                                                          Colors.black, 16.0))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                    ),
                                  )
                                  : Container(),
                            ],
                          ),
                        ));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
