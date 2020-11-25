import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Model/notification_model.dart';
import 'intro_app/splash_screen.dart';
import 'widget.dart';

class Notify extends StatefulWidget {
  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  List<NotificationModel> listNotification = SplashScreen.listNotification;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarNotification("Thông báo", context),
        body: Padding(
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
                            listNotification[index].nameNotification,
                            overflow: TextOverflow.ellipsis,
                            style: simpleTextFieldStyle(Colors.black, 18),
                          ),
                          subtitle: Transform(
                            transform: Matrix4.translationValues(0, 10, 0),
                            child: Text(listNotification[index].description,
                                style:
                                    simpleTextFieldStyle(Colors.black45, 15)),
                          ),
                          trailing: Text(listNotification[index].time,
                              style:
                                  simpleTextFieldStyle(Colors.black45, 14)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 4,
                    top: 22,
                    child: ClipPath(
                        clipper: TopBackgrounfImageClipper(),
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

//custom lại clippath
class TopBackgrounfImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final controlPoint = Offset(size.width / 4, size.height / 2);
    final endPoint = Offset(0, size.height);
    final path = Path();
    // ignore: cascade_invocations
    path.moveTo(0, 0);
    // ignore: cascade_invocations
    path.lineTo(0, 0);
    // ignore: cascade_invocations
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    // ignore: cascade_invocations
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
