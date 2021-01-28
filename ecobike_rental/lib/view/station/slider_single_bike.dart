import 'package:flutter/material.dart';

import '../../controller/station/slider_bike_controller.dart';
import '../../helper/widget.dart';
import '../../model/bike_model.dart';
import '../intro_app/splash_screen.dart';

///Trả về 1 instance của _SliderBikeState
class SliderBike extends StatefulWidget {
  //Constructor nhận đầu vào là id bãi xe và tên bãi xe
  const SliderBike({Key key, this.parkingId, this.nameParking, this.typeBike})
      : super(key: key);
  final String nameParking;
  final String typeBike;
  final int parkingId;
  //Trả về 1 instance của _SliderBikeState
  @override
  _SliderBikeState createState() => _SliderBikeState();
}

///Trả về giao diện list các xe loại xe đạp có id bãi xe và tên bãi xe như trên
class _SliderBikeState extends State<SliderBike> {
  //Khởi tạo biến chứa danh sách các xe đạp
  List<BikeModel> listSingleBike;
  //Khai báo biến chứa danh sách xe đạp theo id bãi xe
  List<BikeModel> listSingleBikeById = [];

  SliderBikeController sliderBikeController = SliderBikeController();
  //Hàm khởi tạo sẽ được chạy khi class được gọi đến
  @override
  void initState() {
    setState((){
      listSingleBike = SplashScreen.listSingleBike;
      // Lấy ra danh sách xe và add vào List listSingleBikeById ở trên từ server
      sliderBikeController.getBike(
          parkingId: widget.parkingId,
          typeBike: widget.typeBike,
          listBike: listSingleBike,
          listBikeById: listSingleBikeById);
    });
    super.initState();
  }

  //Hiển thị danh sách xe đạp cho người dùng tương tác
  @override
  Widget build(BuildContext context) {
    return Helper.listBike(listSingleBikeById, widget.nameParking);
  }
}
