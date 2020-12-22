import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../Model/bike_model.dart';
import '../RentBike/after_rent_bike.dart';
import '../RentBike/bike_detail.dart';
import '../authentication/authentication.dart';
import 'database.dart';
import 'notification.dart';

///Class này để chứa những widget và hàm dùng chung cho app
class Service {
  // Widget này trả về một AppBar chứa 1 action Notify
  static Widget appBarMain(Widget widget, BuildContext context) {
    return AppBar(
      title: widget,
      elevation: 0,
      //appbar này chứa 1 icons notify để người dùng xem lịch sử thông báo
      actions: [
        IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Notify(),
                  ));
            })
      ],
    );
  }

// trả về app bar dùng chung cho app
  static Widget appBarNotification(String title, BuildContext context) {
    return AppBar(
      title: Text(title),
      elevation: 0,
    );
  }

// định dạng trang trí cho input login
  static InputDecoration textFieldInputDecoration(String hintText) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black26),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black26)),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black26)));
  }

// định dạng màu, cỡ, loại chữ
  static TextStyle simpleTextFieldStyle(
      Color color, double fontSize, FontWeight fontWeight) {
    return TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight);
  }

  //Hàm check validator người dùng nhập mã xe
  static String validatorCodeBike(String value) {
    if (value == null) {
      return 'Hãy nhập mã số xe';
    } else if (int.tryParse(value) == null) {
      return 'Mã xe chỉ chứa chữ số';
    }
    return 'Thành công';
  }

  // Hàm xử lý Quá trình Thuê xe
// Trả về dialog để người dùng xác nhận thuê xe
  static Future<void> alertDialogRentBike(
      BuildContext buildContext,
      StopWatchTimer _stopWatchTimer,
      Position location,
      BikeModel bikeModel,
      String time,
      String nameParking,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      TextEditingController codeBike,
      GlobalKey formKey) async {
    final pr = ProgressDialog(buildContext, type: ProgressDialogType.Normal);
    var percentage = 0;
    int money;
    await DatabaseService.getMoneyCard(1).then((value) {
      value.once().then((snapshot) {
        money = snapshot.value;
      });
    });
    return showDialog(
        context: buildContext,
        builder: (context) {
          return AlertDialog(
            title: const Text("Bạn muốn thuê xe này? Vui lòng "
                "nhập mã số xe tương ứng và tài khoản"
                " sẽ tự động bị trừ tiền cọc: "),
            content: Form(
              key: formKey,
              child: TextFormField(
                validator: validatorCodeBike,
                decoration: const InputDecoration(
                    hintText: "Nhập mã số xe...", labelText: "Mã xe:"),
                autofocus: true,
                controller: codeBike,
              ),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(buildContext).pop();
                  },
                  child: const Text("Huỷ")),
              FlatButton(
                  onPressed: () async {
                    if (codeBike.text == bikeModel.codeBike) {
                      await pr.show();
                      // ignore: lines_longer_than_80_chars
                      await Future.delayed(const Duration(seconds: 3))
                          .then((value) {
                        percentage = percentage + 30;
                        // ignore: lines_longer_than_80_chars
                        pr.update(
                            progress: percentage.toDouble(),
                            message: "Vui lòng đợi...");
                        if (bikeModel.deposit <= money) {
                          //update trạng thái xe thành chưa sẵn sàng
                          DatabaseService.updateStateActionBike(
                              bikeModel.bikeId, "Chưa Sẵn Sàng");
                          _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                          // trừ tiền cọc vào tài khoản
                          DatabaseService.updateMoneyCard(
                              money - bikeModel.deposit);
                          // upload thông báo thuê xe thành công
                          DatabaseService.uploadNotiActionBike(
                                  bikeId: bikeModel.bikeId,
                                  parkingId: bikeModel.parkingId,
                                  codeBike: bikeModel.codeBike,
                                  typeBike: bikeModel.typeBike,
                                  nameParking: nameParking,
                                  time: time,
                                  action: "Thuê")
                              .whenComplete(() async {
                            await Future.delayed(const Duration(seconds: 2))
                                .then((value) {
                              pr.hide();
                              percentage = 0;
                            }).whenComplete(() async {
                              //Gửi thông báo thuê xe thành công cho người dùng
                              await _showNotificationWithDefaultSound(
                                  flutterLocalNotificationsPlugin,
                                  "Thuê ${bikeModel.typeBike} thành công",
                                  "Tên bãi xe: $nameParking "
                                      "- Mã xe: ${bikeModel.codeBike}");
                              // Chuyển sang giao diện Bản đồ Thuê Xe
                              await Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => RentBike(
                                          _stopWatchTimer,
                                          location,
                                          bikeModel,
                                          flutterLocalNotificationsPlugin)),
                                  (route) => false);
                            });
                          });
                        } else {
                          //Hiện toast báo người dùng k đủ tiền cọc xe
                          Future.delayed(const Duration(seconds: 2))
                              .then((value) {
                            pr.hide();
                            percentage = 0;
                          }).whenComplete(() {
                            alertDialogNotiStateBike(buildContext,
                                "Thẻ không đủ tiền để trả cọc xe");
                          });
                        }
                      });
                    } else {
                      //Hiện toast báo người dùng nhập sai mã xe
                      await alertDialogNotiStateBike(
                          buildContext, "Nhập lại mã số xe");
                    }
                  },
                  child: const Text("Thuê ngay"))
            ],
          );
        });
  }

