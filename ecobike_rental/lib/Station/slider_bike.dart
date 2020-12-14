import 'package:flutter/material.dart';

import '../IntroApp/splash_screen.dart';
import '../Model/bike_model.dart';
import '../RentBike/bike_detail.dart';
import '../Service/widget.dart';
import '../service/database.dart';

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
    DatabaseService.getListBike().then((value) {
      SplashScreen.listSingleBike.clear();
      value.once().then((snapshot) {
        final Map<dynamic, dynamic> values = snapshot.value;
        // ignore: cascade_invocations
        values.forEach((key, values) {
          if (values["typeBike"] == "Xe Đạp") {
            SplashScreen.listSingleBike.add(BikeModel(
                bikeId: values["bikeId"],
                batteryCapacity: values["batteryCapacity"],
                typeBike: values["typeBike"],
                urlImage: values["colorBike"],
                nameBike: values["nameBike"],
                codeBike: values["codeBike"],
                deposit: values["deposit"],
                state: values["state"],
                licensePlate: values["licensePlate"],
                parkingId: values["parkingId"]));
          }
        });
      });
    });
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
                        leading: Image.network(
                            listSingleBikeById[index]
                                .urlImage["urlImage${index+1}"],
                            height: 30,
                            width: 30,
                            fit: BoxFit.fill),
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
                                child: Image.network(
                                    listSingleBikeById[index]
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
