import 'package:EcobikeRental/AfterRentBike.dart';
import 'package:EcobikeRental/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:geolocator/geolocator.dart';
import 'notification.dart';


Widget appBarMain(Widget widget,BuildContext context) {
  return AppBar(
    title: widget,
    elevation: 0,
    actions: [
      IconButton(icon: Icon(Icons.notifications_active), onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Notificationss(),));
      })
    ],
  );
}

Widget appBarNotification(String title,BuildContext context) {
  return AppBar(
    title: Text(title),
    elevation: 0,
  );
}

 gradient(){
  return LinearGradient(colors: [
    Color(0xFFBA68C8),
    Colors.purple,
  ]);
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.black26),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)));
}

TextStyle simpleTextFieldStyle(Color color, double fontSize) {
  return TextStyle(color: color,fontSize: fontSize);
}

TextStyle especiallyTextFieldStyle(Color color, double fontSize) {
  return TextStyle(color: color,fontSize: fontSize,fontWeight: FontWeight.bold);
}

Widget container(IconData icon,bool isClicked){
  return Container(
      decoration: BoxDecoration(
        color: isClicked ? Colors.white : Color(0xFFBA68C8),
        borderRadius: BorderRadius.circular(40.0),
        border: Border.all(width: 2, color: Colors.white),
      ),
      padding: EdgeInsets.all(5.0),
      child: Center(child: Icon(icon,color: Colors.white)));
}

Future<void> alertDialogRentBike(BuildContext buildContext,StopWatchTimer _stopWatchTimer,Position position) async {
  return showDialog(context: buildContext,builder: (context){
    return AlertDialog(
      title: Text("Bạn muốn thuê xe này? Vui lòng nhập mã số xe tương ứng và tài khoản sẽ tự động bị trừ tiền cọc: "),
      content: TextFormField(
        decoration: InputDecoration(
            labelText: 'Nhập mã số xe...'
        ),
      ),
      actions: [
        FlatButton(onPressed: () {
          Navigator.of(buildContext).pop();
        }, child: Text("Huỷ")),
        FlatButton(onPressed: (){
          _stopWatchTimer.onExecute
              .add(StopWatchExecute.start);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              RentBike(_stopWatchTimer,position)), (Route<dynamic> route) => false);
        }, child: Text("Thuê ngay"))
      ],
    );
  });
}

Future<void> alertDialogLogout(BuildContext buildContext) async {
  return showDialog(context: buildContext,builder: (context){
    return AlertDialog(
      title: Text("Bạn muốn đăng xuất ?"),
      content: Image.asset("images/logout.gif",fit: BoxFit.fill),
      actions: [
        FlatButton(onPressed: () {
          Navigator.of(buildContext).pop();
        }, child: Text("Huỷ")),
        FlatButton(onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              Authentication()), (Route<dynamic> route) => false);
        }, child: Text("Đồng ý",))
      ],
    );
  });
}

Widget card(String text,Widget widget){
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
    side: BorderSide(color: Colors.redAccent, width: 1)),
    elevation: 10.0,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(text,style: especiallyTextFieldStyle(Colors.black, 12.0)),
          widget,
        ],
      ),
    ),
  );
}

Widget listTile(String text,IconData iconData){
  return ListTile(
    leading: IconButton(icon: Icon(iconData)),
    title: Text(text,style: simpleTextFieldStyle(Colors.black, 16.0)),
    trailing: IconButton(icon: Icon(Icons.arrow_forward_ios)),
  );
}


