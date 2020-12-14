import 'package:flutter/material.dart';

import '../IntroApp/splash_screen.dart';
import '../Model/bike_model.dart';
import '../RentBike/bike_detail.dart';
import '../Service/widget.dart';
import '../service/database.dart';

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
    DatabaseService.getListBike().then((value) {
      SplashScreen.listElectricBike.clear();
      value.once().then((snapshot) {
        final Map<dynamic, dynamic> values = snapshot.value;
        // ignore: cascade_invocations
        values.forEach((key, values) {
          if (values["typeBike"] == "Xe Đạp Điện") {
            SplashScreen.listElectricBike.add(BikeModel(
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
                        leading: Image.network(listElectricBikeById[index]
                            .urlImage["urlImage${index+1}"],
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
                                child: Image.network(listElectricBikeById[index]
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
