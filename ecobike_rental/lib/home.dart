import 'package:EcobikeRental/drawer.dart';
import 'package:EcobikeRental/parkingDetail.dart';
import 'package:EcobikeRental/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(Image.asset("images/title.png",fit: BoxFit.cover),context),
        drawer: Draw(),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ParkingDetail()));
              },
              child: Card(
                elevation: 5.0,
                margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(
                                  width: 1.0, color: Colors.redAccent))),
                      child: Image.asset("images/bikeParking.png",
                          fit: BoxFit.cover)),
                  title: Text("Bãi xe số ${index+1}",style: especiallyTextFieldStyle(Colors.black, 17.0)),
                  subtitle: Text("Cách bạn ${index+1} km"),
                  trailing:  Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
                ),
              ),
            );
          },
        ));
  }
}
