import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helper/drawer.dart';
import '../../helper/widget.dart';
import '../../model/parking_model.dart';
import '../intro_app/splash_screen.dart';
import 'parking_detail.dart';

/// Trả về instance của _HomeState
class Home extends StatefulWidget {
  // trả về 1 instance của _HomeState
  @override
  _HomeState createState() => _HomeState();
}

/// Hiển thị danh sách các bãi xe khi người dùng đăng nhập thành công
class _HomeState extends State<Home> {
  //Khai báo biến chứa list bãi xe
  List<ParkingModel> listParking;
  //Khởi tạo giao diện ban đầu khi class đc tạo ra hiển thị danh sách bãi xe
  @override
  void initState() {
    //gán list bãi xe lấy đc ở màn hình Splash vào biến khởi tạo
    listParking = SplashScreen.listParking;
    super.initState();
  }

  //Trả về giao diện bãi xe
  @override
  Widget build(BuildContext context) {
    setState(() {
      //cập nhật bãi xe liên tục
      listParking = SplashScreen.listParking;
    });
    return Scaffold(
        appBar: Helper.appBarMain(
            Image.asset("images/title.png", fit: BoxFit.cover), context),
        drawer: const Draw(check: true),
        body: listParking.isEmpty
            ? Center(child: Image.asset("images/no.png"))
            : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: listParking.length,
                itemBuilder: (context, index) {
                  // return từng item Card hiển thị thông tin bãi xe
                  return GestureDetector(
                    // ignore: lines_longer_than_80_chars
                    //Khi 1 bãi xe đc click thì hàm này sẽ chạy và chuyển hướng sang màn hình chi tiết bãi xe
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParkingDetail(
                                  listParking[index].parkingId,
                                  listParking[index].nameParking)));
                    },
                    //Card chứa thông tin bãi xe
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        leading: Container(
                            padding: const EdgeInsets.only(right: 12),
                            decoration: const BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        width: 1, color: Colors.redAccent))),
                            child: Image.asset("images/bikeParking.png",
                                fit: BoxFit.cover)),
                        title: Text(listParking[index].nameParking,
                            style: Helper.simpleTextFieldStyle(
                                Colors.black, 17, FontWeight.bold)),
                        subtitle: Text(listParking[index].description),
                        trailing: const Icon(Icons.keyboard_arrow_right,
                            color: Colors.black, size: 30),
                      ),
                    ),
                  );
                },
              ));
  }
}
