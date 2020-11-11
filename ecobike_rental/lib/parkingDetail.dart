import 'package:EcobikeRental/BikeDetail.dart';
import 'package:EcobikeRental/widget.dart';
import 'package:flutter/material.dart';

class ParkingDetail extends StatefulWidget {
  @override
  _ParkingDetailState createState() => _ParkingDetailState();
}

class _ParkingDetailState extends State<ParkingDetail> {
  Widget titleBike(int index) {
    if (index == 0) {
      return Text(
        "Xe Đạp(6)",
        style: especiallyTextFieldStyle(Colors.black, 17.0),
      );
    } else if (index == 1) {
      return Text(
        "Xe Đạp Điện(4)",
        style: especiallyTextFieldStyle(Colors.black, 17.0),
      );
    } else {
      return Text(
        "Xe Đạp Đôi(5)",
        style: especiallyTextFieldStyle(Colors.black, 17.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(Text("Danh sách xe trong bãi"),context),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10.0),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: titleBike(index)),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  itemCount: 5,
                  itemExtent: 250.0,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Image.asset("images/bikesonsuBlack.png",
                                height: 30.0, width: 30.0, fit: BoxFit.fill),
                            title: Text("Tên xe",
                                style: especiallyTextFieldStyle(
                                    Colors.black, 17.0)),
                            subtitle: Text(
                              "Trạng thái: Sẵn sàng",
                              style: simpleTextFieldStyle(Colors.black26, 13.0),
                            ),
                          ),
                          Divider(indent: 10.0,endIndent: 10.0,color: Colors.grey,),
                          Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => BikeDetail(),
                                    ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                        "images/bikesonsuBlack.png",
                                        fit: BoxFit.fill,
                                        height: 150.0,
                                        width:
                                            MediaQuery.of(context).size.width),
                                  ))),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
