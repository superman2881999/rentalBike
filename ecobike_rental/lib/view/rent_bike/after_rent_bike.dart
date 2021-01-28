import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../controller/rent_bike/rent_bike_controller.dart';
import '../../helper/drawer.dart';
import '../../helper/widget.dart';
import '../../model/bike_model.dart';
import '../intro_app/splash_screen.dart';

///Lớp quản lý sau khi thuê xe, trả về 1 instance _RentBikeState
class RentBike extends StatefulWidget {
  // Constructor nhận biến quản lý thời gian,
  // vị trí người dùng, thông tin xe thuê, và thông báo.
  const RentBike(this.dateRentBike, this._stopWatchTimer, this.location,
      this.bikeModel, this.flutterLocalNotificationsPlugin);
  // Khai báo biến quản lý thời gian
  final StopWatchTimer _stopWatchTimer;
  // Khai báo biến lưu trữ vị trí
  final Position location;
  // Khai báo biến lưu trữ thông tin xe thuê
  final BikeModel bikeModel;
  // Khai báo biến quản lý push thông báo local
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  //thời gian bắt đầu thuê
  final String dateRentBike;

  @override
  _RentBikeState createState() => _RentBikeState();
}

///Trả về giao diện bản đồ và thông tin xe thuê
class _RentBikeState extends State<RentBike> {
  //google map
  GoogleMapController mapController;
  Set<Marker> markers;
  //List chứa các điểm bãi xe
  List<Map<String, LatLng>> listOfMarker;
  // List chứa thông tin của từng bãi xe
  List<Map<String, String>> listOfMarkerInfo;

  //Biến để xử lý hiện ra danh sách bãi trả xe
  bool isReturnBike = false;
  //Biến cập nhật tiền phải trả
  int paymentMoney = 0;

  RentBikeController rentBikeController = RentBikeController();

  //progress
  ProgressDialog progressDialog;
  //Khởi tạo màn hình
  @override
  void initState() {
    //Khởi tạo các điểm bãi gửi xe
    markers = <Marker>{};
    listOfMarker = [
      {
        'latLng': LatLng(SplashScreen.currentLocation.latitude + 0.001,
            SplashScreen.currentLocation.longitude)
      },
      {
        'latLng': LatLng(SplashScreen.currentLocation.latitude,
            SplashScreen.currentLocation.longitude + 0.001)
      },
      {
        'latLng': LatLng(SplashScreen.currentLocation.latitude - 0.001,
            SplashScreen.currentLocation.longitude)
      },
    ];
    listOfMarkerInfo = [
      {'marker': "1", 'title': "Bãi số 1", 'subtitle': "Cách bạn 3 km"},
      {'marker': "2", 'title': "Bãi số 2", 'subtitle': "Cách bạn 2 km"},
      {'marker': "3", 'title': "Bãi số 3", 'subtitle': "Cách bạn 1 km"},
    ];
    super.initState();
  }

  //xóa widget _stopWatchTimer sau khi sử dụng xong
  @override
  void dispose() {
    super.dispose();
    widget._stopWatchTimer.dispose();
  }

