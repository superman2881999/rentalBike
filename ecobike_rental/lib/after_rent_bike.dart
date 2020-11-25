import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:intl/intl.dart';

import 'Model/bike_model.dart';
import 'drawer.dart';
import 'return_bike.dart';
import 'service/database.dart';
import 'widget.dart';

class RentBike extends StatefulWidget {
  const RentBike(this._stopWatchTimer, this.location, this.bikeModel,
      this.flutterLocalNotificationsPlugin);
  final StopWatchTimer _stopWatchTimer;
  final Position location;
  final BikeModel bikeModel;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
  int paymentMoney = 0;

  //get current time
  DateTime now;
  DateFormat formatter;
  String time;

  @override
  void initState() {
    markers = <Marker>{};
    listOfMarker = [
      {'latLng': const LatLng(21.006111, 105.843056)},
      {'latLng': const LatLng(21.006111, 105.853056)},
      {'latLng': const LatLng(21.006111, 105.863056)},
    ];
    listOfMarkerInfo = [
      {'marker': "1", 'title': "Bãi số 1", 'subtitle': "Cách bạn 1 km"},
      {'marker': "2", 'title': "Bãi số 2", 'subtitle': "Cách bạn 2 km"},
      {'marker': "3", 'title': "Bãi số 3", 'subtitle': "Cách bạn 3 km"},
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget._stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (isReturnBike) {
        for (var i = 0; i < listOfMarker.length; i++) {
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
      appBar: appBarMain(const Text("Đang thuê xe"), context),
      drawer: Draw(),
      body: Stack(
        children: [
          GoogleMap(
            markers: markers,
            myLocationEnabled: true,
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
                // ignore: cascade_invocations
                mapController.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                  target: LatLng(
                      widget.location.latitude, widget.location.longitude),
                  zoom: 17,
                )));
              });
            },
            initialCameraPosition: CameraPosition(
                target:
                    LatLng(widget.location.latitude, widget.location.longitude),
                zoom: 15),
            mapType: MapType.normal,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
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
                                    padding: const EdgeInsets.all(6),
                                    child: Text(displayTime,
                                        style: simpleTextFieldStyle(
                                            Colors.black, 14)),
                                  );
                                }))),
                    Expanded(
                        child: card(
                            "Tiền phải trả",
                            StreamBuilder<Object>(
                                stream: widget._stopWatchTimer.secondTime,
                                initialData:
                                    widget._stopWatchTimer.secondTime.value,
                                builder: (context, snapshot) {
                                  final int minuteTime = snapshot.data;
                                  if (minuteTime > 10) {
                                    if (minuteTime >= 40) {
                                      // ignore: unnecessary_parenthesis
                                      paymentMoney = (10000 +
                                              ((minuteTime - 40) / 15 + 1) *
                                                  3000)
                                          .round();
                                    } else {
                                      paymentMoney = 10000;
                                    }
                                  } else {
                                    paymentMoney = 0;
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text(
                                      "$paymentMoney Đ",
                                      style: simpleTextFieldStyle(
                                          Colors.black, 14),
                                    ),
                                  );
                                }))),
                    Expanded(
                        child: card(
                            "Pin còn lại",
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: widget.bikeModel.batteryCapacity == null
                                  ? Text(
                                      "Không có",
                                      style: simpleTextFieldStyle(
                                          Colors.black, 14),
                                    )
                                  : Text(
                                      "${widget.bikeModel.batteryCapacity}%",
                                      style: simpleTextFieldStyle(
                                          Colors.black, 14),
                                    ),
                            ))),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
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
                          mapController.animateCamera(CameraUpdate.zoomIn());
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.redAccent),
                        child: const Icon(
                          Icons.zoom_in,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          mapController.animateCamera(CameraUpdate.zoomOut());
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.redAccent),
                        child: const Icon(
                          Icons.zoom_out,
                          color: Colors.white,
                        ),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 40),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.redAccent),
                      child: ButtonTheme(
                          child: Text("Trả xe",
                              style: simpleTextFieldStyle(Colors.white, 17)))),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  onPressed: () {
                    setState(() {
                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                              target: LatLng(widget.location.latitude,
                                  widget.location.longitude),
                              zoom: 15),
                        ),
                      );
                    });
                  },
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
        backgroundColor: const Color(0xFFEBE3E3),
        isScrollControlled: true,
        context: context,
        builder: (buildcontext) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Chọn bãi xe gần bạn để trả xe",
                      style: especiallyTextFieldStyle(Colors.black, 18),
                    ),
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
                                elevation: 5,
                                child: ListTile(
                                  title: Text(listOfMarkerInfo[index]['title']),
                                  subtitle:
                                      Text(listOfMarkerInfo[index]['subtitle']),
                                  trailing: IconButton(
                                      tooltip: "Chỉ đường",
                                      icon: const Icon(Icons.directions,
                                          color: Colors.redAccent),
                                      onPressed: () {
                                        final timeRentBike =
                                            StopWatchTimer.getDisplayTime(value,
                                                milliSecond: false);
                                        //get current time to uploadNoti
                                        now = DateTime.now();
                                        formatter =
                                            DateFormat('yyyy-MM-dd HH:mm:ss');
                                        time = formatter.format(now);
                                        //
                                        widget._stopWatchTimer.onExecute
                                            .add(StopWatchExecute.stop);
                                        _showNotificationWithDefaultSound(
                                            // ignore: lines_longer_than_80_chars
                                            widget.flutterLocalNotificationsPlugin,
                                            // ignore: lines_longer_than_80_chars
                                            "Trả ${widget.bikeModel.typeBike} thành công",
                                            // ignore: lines_longer_than_80_chars
                                            "Tên bãi xe: ${listOfMarkerInfo[index]['title']} - Mã xe: ${widget.bikeModel.codeBike}");
                                        DatabaseService.updateStateReturnBike(
                                            widget.bikeModel.bikeId);
                                        DatabaseService.uploadNotiReturnBike(
                                            bikeId: widget.bikeModel.bikeId,
                                            parkingId:
                                                widget.bikeModel.parkingId,
                                            codeBike: widget.bikeModel.codeBike,
                                            typeBike: widget.bikeModel.typeBike,
                                            nameParking: listOfMarkerInfo[index]
                                                ['title'],
                                            time: time);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReturnBike(
                                                  timeRentBike,
                                                  widget.bikeModel,
                                                  paymentMoney),
                                            ));
                                      },
                                      iconSize: 30),
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
        });
  }
}

Future _showNotificationWithDefaultSound(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String nameNotification,
    String description) async {
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High);
  const iOSPlatformChannelSpecifics = IOSNotificationDetails();
  const platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    nameNotification,
    description,
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );
}
