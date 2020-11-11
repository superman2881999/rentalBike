import 'package:EcobikeRental/transactionHistory.dart';
import 'package:EcobikeRental/widget.dart';
import 'package:flutter/material.dart';

import 'CreditCardInfo.dart';

class Draw extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor,image: DecorationImage(image: AssetImage("images/backgroundDrawer.png"),fit: BoxFit.cover)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: AssetImage("images/avatar.png"),
                    backgroundColor: Colors.transparent,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dũng Lê",overflow: TextOverflow.ellipsis,style: simpleTextFieldStyle(Colors.white, 18.0),),
                          Text("Killteammate@gmail.com",overflow: TextOverflow.ellipsis,style: simpleTextFieldStyle(Colors.white, 14.0)),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("ƯU TIÊN"),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistory()));
                },
                  child: listTile("Lịch sử thuê xe", Icons.access_time)),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreditCardInfo()));
                  },
                  child: listTile("Thẻ tín dụng", Icons.credit_card)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("TÀI KHOẢN VÀ HỖ TRỢ"),
              ),
              listTile("Thông tin tài khoản", Icons.account_circle),
              listTile("Cài đặt", Icons.settings),
              GestureDetector(
                onTap: (){
                  alertDialogLogout(context);
                },
                  child: ListTile(
                    leading: IconButton(icon: Icon(Icons.exit_to_app)),
                    title: Text("Đăng xuất",style: simpleTextFieldStyle(Colors.black, 16.0)),
                  )),
          ],
        ),
      ),
    );
  }
}
