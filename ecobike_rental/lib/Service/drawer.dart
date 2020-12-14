import 'package:flutter/material.dart';

import 'credit_card_info.dart';
import 'transaction_history.dart';
import 'widget.dart';

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
              decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                  image: const DecorationImage(image: AssetImage("images/backgroundDrawer.png"),fit: BoxFit.cover)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CircleAvatar(
                  //   radius: 40.0,
                  //   backgroundImage: AssetImage("images/avatar.png"),
                  //   backgroundColor: Colors.transparent,
                  // ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dũng Lê",
                            overflow: TextOverflow.ellipsis,
                            style: simpleTextFieldStyle(Colors.white, 18),),
                          Text("Killteammate@gmail.com",
                              overflow: TextOverflow.ellipsis,
                              style: simpleTextFieldStyle(Colors.white, 14)),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text("ƯU TIÊN"),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => TransactionHistory()));
                },
                  child: listTile("Lịch sử thuê xe", Icons.access_time)),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => CreditCardInfo()));
                  },
                  child: listTile("Thẻ tín dụng", Icons.credit_card)),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text("TÀI KHOẢN VÀ HỖ TRỢ"),
              ),
              listTile("Thông tin tài khoản", Icons.account_circle),
              listTile("Cài đặt", Icons.settings),
              GestureDetector(
                onTap: (){
                  alertDialogLogout(context);
                },
                  child: ListTile(
                    leading: IconButton(icon: const Icon(Icons.exit_to_app),
                      onPressed: () {}),
                    title: Text("Đăng xuất",
                        style: simpleTextFieldStyle(Colors.black, 16)),
                  )),
          ],
        ),
      ),
    );
  }
}