// Trả về toast thông báo về giao dịch của người dùng
  static Future<void> alertDialogNotiStateBike(
      BuildContext context, String input) async {
    return BotToast.showText(
        text: input,
        duration: const Duration(seconds: 2),
        backButtonBehavior: BackButtonBehavior.none,
        align: const Alignment(0, 0.8),
        animationDuration: const Duration(milliseconds: 200),
        animationReverseDuration: const Duration(milliseconds: 200),
        textStyle:
            TextStyle(color: const Color(0xFFFFFFFF), fontSize: 17.toDouble()),
        borderRadius: BorderRadius.circular(8.toDouble()),
        backgroundColor: const Color(0x00000000),
        contentColor: const Color(0x8A000000));
  }

// Hàm trả về dialog để xác nhận người dùng đăng xuất
  static Future<void> alertDialogLogout(BuildContext buildContext) async {
    return showDialog(
        context: buildContext,
        builder: (context) {
          return AlertDialog(
            title: const Text("Bạn muốn đăng xuất ?"),
            content: Image.asset("images/logout.gif", fit: BoxFit.fill),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(buildContext).pop();
                  },
                  child: const Text("Huỷ")),
              FlatButton(
                  onPressed: () async {
                    await Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => Authentication()),
                        (route) => false);
                  },
                  child: const Text(
                    "Đồng ý",
                  ))
            ],
          );
        });
  }

// Trả về widget Card chứa thông tin xe khi người dùng đang thuê
  static Widget card(String text, Widget widget) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.redAccent, width: 1)),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(text,
                style: simpleTextFieldStyle(Colors.black, 12, FontWeight.bold)),
            widget,
          ],
        ),
      ),
    );
  }

// Trả về widget ListTile chứa lựa chọn cho người dùng trong drawable
  static Widget listTile(String text, IconData iconData) {
    return ListTile(
      leading: IconButton(
        icon: Icon(iconData),
        onPressed: () {},
      ),
      title: Text(text,
          style: simpleTextFieldStyle(Colors.black, 16, FontWeight.normal)),
      trailing: const IconButton(
          icon: Icon(Icons.arrow_forward_ios), onPressed: null),
    );
  }

// Hàm trả về thông báo cho người dùng
  static Future<void> _showNotificationWithDefaultSound(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String nameNotification,
      String description) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    const iOSPlatformChannelSpecifics = IOSNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      nameNotification,
      description,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

// Trả về list Bike ứng với bãi xe
  static Widget listBike(List<BikeModel> listBikeById, String nameParking) {
    //Check listBikeById nếu trống thì hiển thị "k có xe có sẵn",
    // nếu có thì trả về danh sách xe
    return listBikeById.isEmpty
        ? const Center(
            child: Text("Không có xe sẵn cho bạn"),
          )
        : ListView.builder(
            itemCount: listBikeById.length,
            itemExtent: 350,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Image.network(
                            listBikeById[index]
                                .urlImage["urlImage${index + 1}"],
                            height: 30,
                            width: 30,
                            fit: BoxFit.fill),
                        title: Text(listBikeById[index].nameBike,
                            style: simpleTextFieldStyle(
                                Colors.black, 15, FontWeight.normal)),
                        subtitle: Text(
                          listBikeById[index].state,
                          style: simpleTextFieldStyle(
                              Colors.black26, 13, FontWeight.normal),
                        ),
                      ),
                      const Divider(
                        indent: 10,
                        endIndent: 10,
                        color: Colors.grey,
                      ),
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                //Chuyển hướng sang Chi tiết xe
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BikeDetail(
                                    bikeModel: listBikeById[index],
                                    nameParking: nameParking,
                                  ),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image.network(
                                    listBikeById[index]
                                        .urlImage["urlImage${index + 1}"],
                                    fit: BoxFit.fill,
                                    width: MediaQuery.of(context).size.width),
                              ))),
                    ],
                  ),
                ),
              );
            },
          );
  }

  static String formatDate() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final time = formatter.format(now);
    return time;
  }
}
