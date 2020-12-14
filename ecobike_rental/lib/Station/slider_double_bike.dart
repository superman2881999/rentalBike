import 'package:flutter/material.dart';

import '../IntroApp/splash_screen.dart';
import '../Model/bike_model.dart';
import '../RentBike/bike_detail.dart';
import '../Service/database.dart';
import '../Service/widget.dart';

class SliderDoubleBike extends StatefulWidget {
  const SliderDoubleBike({Key key, this.parkingId, this.nameParking})
      : super(key: key);
  final String nameParking;
  final int parkingId;
  @override
  _SliderDoubleBikeState createState() => _SliderDoubleBikeState();
}

class _SliderDoubleBikeState extends State<SliderDoubleBike> {
  List<BikeModel> listDoubleBike = SplashScreen.listDoubleBike;
  List<BikeModel> listDoubleBikeById = [];
  @override
  void initState() {
    DatabaseService.getListBike().then((value) {
      SplashScreen.listDoubleBike.clear();
      value.once().then((snapshot) {
        final Map<dynamic, dynamic> values = snapshot.value;
        // ignore: cascade_invocations
        values.forEach((key, values) {
          if(values["typeBike"] == "Xe Đạp Đôi") {
            SplashScreen.listDoubleBike.add(BikeModel(
                bikeId: values["bikeId"],
                typeBike: values["typeBike"],
                urlImage: values["colorBike"],
                nameBike: values["nameBike"],
                codeBike: values["codeBike"],
                deposit: values["deposit"],
                state: values["state"],
                parkingId: values["parkingId"]));
          }
        });
      });
    });
    for (var i = 0; i < listDoubleBike.length; i++) {
      if (listDoubleBike[i].parkingId == widget.parkingId) {
        listDoubleBikeById.add(listDoubleBike[i]);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return listDoubleBikeById.isEmpty
        ? const Center(
            child: Text("Không có xe sẵn cho bạn"),
          )
        : ListView.builder(
            itemCount: listDoubleBikeById.length,
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
                        leading: Image.network(listDoubleBikeById[index]
                            .urlImage["urlImage${index+1}"],
                            height: 30, width: 30, fit: BoxFit.fill),
                        title: Text(listDoubleBikeById[index].nameBike,
                            style: simpleTextFieldStyle(Colors.black, 15)),
                        subtitle: Text(
                          listDoubleBikeById[index].state,
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
                                    bikeModel: listDoubleBikeById[index],
                                    nameParking: widget.nameParking,
                                  ),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image.network(listDoubleBikeById[index]
                                    .urlImage["urlImage${index+1}"],
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
