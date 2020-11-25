import 'package:flutter/material.dart';

import 'Model/bike_model.dart';
import 'bike_detail.dart';
import 'intro_app/splash_screen.dart';
import 'widget.dart';

class SliderElectricBike extends StatefulWidget {
  const SliderElectricBike({Key key, this.parkingId, this.nameParking})
      : super(key: key);
  final String nameParking;
  final int parkingId;
  @override
  _SliderElectricBikeState createState() => _SliderElectricBikeState();
}

class _SliderElectricBikeState extends State<SliderElectricBike> {
  List<BikeModel> listElectricBike = SplashScreen.listElectricBike;
  List<BikeModel> listElectricBikeById = [];
  @override
  void initState() {
    for (var i = 0; i < listElectricBike.length; i++) {
      if (listElectricBike[i].parkingId == widget.parkingId) {
        listElectricBikeById.add(listElectricBike[i]);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return listElectricBikeById.isEmpty
        ? const Center(
            child: Text("Không có xe sẵn cho bạn"),
          )
        : ListView.builder(
            itemCount: listElectricBikeById.length,
            itemExtent: 350,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Image.asset("images/bikesonsuBlue.png",
                            height: 30, width: 30, fit: BoxFit.fill),
                        title: Text(listElectricBikeById[index].nameBike,
                            style: simpleTextFieldStyle(Colors.black, 15)),
                        subtitle: Text(
                          listElectricBikeById[index].state,
                          style: simpleTextFieldStyle(Colors.black26, 13),
                        ),
                      ),
                      const Divider(
                        indent: 10,
                        endIndent: 10,
                        color: Colors.grey,
                      ),
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BikeDetail(
                                    bikeModel: listElectricBikeById[index],
                                    nameParking: widget.nameParking,
                                  ),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image.asset("images/bikesonsuBlue.png",
                                    fit: BoxFit.fill,
                                    width: MediaQuery.of(context).size.width),
                              ))),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
