import 'package:flutter/material.dart';

import '../IntroApp/splash_screen.dart';
import '../Model/bike_model.dart';
import '../Service/database.dart';
import '../Service/widget.dart';

///Trả về 1 instance của _SliderDoubleBikeState
class SliderDoubleBike extends StatefulWidget {
  //Constructor nhận đầu vào là id bãi xe và tên bãi xe
  const SliderDoubleBike({Key key, this.parkingId, this.nameParking})
      : super(key: key);
  final String nameParking;
  final int parkingId;
  //Trả về 1 instance của _SliderDoubleBikeState
  @override
  _SliderDoubleBikeState createState() => _SliderDoubleBikeState();
}

///Trả về giao diện list các xe đạp đôi có id bãi xe và tên bãi xe như trên
class _SliderDoubleBikeState extends State<SliderDoubleBike> {
  //Khởi tạo biến chứa danh sách các xe đạp đôi
  List<BikeModel> listDoubleBike = SplashScreen.listDoubleBike;
  //Khai báo biến chứa danh sách xe đạp đôi theo id bãi xe
  List<BikeModel> listDoubleBikeById = [];
  //Hàm khởi tạo sẽ được chạy khi class được gọi đến
  @override
  void initState() {
    // Lấy ra danh sách xe và add vào List listDoubleBikeById ở trên từ server
    DatabaseService.getListBike().then((value) {
      SplashScreen.listDoubleBike.clear();
      value.once().then((snapshot) {
        final Map<dynamic, dynamic> values = snapshot.value;
        // ignore: cascade_invocations
        values.forEach((key, values) {
          if (values["typeBike"] == "Xe Đạp Đôi") {
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
    // Lọc ra những xe có id trùng với id của bãi xe
    for (var i = 0; i < listDoubleBike.length; i++) {
      if (listDoubleBike[i].parkingId == widget.parkingId) {
        listDoubleBikeById.add(listDoubleBike[i]);
      }
    }
    super.initState();
  }
  //Hiển thị danh sách xe đạp đôi cho người dùng tương tác
  @override
  Widget build(BuildContext context) {
    return Service.listBike(listDoubleBikeById, widget.nameParking);
  }
}
