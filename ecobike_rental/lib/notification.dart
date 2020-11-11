import 'package:EcobikeRental/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

class Notificationss extends StatefulWidget {
  @override
  _NotificationssState createState() => _NotificationssState();
}

class _NotificationssState extends State<Notificationss> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
    initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List colors = [Colors.red, Colors.green, Colors.yellow,Colors.deepOrangeAccent,Colors.cyanAccent,Colors.red, Colors.green, Colors.yellow,Colors.deepOrangeAccent,Colors.cyanAccent];
    return Scaffold(
        appBar: appBarNotification("Notification",context),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(itemCount:10,itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _showNotificationWithDefaultSound();
              },
              child: Stack(
                children: [
                  Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
                      ),
                    child: ListTile(
                      title: Text("Trả xe đạp thành công",style: simpleTextFieldStyle(Colors.black, 12.0),),
                      subtitle: Text("Bãi 1 - Mã xe: 23657 456 4332",style: simpleTextFieldStyle(Colors.black26, 10.0)),
                      trailing: Text("5 phút",style: simpleTextFieldStyle(Colors.black26, 10.0)),
                    ),
                  ),
                  Positioned(
                    left: 4.0,
                    top: 22.0,
                    child: ClipPath(
                      clipper: TopBackgrounfImageClipper(),
                      child: Container(
                        height: 35,
                        width: 60,
                        decoration: BoxDecoration(
                          color: colors[index],
                      ),

                    )),
                  )
                ],
              ),
            );
          },),
        )
      );
  }
  Future _showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Trả xe đạp thành công',
      'Bãi 1 - Mã xe: 23657 456 4332',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}
//custom lại clippath
class TopBackgrounfImageClipper extends CustomClipper<Path> {

  @override
  getClip(Size size) {
    var controlPoint = Offset(size.width /4, size.height /2);
    var endPoint = Offset(0, size.height);
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, 0);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx,endPoint.dy);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
