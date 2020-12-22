import 'package:flutter/material.dart';

import '../IntroApp/splash_screen.dart';
import '../Model/bike_model.dart';
import '../Service/widget.dart';
import '../service/database.dart';

///Trả về 1 instance của _SliderElectricBikeState
class SliderElectricBike extends StatefulWidget {
  //Constructor nhận đầu vào là id bãi xe và tên bãi xe
  const SliderElectricBike({Key key, this.parkingId, this.nameParking})
      : super(key: key);
  final String nameParking;
  final int parkingId;
  //Trả về 1 instance của _SliderElectricBikeState
  @override
  _SliderElectricBikeState createState() => _SliderElectricBikeState();
}

///Trả về giao diện list các xe đạp điện có id bãi xe và tên bãi xe như trên
class _SliderElectricBikeState extends State<SliderElectricBike> {
  //Khởi tạo biến chứa danh sách các xe đạp điện
  List<BikeModel> listElectricBike = SplashScreen.listElectricBike;
  //Khai báo biến chứa danh sách xe đạp điện theo id bãi xe
  List<BikeModel> listElectricBikeById = [];
  //Hàm khởi tạo sẽ được chạy khi class được gọi đến
  @override
  void initState() {
    // Lấy ra danh sách xe và add vào List listElectricBikeById ở trên từ server
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
    // Lọc ra những xe có id trùng với id của bãi xe
    for (var i = 0; i < listElectricBike.length; i++) {
      if (listElectricBike[i].parkingId == widget.parkingId) {
        listElectricBikeById.add(listElectricBike[i]);
      }
    }
    super.initState();
  }
  //Hiển thị danh sách xe đạp điện cho người dùng tương tác
  @override
  Widget build(BuildContext context) {
    return Service.listBike(listElectricBikeById,widget.nameParking);
  }
}
