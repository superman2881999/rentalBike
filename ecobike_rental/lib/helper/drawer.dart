import 'package:flutter/material.dart';

import '../view/credit_card/credit_card_info.dart';
import '../view/transaction_history/transaction_history.dart';
import 'widget.dart';

///Trả về 1 instance _DrawState
class Draw extends StatefulWidget {
  const Draw({this.check});
  final bool check;
  @override
  _DrawState createState() => _DrawState();
}

///Trả về draw của app chứa những tương tác, và thông tin của người dùng
class _DrawState extends State<Draw> {
  //Trả về giao diện draw giúp người dùng tương tác
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    image: const DecorationImage(
                        image: AssetImage("images/backgroundDrawer.png"),
                        fit: BoxFit.cover)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dũng Lê",
                              overflow: TextOverflow.ellipsis,
                              style: Helper.simpleTextFieldStyle(
                                  Colors.white, 18, FontWeight.normal),
                            ),
                            Text("Killteammate@gmail.com",
                                overflow: TextOverflow.ellipsis,
                                style: Helper.simpleTextFieldStyle(
                                    Colors.white, 14, FontWeight.normal)),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text("ƯU TIÊN"),
            ),
            GestureDetector(
                onTap: () {
                  //Chuyển hướng sang lịch sử thuê xe
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionHistory()));
                },
                child: Helper.listTile("Lịch sử thuê xe", Icons.access_time)),
            GestureDetector(
                onTap: () {
                  //Chuyển hướng sang màn hình thông tin thẻ tín dụng
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreditCardInfo()));
                },
                child: Helper.listTile("Thẻ tín dụng", Icons.credit_card)),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text("TÀI KHOẢN VÀ HỖ TRỢ"),
            ),
            Helper.listTile("Thông tin tài khoản", Icons.account_circle),
            Helper.listTile("Cài đặt", Icons.settings),
            GestureDetector(
                onTap: () {
                  if (widget.check) {
                    Helper.alertDialogLogout(context);
                  } else {
                    Helper.alertDialogNotiStateBike(
                        context, "Bạn không thể đăng xuất khi thuê xe");
                  }
                },
                child: ListTile(
                  leading: IconButton(
                      icon: const Icon(Icons.exit_to_app), onPressed: () {}),
                  title: Text("Đăng xuất",
                      style: Helper.simpleTextFieldStyle(
                          Colors.black, 16, FontWeight.normal)),
                )),
          ],
        ),
      ),
    );
  }
}
