import 'package:flutter/material.dart';

import '../IntroApp/splash_screen.dart';
import '../Model/bike_model.dart';
import '../Service/widget.dart';
import '../service/database.dart';

///Trả về 1 instance của _SliderBikeState
class SliderBike extends StatefulWidget {
  //Constructor nhận đầu vào là id bãi xe và tên bãi xe
  const SliderBike({Key key, this.parkingId, this.nameParking})
      : super(key: key);
  final String nameParking;
  final int parkingId;
  //Trả về 1 instance của _SliderBikeState
  @override
  _SliderBikeState createState() => _SliderBikeState();
}

///Trả về giao diện list các xe loại xe đạp có id bãi xe và tên bãi xe như trên
class _SliderBikeState extends State<SliderBike> {
  //Khởi tạo biến chứa danh sách các xe đạp
  List<BikeModel> listSingleBike = SplashScreen.listSingleBike;
  //Khai báo biến chứa danh sách xe đạp theo id bãi xe
  List<BikeModel> listSingleBikeById = [];
  //Hàm khởi tạo sẽ được chạy khi class được gọi đến
  @override
  void initState() {
    // Lấy ra danh sách xe và add vào List listSingleBikeById ở trên từ server
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
    // Lọc ra những xe có id trùng với id của bãi xe
    for (var i = 0; i < listSingleBike.length; i++) {
      if (listSingleBike[i].parkingId == widget.parkingId) {
        listSingleBikeById.add(listSingleBike[i]);
      }
    }
    super.initState();
  }

  //Hiển thị danh sách xe đạp cho người dùng tương tác
  @override
  Widget build(BuildContext context) {
    return Service.listBike(listSingleBikeById, widget.nameParking);
  }
}
