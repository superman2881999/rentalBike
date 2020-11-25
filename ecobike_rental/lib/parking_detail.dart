import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import 'slider_bike.dart';
import 'slider_double_bike.dart';
import 'slider_electric_bike.dart';
import 'widget.dart';

class ParkingDetail extends StatefulWidget {
  const ParkingDetail(this.parkingId, this.nameParking);
  final String nameParking;
  final int parkingId;
  @override
  _ParkingDetailState createState() => _ParkingDetailState();
}

class _ParkingDetailState extends State<ParkingDetail> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final widgetOptions = [
      SliderBike(
        parkingId: widget.parkingId,
        nameParking: widget.nameParking,
      ),
      SliderElectricBike(
          parkingId: widget.parkingId, nameParking: widget.nameParking),
      SliderDoubleBike(
          parkingId: widget.parkingId, nameParking: widget.nameParking),
    ];
    return Scaffold(
        appBar: appBarMain(const Text("Danh sách xe trong bãi"), context),
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
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              }),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: widgetOptions.elementAt(_selectedIndex)));
  }
}
