import 'package:flutter/material.dart';

import '../../controller/station/slider_bike_controller.dart';
import '../../helper/widget.dart';
import '../../model/bike_model.dart';
import '../intro_app/splash_screen.dart';

///Trả về 1 instance của _SliderElectricBikeState
class SliderElectricBike extends StatefulWidget {
  //Constructor nhận đầu vào là id bãi xe và tên bãi xe
  const SliderElectricBike(
      {Key key, this.parkingId, this.nameParking, this.typeBike})
      : super(key: key);
  final String nameParking;
  final String typeBike;
  final int parkingId;
  //Trả về 1 instance của _SliderElectricBikeState
  @override
  _SliderElectricBikeState createState() => _SliderElectricBikeState();
}

///Trả về giao diện list các xe đạp điện có id bãi xe và tên bãi xe như trên
class _SliderElectricBikeState extends State<SliderElectricBike> {
  //Khởi tạo biến chứa danh sách các xe đạp điện
  List<BikeModel> listElectricBike;
  //Khai báo biến chứa danh sách xe đạp điện theo id bãi xe
  List<BikeModel> listElectricBikeById = [];

  SliderBikeController sliderBikeController = SliderBikeController();
  //Hàm khởi tạo sẽ được chạy khi class được gọi đến
  @override
  void initState() {
    setState(() {
      listElectricBike = SplashScreen.listElectricBike;
      // Lấy ra danh sách xe và add vào List listElectricBikeById ở trên
      sliderBikeController.getBike(
          parkingId: widget.parkingId,
          typeBike: widget.typeBike,
          listBike: listElectricBike,
          listBikeById: listElectricBikeById);
    });

    super.initState();
  }

  //Hiển thị danh sách xe đạp điện cho người dùng tương tác
  @override
  Widget build(BuildContext context) {
    return Helper.listBike(listElectricBikeById, widget.nameParking);
  }
}
