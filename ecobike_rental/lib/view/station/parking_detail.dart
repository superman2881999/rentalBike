import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../../helper/widget.dart';
import 'slider_double_bike.dart';
import 'slider_electric_bike.dart';
import 'slider_single_bike.dart';

///Trả về 1 instance của _ParkingDetailState
class ParkingDetail extends StatefulWidget {
  //Constructor nhận vào id của bãi xe và tên bãi xe
  const ParkingDetail(this.parkingId, this.nameParking);
  final String nameParking;
  final int parkingId;
  //Trả về 1 instance của _ParkingDetailState
  @override
  _ParkingDetailState createState() => _ParkingDetailState();
}

///Trả về danh sách
class _ParkingDetailState extends State<ParkingDetail> {
  //Khai báo biến lưu vị trí hiện tại của màn hình
  int _selectedIndex = 0;
  //Trả về giao diện các loại xe trong bãi để người dùng chọn
  @override
  Widget build(BuildContext context) {
    // Chứa các widget màn hình loại xe để người dùng chọn
    final widgetOptions = [
      SliderBike(
          parkingId: widget.parkingId,
          nameParking: widget.nameParking,
          typeBike: "Xe Đạp"),
      SliderElectricBike(
          parkingId: widget.parkingId,
          nameParking: widget.nameParking,
          typeBike: "Xe Đạp Điện"),
      SliderDoubleBike(
          parkingId: widget.parkingId,
          nameParking: widget.nameParking,
          typeBike: "Xe Đạp Đôi"),
    ];
    return Scaffold(
        appBar:
            Helper.appBarMain(const Text("Danh sách xe trong bãi"), context),
        //Hiển thị các lựa chọn cho người dùng
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(color: Colors.redAccent),
          child: GNav(
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              duration: const Duration(milliseconds: 800),
              tabBackgroundColor: Colors.red,
              tabs: [
                GButton(
                  icon: LineIcons.bicycle,
                  text: 'Xe Đạp',
                ),
                GButton(
                  icon: LineIcons.motorcycle,
                  text: 'Xe Đạp Điện',
                ),
                GButton(
                  icon: LineIcons.motorcycle,
                  text: 'Xe Đạp Đôi',
                )
              ],
              selectedIndex: _selectedIndex,
              //Hàm cập nhật vị trí hiện tại của màn hình
              onTabChange: (index) {
                if (mounted) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              }),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            //Trả về danh sách loại xe mà người dùng chọn
            child: widgetOptions.elementAt(_selectedIndex)));
  }
}
