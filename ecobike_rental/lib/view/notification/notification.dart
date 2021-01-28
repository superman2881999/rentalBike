import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helper/widget.dart';
import '../../model/notification_model.dart';
import '../intro_app/splash_screen.dart';
import 'custom_clip_path.dart';

///Trả về 1 instance _NotifyState
class Notify extends StatefulWidget {
  @override
  _NotifyState createState() => _NotifyState();
}

///Trả về giao diện hiển thị danh sách thông báo
class _NotifyState extends State<Notify> {
  //Khai báo biến chứa danh sách thông báo
  List<NotificationModel> listNotification;
  //Khởi tạo màn hình hiển thị danh sách thông báo
  @override
  void initState() {
    setState(() {
      listNotification = SplashScreen.listNotification;
    });
    super.initState();
  }

  //Trả về giao diện hiển thị danh sách thông báo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Helper.appBarNotification("Thông báo", context),
        body: listNotification.isEmpty
            ? const Center(child: Text("Không có thông báo nào"))
            : Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: listNotification.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        SizedBox(
                          height: 100,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  listNotification[
                                          listNotification.length - index - 1]
                                      .nameNotification,
                                  overflow: TextOverflow.ellipsis,
                                  style: Helper.simpleTextFieldStyle(
                                      Colors.black, 18, FontWeight.normal),
                                ),
                                subtitle: Transform(
                                  transform:
                                      Matrix4.translationValues(0, 10, 0),
                                  child: Text(
                                      listNotification[listNotification.length -
                                              index -
                                              1]
                                          .description,
                                      style: Helper.simpleTextFieldStyle(
                                          Colors.black45,
                                          15,
                                          FontWeight.normal)),
                                ),
                                trailing: Text(
                                    listNotification[
                                            listNotification.length - index - 1]
                                        .time,
                                    style: Helper.simpleTextFieldStyle(
                                        Colors.black45, 14, FontWeight.normal)),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 4,
                          top: 22,
                          child: ClipPath(
                              clipper: CustomClipPath(),
                              child: Container(
                                height: 55,
                                width: 60,
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                ),
                              )),
                        )
                      ],
                    );
                  },
                ),
              ));
  }
}