  //Trả về màn hình thuê xe
  @override
  Widget build(BuildContext context) {
    setState(() {
      //Xử lý danh sách điểm trả
      rentBikeController.handleListMarkers(
          isReturnBike: isReturnBike,
          listOfMarker: listOfMarker,
          listOfMarkerInfo: listOfMarkerInfo,
          markers: markers);
    });
    return Scaffold(
      appBar: Helper.appBarMain(const Text("Đang thuê xe"), context),
      drawer: const Draw(check: false),
      body: Stack(
        children: [
          //Tạo widget bản đồ để hiển thị cho người dùng xem vị trí của mình
          GoogleMap(
            markers: markers,
            myLocationEnabled: true,
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
                // ignore: cascade_invocations
                mapController.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                  target: LatLng(SplashScreen.currentLocation.latitude,
                      SplashScreen.currentLocation.longitude),
                  zoom: 17,
                )));
              });
            },
            initialCameraPosition: CameraPosition(
                target: LatLng(SplashScreen.currentLocation.latitude,
                    SplashScreen.currentLocation.longitude),
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
                        //Card hiển thị thời gian thuê
                        child: Helper.card(
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
                                        style: Helper.simpleTextFieldStyle(
                                            Colors.black,
                                            14,
                                            FontWeight.normal)),
                                  );
                                }))),
                    Expanded(
                        //Card hiển thị tiền phải trả xe
                        child: Helper.card(
                            "Tiền phải trả",
                            StreamBuilder<Object>(
                                stream: widget._stopWatchTimer.secondTime,
                                initialData:
                                    widget._stopWatchTimer.secondTime.value,
                                builder: (context, snapshot) {
                                  final int minuteTime = snapshot.data;
                                  paymentMoney =
                                      widget.bikeModel.calculatorMoney(
                                          minuteTime,widget.bikeModel.typeBike);
                                  return Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text(
                                      "$paymentMoney đ",
                                      style: Helper.simpleTextFieldStyle(
                                          Colors.black, 14, FontWeight.normal),
                                    ),
                                  );
                                }))),
                    Expanded(
                        //Card hiện số pin còn lại của xe
                        child: Helper.card(
                            "Pin còn lại",
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: widget.bikeModel.batteryCapacity == null
                                  ? Text(
                                      "Không có",
                                      style: Helper.simpleTextFieldStyle(
                                          Colors.black, 14, FontWeight.normal),
                                    )
                                  : Text(
                                      "${widget.bikeModel.batteryCapacity}%",
                                      style: Helper.simpleTextFieldStyle(
                                          Colors.black, 14, FontWeight.normal),
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
                        //Zoom nhỏ bản đồ
                        mapController.animateCamera(CameraUpdate.zoomIn());
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
                        //Zoom to bản đồ
                        mapController.animateCamera(CameraUpdate.zoomOut());
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
                    //show danh sách bãi xe gần đấy khi người dùng bấm trả xe
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
                              style: Helper.simpleTextFieldStyle(
                                  Colors.white, 17, FontWeight.normal)))),
                ),
                //Widget này giúp người dùng quay về vị trí của mình trên bản đồ
                FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  onPressed: () {
                    setState(() {
                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                              target: LatLng(
                                  SplashScreen.currentLocation.latitude,
                                  SplashScreen.currentLocation.longitude),
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

  //Trả về widget chứa danh sách bãi xe gần người dùng
  void showBottomSheet() {
    showModalBottomSheet(
        backgroundColor: const Color(0xFFEBE3E3),
        isScrollControlled: true,
        context: context,
        builder: (buildContext) {
          progressDialog = ProgressDialog(buildContext,
              type: ProgressDialogType.Normal, isDismissible: false);
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
                      style: Helper.simpleTextFieldStyle(
                          Colors.black, 18, FontWeight.normal),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listOfMarker.length,
                      itemBuilder: (context, index) {
                        //Dùng widget StreamBuilder để cập nhật thời gian thuê
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
                                      onPressed: () async {
                                        //Hiện progressDialog để đợi xử lý
                                        await progressDialog.show();
                                        await Future.delayed(
                                                const Duration(seconds: 5))
                                            .then((_) async {
                                          await rentBikeController
                                              .handleTransaction(
                                                  dateRentBike:
                                                      widget.dateRentBike,
                                                  amount: paymentMoney,
                                                  progressDialog:
                                                      progressDialog,
                                                  context: context,
                                                  nameParking:
                                                      listOfMarkerInfo[index]
                                                          ['title'],
                                                  stopWatchTimer:
                                                      widget._stopWatchTimer,
                                                  // ignore: lines_longer_than_80_chars
                                                  flutterLocalNotificationsPlugin: widget
                                                      // ignore: lines_longer_than_80_chars
                                                      .flutterLocalNotificationsPlugin,
                                                  bikeModel: widget.bikeModel,
                                                  result: value);
                                        });
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
