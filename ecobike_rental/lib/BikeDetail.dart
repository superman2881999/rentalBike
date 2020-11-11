import 'dart:math';
import 'package:EcobikeRental/widget.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'DotsIndicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

const SCALE_FRACTION = 0.3;
const FULL_SCALE = 1;
const PAGER_HEIGHT = 250.0;

class BikeDetail extends StatefulWidget {
  @override
  _BikeDetailState createState() => _BikeDetailState();
}

class _BikeDetailState extends State<BikeDetail> {

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: true,
  );

  double viewPortFraction = 0.5;
  PageController pageController = new PageController();
  int currentPage = 2;
  List<Map<String, String>> listOfCharacters = [
    {'image': "images/bikesonsuBlack.png", 'name': "Black"},
    {'image': "images/bikesonsuBlue.png",'name': "Blue"},
    {'image': "images/bikesonsuRed.png", 'name': "Red"},
  ];
  double currentPageValue  = 2.0;

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  Position currentLocation;

  @override
  void initState() {
    pageController =
        PageController(initialPage: currentPage, viewportFraction: viewPortFraction);
    getUserLocation();
    super.initState();
  }
  Future<LatLng> getUserLocation() async {
    Geolocator.getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page;
      });
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBarMain(Text("Thông tin chi tiết của xe"),context),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height/2,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment:CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0,left:8.0),
                              child: Text("Danh sách màu xe",style: especiallyTextFieldStyle(Colors.redAccent, 18.0)),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: SizedBox(
                              height: PAGER_HEIGHT,
                              child: PageView.builder(
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (pos) {
                                  setState(() {
                                    currentPage = pos;
                                  });
                                },
                                physics: BouncingScrollPhysics(),
                                controller: pageController,
                                itemCount: listOfCharacters.length,
                                itemBuilder: (context, index) {
                                  final scale =
                                  max(SCALE_FRACTION, (FULL_SCALE - (index - currentPageValue).abs()) + viewPortFraction);
                                  return circleOffer(
                                      listOfCharacters[index]['image'], scale);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: DotsIndicator(
                              controller: pageController,
                              itemCount: listOfCharacters.length,
                              onPageSelected: (int page) {
                                pageController.animateToPage(
                                  page,
                                  duration: _kDuration,
                                  curve: _kCurve,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("Chi tiết sản phẩm",style: especiallyTextFieldStyle(Colors.redAccent, 18.0)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text("Biển số xe: 29D2-13671 ",style: simpleTextFieldStyle(Colors.black, 16.0))),
                                    Expanded(child: Text("Lượng pin hiện tại: 40% ",style: simpleTextFieldStyle(Colors.black, 16.0)))
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text("Mã xe: 2354 95485 4066 54 ",style: simpleTextFieldStyle(Colors.black, 16.0)),
                                SizedBox(height: 10),
                                Text("Cách tính tiền (Hoàn lại tiền cọc khi trả xe): ",style: especiallyTextFieldStyle(Colors.black, 16.0)),
                                SizedBox(height: 10),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        border: Border.all(color: Colors.black54)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Nếu khách hàng dùng xe hơn 10 phút thì tính tiền như sau: ",style: simpleTextFieldStyle(Colors.black, 16.0)),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text("+ Giá khởi điểm cho 30 phút đầu là 10.000 đồng",style: simpleTextFieldStyle(Colors.black, 16.0)),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text("+ Cứ mỗi 15 phút tiếp theo, khách sẽ phải trả thêm 3.000 đồng",style: simpleTextFieldStyle(Colors.black, 16.0)),
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
                    padding: const EdgeInsets.only(left:10.0),
                    child: Text("Tổng tiền phải cọc: 300.000 Đ",style: simpleTextFieldStyle(Colors.redAccent,15.0),),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      alertDialogRentBike(context,_stopWatchTimer,currentLocation);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: MediaQuery.of(context).size.width/6),
                      alignment: Alignment.bottomRight,
                      child: Text("Thuê xe",style: simpleTextFieldStyle(Colors.white, 15.0),),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                const Color(0xFFEF9A9A),
                                const Color(0xFFEF5350),
                              ])),
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
    final Card card = Card(
      elevation: 10.0,
      clipBehavior: Clip.antiAlias,
      child: Image.asset(image,fit: BoxFit.fill,width: MediaQuery.of(context).size.width),
    );
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: PAGER_HEIGHT * scale,
        width: PAGER_HEIGHT * scale,
        child: card,
      ),
    );
  }
}


