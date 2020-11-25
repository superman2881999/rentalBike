import 'package:flutter/material.dart';

import 'Model/bike_model.dart';
import 'bike_detail.dart';
import 'intro_app/splash_screen.dart';
import 'widget.dart';

class SliderBike extends StatefulWidget {
  const SliderBike({Key key, this.parkingId, this.nameParking})
      : super(key: key);
  final String nameParking;
  final int parkingId;
  @override
  _SliderBikeState createState() => _SliderBikeState();
}

class _SliderBikeState extends State<SliderBike> {
  List<BikeModel> listSingleBike = SplashScreen.listSingleBike;
  List<BikeModel> listSingleBikeById = [];
  @override
  void initState() {
    for (var i = 0; i < listSingleBike.length; i++) {
      if (listSingleBike[i].parkingId == widget.parkingId) {
        listSingleBikeById.add(listSingleBike[i]);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return listSingleBikeById.isEmpty
        ? const Center(
            child: Text("Không có xe sẵn cho bạn"),
          )
        : ListView.builder(
            itemCount: listSingleBikeById.length,
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
                        leading: Image.asset("images/bikesonsuRed.png",
                            height: 30, width: 30, fit: BoxFit.fill),
                        title: Text(listSingleBikeById[index].nameBike,
                            style: simpleTextFieldStyle(Colors.black, 15)),
                        subtitle: Text(
                          listSingleBikeById[index].state,
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
                                    bikeModel: listSingleBikeById[index],
                                    nameParking: widget.nameParking,
                                  ),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image.asset("images/bikesonsuRed.png",
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
