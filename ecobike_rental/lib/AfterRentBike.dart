import 'package:EcobikeRental/ReturnBike.dart';
import 'package:EcobikeRental/drawer.dart';
import 'package:EcobikeRental/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:geolocator/geolocator.dart';

class RentBike extends StatefulWidget {
  final StopWatchTimer _stopWatchTimer;
  Position position;
  RentBike(this._stopWatchTimer, this.position);
  @override
  _RentBikeState createState() => _RentBikeState();
}

class _RentBikeState extends State<RentBike> {
  //google map
  GoogleMapController mapController;
  Set<Marker> markers, markers2;
  Marker marker;
  List<Map<String, LatLng>> listOfMarker;
  List<Map<String, String>> listOfMarkerInfo;

  bool isReturnBike = false;

  @override
  void initState() {
    markers = <Marker>{};
    listOfMarker = [
      {'latLng': LatLng(21.006111, 105.843056)},
      {'latLng': LatLng(21.006111, 105.853056)},
      {'latLng': LatLng(21.006111, 105.863056)},
    ];
    listOfMarkerInfo = [
      {'marker': "1", 'title': "Bãi 1", 'subtitle': "Cách bạn 1 km"},
      {'marker': "2", 'title': "Bãi 2", 'subtitle': "Cách bạn 2 km"},
      {'marker': "3", 'title': "Bãi 3", 'subtitle': "Cách bạn 3 km"},
    ];
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await widget._stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (isReturnBike) {
        for (int i = 0; i < listOfMarker.length; i++) {
          marker = Marker(
              position: listOfMarker[i]['latLng'],
              markerId: MarkerId(listOfMarkerInfo[i]['marker']),
              infoWindow: InfoWindow(
                  title: listOfMarkerInfo[i]['title'],
                  snippet: listOfMarkerInfo[i]['subtitle']),
              icon: BitmapDescriptor.defaultMarker);
          markers.add(marker);
        }
      }
    });
    return Scaffold(
      appBar: appBarMain(Text("Đang thuê xe"),context),
      drawer: Draw(),
      body: Stack(
        children: [
          GoogleMap(
            markers: markers,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                mapController = controller;
                mapController.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                  target: LatLng(widget.position.latitude,
                      widget.position.longitude),
                  zoom: 17.0,
                )));
              });
            },
            initialCameraPosition: CameraPosition(
                target: LatLng(
                    widget.position.latitude, widget.position.longitude),
                zoom: 15.0),
            mapType: MapType.normal,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: card(
                            "Thời gian thuê",
                            StreamBuilder<Object>(
                                stream: widget._stopWatchTimer.rawTime,
                                initialData:
                                    widget._stopWatchTimer.rawTime.value,
                                builder: (context, snapshot) {
                                  final value = snapshot.data;
                                  final displayTime =
                                      StopWatchTimer.getDisplayTime(value,
                                          milliSecond: false);
                                  return Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(displayTime,
                                        style: simpleTextFieldStyle(
                                            Colors.black, 14.0)),
                                  );
                                }))),
                    Expanded(
                        child: card(
                            "Tiền phải trả",
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                "70.000 Đ",
                                style: simpleTextFieldStyle(
                                    Colors.black, 14.0),
                              ),
                            ))),
                    Expanded(
                        child: card(
                            "Pin còn lại",
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                "40%",
                                style: simpleTextFieldStyle(
                                    Colors.black, 14.0),
                              ),
                            ))),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          mapController
                              .animateCamera(CameraUpdate.zoomIn());
                        });
                      },
                      child: Container(
                        child: Icon(
                          Icons.zoom_in,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.blue),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          mapController
                              .animateCamera(CameraUpdate.zoomOut());
                        });
                      },
                      child: Container(
                        child: Icon(
                          Icons.zoom_out,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isReturnBike = true;
                    });
                    showBottomSheet();
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 40.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.blue),
                      child: ButtonTheme(
                          child: Text("Trả xe",
                              style: simpleTextFieldStyle(
                                  Colors.white, 17.0)))),
                ),
                FloatingActionButton(
                    child: Icon(Icons.my_location),
                    onPressed: () {
                      setState(() {
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                                target: LatLng(21.006111, 105.843056),
                                zoom: 15.0),
                          ),
                        );
                      });
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
  void showBottomSheet(){
    showModalBottomSheet(
      backgroundColor: const Color(0xFFEBE3E3),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc){
          return SizedBox(
            height: MediaQuery.of(context).size.height/2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Chọn bãi xe gần bạn để trả xe",style: especiallyTextFieldStyle(Colors.black, 18.0),),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listOfMarker.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<Object>(
                            stream: widget._stopWatchTimer.rawTime,
                            initialData: widget._stopWatchTimer.rawTime.value,
                            builder: (context, snapshot) {
                              final value = snapshot.data;
                              return Card(
                                elevation: 5.0,
                                child: ListTile(
                                  title: Text(listOfMarkerInfo[index]['title']),
                                  subtitle: Text(listOfMarkerInfo[index]['subtitle']),
                                  trailing: IconButton(
                                      tooltip: "Chỉ đường",
                                      icon: Icon(Icons.directions, color: Colors.blue),
                                      onPressed: () {
                                        String timeRentBike = StopWatchTimer.getDisplayTime(
                                            value,
                                            milliSecond: false);
                                        widget._stopWatchTimer.onExecute
                                            .add(StopWatchExecute.stop);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReturnBike(timeRentBike),
                                            ));
                                      },
                                      iconSize: 30.0),
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
