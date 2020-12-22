import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../IntroApp/splash_screen.dart';
import '../Model/bike_model.dart';
import '../ReturnBike/return_bike.dart';
import '../Service/drawer.dart';
import '../Service/widget.dart';
import '../service/database.dart';
import 'calculator_money.dart';

///Lớp quản lý sau khi thuê xe, trả về 1 instance _RentBikeState
class RentBike extends StatefulWidget {
  // Constructor nhận biến quản lý thời gian,
  // vị trí người dùng, thông tin xe thuê, và thông báo.
  const RentBike(this._stopWatchTimer, this.location, this.bikeModel,
      this.flutterLocalNotificationsPlugin);
  // Khai báo biến quản lý thời gian
  final StopWatchTimer _stopWatchTimer;
  // Khai báo biến lưu trữ vị trí
  final Position location;
  // Khai báo biến lưu trữ thông tin xe thuê
  final BikeModel bikeModel;
  // Khai báo biến quản lý push thông báo local
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  _RentBikeState createState() => _RentBikeState();
}

///Trả về giao diện bản đồ và thông tin xe thuê
class _RentBikeState extends State<RentBike> {
  //google map
  GoogleMapController mapController;
  Set<Marker> markers;
  Marker marker;
  //List chứa các điểm bãi xe
  List<Map<String, LatLng>> listOfMarker;
  // List chứa thông tin của từng bãi xe
  List<Map<String, String>> listOfMarkerInfo;

  //Biến để xử lý hiện ra danh sách bãi trả xe
  bool isReturnBike = false;
  //Biến cập nhật tiền phải trả
  int paymentMoney = 0;

  //call native code java from flutter
  static const platform = MethodChannel("Transaction");

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
      appBar: Service.appBarMain(const Text("Đang thuê xe"), context),
      drawer: Draw(),
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
                        child: Service.card(
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
                                        style: Service.simpleTextFieldStyle(
                                            Colors.black,
                                            14,
                                            FontWeight.normal)),
                                  );
                                }))),
                    Expanded(
                        //Card hiển thị tiền phải trả xe
                        child: Service.card(
                            "Tiền phải trả",
                            StreamBuilder<Object>(
                                stream: widget._stopWatchTimer.minuteTime,
                                initialData:
                                    widget._stopWatchTimer.minuteTime.value,
                                builder: (context, snapshot) {
                                  final int minuteTime = snapshot.data;
                                  paymentMoney =
                                      CalculatorMoney.calculatorMoney(
                                          minuteTime);
                                  return Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text(
                                      "$paymentMoney đ",
                                      style: Service.simpleTextFieldStyle(
                                          Colors.black, 14, FontWeight.normal),
                                    ),
                                  );
                                }))),
                    Expanded(
                        //Card hiện số pin còn lại của xe
                        child: Service.card(
                            "Pin còn lại",
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: widget.bikeModel.batteryCapacity == null
                                  ? Text(
                                      "Không có",
                                      style: Service.simpleTextFieldStyle(
                                          Colors.black, 14, FontWeight.normal),
                                    )
                                  : Text(
                                      "${widget.bikeModel.batteryCapacity}%",
                                      style: Service.simpleTextFieldStyle(
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
                              style: Service.simpleTextFieldStyle(
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
        builder: (buildcontext) {
          progressDialog = ProgressDialog(buildcontext,
              type: ProgressDialogType.Normal, isDismissible: false);
          var percentage = 0;
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
                      style: Service.simpleTextFieldStyle(
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
                                            .then((onvalue) async {
                                          percentage = percentage + 30;
                                          // lấy errorCode sau khi trả xe
                                          await transaction(paymentMoney,
                                                  widget.bikeModel.typeBike)
                                              .then((res) async {
                                            progressDialog.update(
                                              progress: percentage.toDouble(),
                                              message: "Vui lòng đợi...",
                                            );
                                            //Trường hợp trả xe thành công
                                            if (res == "00") {
                                              // Lấy thời gian thuê xe
                                              final timeRentBike =
                                                  StopWatchTimer.getDisplayTime(
                                                      value,
                                                      milliSecond: false);
                                              widget._stopWatchTimer.onExecute
                                                  .add(StopWatchExecute.stop);
                                              // ignore: lines_longer_than_80_chars
                                              //Hiện thông báo local trả xe báo thành công
                                              // ignore: lines_longer_than_80_chars
                                              await _showNotificationWithDefaultSound(
                                                  widget
                                                      // ignore: lines_longer_than_80_chars
                                                      .flutterLocalNotificationsPlugin,
                                                  // ignore: lines_longer_than_80_chars
                                                  "Trả ${widget.bikeModel.typeBike} thành công",
                                                  // ignore: lines_longer_than_80_chars
                                                  "Tên bãi xe: ${listOfMarkerInfo[index]['title']} - Mã xe: ${widget.bikeModel.codeBike}");
                                              //update lại state sẵn sàng của xe
                                              await DatabaseService
                                                  .updateStateActionBike(
                                                      widget.bikeModel.bikeId,
                                                      "Sẵn Sàng");
                                              //Lưu thông báo trả xe thành công
                                              await DatabaseService
                                                  .uploadNotiActionBike(
                                                      bikeId: widget
                                                          .bikeModel.bikeId,
                                                      parkingId: widget
                                                          .bikeModel.parkingId,
                                                      codeBike: widget
                                                          .bikeModel.codeBike,
                                                      typeBike: widget
                                                          .bikeModel.typeBike,
                                                      nameParking:
                                                          listOfMarkerInfo[
                                                              index]['title'],
                                                      time:
                                                          Service.formatDate(),
                                                      action: "Trả");
                                              //Ẩn progress khi đã xử lý hết
                                              await progressDialog.hide();
                                              //Chuyển sang màn hình trả xe
                                              await Navigator
                                                  .pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ReturnBike(
                                                                timeRentBike,
                                                                widget
                                                                    .bikeModel,
                                                                paymentMoney),
                                                      ),
                                                      (route) => false);
                                              //Trường hợp người dùng gian lận
                                            } else if (res == "04") {
                                              await progressDialog.hide();
                                              // ignore: lines_longer_than_80_chars
                                              await Service.alertDialogNotiStateBike(
                                                  context,
                                                  // ignore: lines_longer_than_80_chars
                                                  'Giao dịch bị nghi ngờ gian lận');
                                              //Trường hợp không đủ thông tin
                                            } else if (res == "05") {
                                              await progressDialog.hide();
                                              // ignore: lines_longer_than_80_chars
                                              await Service.alertDialogNotiStateBike(
                                                  context,
                                                  // ignore: lines_longer_than_80_chars
                                                  'Không đủ thông tin giao dịch');
                                              //Trường hợp thẻ không đủ tiền
                                            } else if (res == "02") {
                                              await progressDialog.hide();
                                              // ignore: lines_longer_than_80_chars
                                              await Service
                                                  .alertDialogNotiStateBike(
                                                      context,
                                                      // ignore: lines_longer_than_80_chars
                                                      'Thẻ không đủ số dư');
                                            }
                                          });
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

  // Hàm call api, trả về errorCode
  Future<String> transaction(int amount, String typeBike) async {
    String value;
    try {
      //Hỗ trợ call sang java
      value = await platform.invokeMethod('Transaction', {
        "command": "pay",
        "cardCode": "118609_group5_2020",
        "owner": "Group 5",
        "cvvCode": "271",
        "dateExpired": "1125",
        "transactionContent": "Thanh toán trả $typeBike",
        "amount": amount,
        "createdAt": Service.formatDate(),
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return value;
  }
}

// Hàm trả về thông báo cho người dùng
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
