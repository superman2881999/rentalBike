import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../controller/rent_bike/bike_detail_controller.dart';
import '../../helper/widget.dart';
import '../../model/bike_model.dart';

const scaleFraction = 0.3;
const fullScale = 1;
const pagerHeight = 250.0;

class BikeDetail extends StatefulWidget {
  const BikeDetail({this.bikeModel, this.nameParking});
  final String nameParking;
  final BikeModel bikeModel;
  @override
  _BikeDetailState createState() => _BikeDetailState();
}

class _BikeDetailState extends State<BikeDetail> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: true,
  );

  final formKey = GlobalKey<FormState>();
  final codeBike = TextEditingController();

  double viewPortFraction = 0.5;
  PageController pageController = PageController();
  int currentPage = 2;
  double currentPageValue = 2;
  //get current location
  Position location;
  Future<void> getUserLocation() async {
    await Geolocator.getCurrentPosition().then((value) {
      location = value;
    });
  }
  //get current time
  DateTime now;
  DateFormat formatter;
  String time;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  BikeDetailController bikeDetailController = BikeDetailController();
  @override
  void initState() {
    pageController = PageController(
        initialPage: currentPage, viewportFraction: viewPortFraction);
    getUserLocation();
    flutterLocalNotificationsPlugin = Helper.initNotify();
    super.initState();
  }

  void onChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page;
      });
    });
    setState(() {
      now = DateTime.now();
      formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      time = formatter.format(now);
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:
          Helper.appBarMain(const Text("Thông tin chi tiết của xe"), context),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, left: 8),
                              child: Text("Danh sách màu xe",
                                  style: Helper.simpleTextFieldStyle(
                                      Colors.redAccent, 18, FontWeight.bold)),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: SizedBox(
                              height: pagerHeight,
                              child: PageView.builder(
                                scrollDirection: Axis.horizontal,
                                onPageChanged: onChanged,
                                physics: const BouncingScrollPhysics(),
                                controller: pageController,
                                itemCount: widget.bikeModel.urlImage.length,
                                itemBuilder: (context, index) {
                                  final scale = max(
                                      scaleFraction,
                                      (fullScale -
                                              (index - currentPageValue)
                                                  .abs()) +
                                          viewPortFraction);
                                  return circleOffer(
                                      widget.bikeModel
                                          .urlImage["urlImage${index + 1}"],
                                      scale);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List<Widget>.generate(
                                    widget.bikeModel.urlImage.length, (index) {
                                  return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      height: 10,
                                      width: (index == currentPage) ? 30 : 10,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 30),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: (index == currentPage)
                                              ? Colors.redAccent
                                              : Colors.red.withOpacity(0.5)));
                                })),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text("Chi tiết sản phẩm",
                              style: Helper.simpleTextFieldStyle(
                                  Colors.redAccent, 18, FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: widget.bikeModel.licensePlate ==
                                                null
                                            ? const Text("Biển số xe: Không có")
                                            : Text(
                                                // ignore: lines_longer_than_80_chars
                                                "Biển số xe: ${widget.bikeModel.licensePlate} ",
                                                style:
                                                    Helper.simpleTextFieldStyle(
                                                        Colors.black,
                                                        16,
                                                        FontWeight.normal))),
                                    Expanded(
                                        child: widget.bikeModel
                                                    .batteryCapacity ==
                                                null
                                            ? const Text(
                                                "Lượng pin hiện tại: Không có")
                                            : Text(
                                                // ignore: lines_longer_than_80_chars
                                                "Lượng pin hiện tại: ${widget.bikeModel.batteryCapacity}% ",
                                                style:
                                                    Helper.simpleTextFieldStyle(
                                                        Colors.black,
                                                        16,
                                                        FontWeight.normal)))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text("Mã xe: ${widget.bikeModel.codeBike} ",
                                    style: Helper.simpleTextFieldStyle(
                                        Colors.black, 16, FontWeight.normal)),
                                const SizedBox(height: 10),
                                Text(
                                    "Cách tính tiền "
                                    "(Hoàn lại tiền cọc khi trả xe): ",
                                    style: Helper.simpleTextFieldStyle(
                                        Colors.black, 16, FontWeight.bold)),
                                const SizedBox(height: 10),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border:
                                            Border.all(color: Colors.black54)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Nếu khách hàng dùng xe hơn "
                                              "10 phút thì tính tiền "
                                              "như sau: ",
                                              style:
                                                  Helper.simpleTextFieldStyle(
                                                      Colors.black,
                                                      16,
                                                      FontWeight.normal)),
                                          const SizedBox(height: 10),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                                "+ Giá khởi điểm cho 30 phút"
                                                " đầu là 10.000 đồng",
                                                style:
                                                    Helper.simpleTextFieldStyle(
                                                        Colors.black,
                                                        16,
                                                        FontWeight.normal)),
                                          ),
                                          const SizedBox(height: 10),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                                "+ Cứ mỗi 15 phút tiếp theo, "
                                                "khách sẽ phải trả thêm"
                                                " 3.000 đồng",
                                                style:
                                                    Helper.simpleTextFieldStyle(
                                                        Colors.black,
                                                        16,
                                                        FontWeight.normal)),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Tổng tiền phải cọc: ${widget.bikeModel.deposit} Đ",
                      style: Helper.simpleTextFieldStyle(
                          Colors.redAccent, 15, FontWeight.normal),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () async {
                      if (widget.bikeModel.state == "Sẵn Sàng") {
                        // Hàm xử lý Quá trình Thuê xe
                        // Trả về dialog để người dùng xác nhận thuê xe
                        bikeDetailController.getMoneyCard();
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Bạn muốn thuê xe này? Vui lòng "
                                    "nhập mã số xe tương ứng và tài khoản"
                                    " sẽ tự động bị trừ tiền cọc."
                                    " Mã xe:' ${widget.bikeModel.codeBike}' "),
                                content: Form(
                                  key: formKey,
                                  child: TextFormField(
                                    validator: Helper.validatorCodeBike,
                                    decoration: const InputDecoration(
                                        hintText: "Nhập mã số xe...",
                                        labelText: "Mã xe:"),
                                    autofocus: true,
                                    controller: codeBike,
                                  ),
                                ),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Huỷ")),
                                  FlatButton(
                                      onPressed: () {
                                        bikeDetailController.handleRentBike(
                                            stopWatchTimer: _stopWatchTimer,
                                            flutterLocalNotificationsPlugin:
                                                flutterLocalNotificationsPlugin,
                                            bikeModel: widget.bikeModel,
                                            context: context,
                                            time: time,
                                            nameParking: widget.nameParking,
                                            codeBike: codeBike,
                                            location: location,
                                            pr: pr);
                                      },
                                      child: const Text("Thuê ngay"))
                                ],
                              );
                            });
                      } else if (widget.bikeModel.state == "Chưa Sẵn Sàng") {
                        await Helper.alertDialogNotiStateBike(
                            context,
                            // ignore: lines_longer_than_80_chars
                            "Xe này đã được thuê, quý khách vui lòng chọn xe khác.");
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: MediaQuery.of(context).size.width / 6),
                      alignment: Alignment.bottomRight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Color(0xFFEF9A9A),
                                Color(0xFFEF5350),
                              ])),
                      child: Text(
                        "Thuê xe",
                        style: Helper.simpleTextFieldStyle(
                            Colors.white, 15, FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget circleOffer(String image, double scale) {
    final card = Card(
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      child: Image.network(image,
          fit: BoxFit.fill, width: MediaQuery.of(context).size.width),
    );
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: pagerHeight * scale,
        width: pagerHeight * scale,
        child: card,
      ),
    );
  }
}
