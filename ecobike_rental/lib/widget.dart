import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'Model/bike_model.dart';
import 'after_rent_bike.dart';
import 'authentication.dart';
import 'notification.dart';
import 'service/database.dart';

Widget appBarMain(Widget widget, BuildContext context) {
  return AppBar(
    title: widget,
    elevation: 0,
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

Widget appBarNotification(String title, BuildContext context) {
  return AppBar(
    title: Text(title),
    elevation: 0,
  );
}

LinearGradient gradient() {
  return const LinearGradient(colors: [
    Color(0xFFBA68C8),
    Colors.purple,
  ]);
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.black26),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black26)),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black26)));
}

TextStyle simpleTextFieldStyle(Color color, double fontSize) {
  return TextStyle(color: color, fontSize: fontSize);
}

TextStyle especiallyTextFieldStyle(Color color, double fontSize) {
  return TextStyle(
      color: color, fontSize: fontSize, fontWeight: FontWeight.bold);
}

// ignore: avoid_positional_boolean_parameters
Widget container(IconData icon, bool isClicked) {
  return Container(
      decoration: BoxDecoration(
        color: isClicked ? Colors.white : const Color(0xFFBA68C8),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(width: 2, color: Colors.white),
      ),
      padding: const EdgeInsets.all(5),
      child: Center(child: Icon(icon, color: Colors.white)));
}

Future<void> alertDialogRentBike(
    BuildContext buildContext,
    StopWatchTimer _stopWatchTimer,
    Position location,
    BikeModel bikeModel,
    String time,
    String nameParking,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    TextEditingController codeBike,
    GlobalKey formKey) async {
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
              decoration: const InputDecoration(labelText: 'Nhập mã số xe...'),
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
                onPressed: () {
                  if (codeBike.text == bikeModel.codeBike) {
                    DatabaseService.updateStateRentBike(bikeModel.bikeId);
                    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                    DatabaseService.uploadNotiRentBike(
                        bikeId: bikeModel.bikeId,
                        parkingId: bikeModel.parkingId,
                        codeBike: bikeModel.codeBike,
                        typeBike: bikeModel.typeBike,
                        nameParking: nameParking,
                        time: time);
                    _showNotificationWithDefaultSound(
                        flutterLocalNotificationsPlugin,
                        "Thuê ${bikeModel.typeBike} thành công",
                        "Tên bãi xe: $nameParking "
                            "- Mã xe: ${bikeModel.codeBike}");
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => RentBike(
                                _stopWatchTimer,
                                location,
                                bikeModel,
                                flutterLocalNotificationsPlugin)),
                        (route) => false);
                  } else {
                    alertDialogNotiStateBike(buildContext,"Nhập lại mã số xe");
                  }
                },
                child: const Text("Thuê ngay"))
          ],
        );
      });
}

Future<void> alertDialogNotiStateBike(
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

Future<void> alertDialogLogout(BuildContext buildContext) async {
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
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Authentication()),
                      (route) => false);
                },
                child: const Text(
                  "Đồng ý",
                ))
          ],
        );
      });
}

Widget card(String text, Widget widget) {
  return Card(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.redAccent, width: 1)),
    elevation: 10,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(text, style: especiallyTextFieldStyle(Colors.black, 12)),
          widget,
        ],
      ),
    ),
  );
}

Widget listTile(String text, IconData iconData) {
  return ListTile(
    leading: IconButton(
      icon: Icon(iconData),
      onPressed: () {},
    ),
    title: Text(text, style: simpleTextFieldStyle(Colors.black, 16)),
    trailing:
        const IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: null),
  );
}

Future _showNotificationWithDefaultSound(
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
