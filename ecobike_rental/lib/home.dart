import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Model/parking_model.dart';
import 'drawer.dart';
import 'intro_app/splash_screen.dart';
import 'parking_detail.dart';
import 'widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ParkingModel> listParking;
  @override
  void initState() {
    listParking = SplashScreen.listParking;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(
            Image.asset("images/title.png", fit: BoxFit.cover), context),
        drawer: Draw(),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: listParking.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ParkingDetail(
                            listParking[index].parkingId,
                            listParking[index].nameParking)));
              },
              child: Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: Container(
                      padding: const EdgeInsets.only(right: 12),
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  width: 1, color: Colors.redAccent))),
                      child: Image.asset("images/bikeParking.png",
                          fit: BoxFit.cover)),
                  title: Text(listParking[index].nameParking,
                      style: especiallyTextFieldStyle(Colors.black, 17)),
                  subtitle: Text(listParking[index].description),
                  trailing: const Icon(Icons.keyboard_arrow_right,
                      color: Colors.black, size: 30),
                ),
              ),
            );
          },
        ));
  }
}
