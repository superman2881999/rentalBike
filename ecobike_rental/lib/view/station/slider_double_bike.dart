import 'package:flutter/material.dart';

import '../../controller/station/slider_bike_controller.dart';
import '../../helper/widget.dart';
import '../../model/bike_model.dart';
import '../intro_app/splash_screen.dart';


///Trả về 1 instance của _SliderDoubleBikeState
class SliderDoubleBike extends StatefulWidget {
  //Constructor nhận đầu vào là id bãi xe và tên bãi xe
  const SliderDoubleBike(
      {Key key, this.parkingId, this.nameParking, this.typeBike})
      : super(key: key);
  final String nameParking;
  final int parkingId;
  final String typeBike;
  //Trả về 1 instance của _SliderDoubleBikeState
  @override
  _SliderDoubleBikeState createState() => _SliderDoubleBikeState();
}

///Trả về giao diện list các xe đạp đôi có id bãi xe và tên bãi xe như trên
class _SliderDoubleBikeState extends State<SliderDoubleBike> {
  //Khởi tạo biến chứa danh sách các xe đạp đôi
  List<BikeModel> listDoubleBike;
  //Khai báo biến chứa danh sách xe đạp đôi theo id bãi xe
  List<BikeModel> listDoubleBikeById = [];

  SliderBikeController sliderBikeController = SliderBikeController();
  //Hàm khởi tạo sẽ được chạy khi class được gọi đến
  @override
  void initState() {
    setState(() {
      listDoubleBike = SplashScreen.listDoubleBike;
      // Lấy ra danh sách xe và add vào List listDoubleBikeById ở trên từ server
      sliderBikeController.getBike(
          parkingId: widget.parkingId,
          typeBike: widget.typeBike,
          listBike: listDoubleBike,
          listBikeById: listDoubleBikeById);
    });

    super.initState();
  }

  //Hiển thị danh sách xe đạp đôi cho người dùng tương tác
  @override
  Widget build(BuildContext context) {
    return Helper.listBike(listDoubleBikeById, widget.nameParking);
  }
}
