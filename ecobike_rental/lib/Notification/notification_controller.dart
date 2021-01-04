import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifyController{
  // Hàm trả về thông báo cho người dùng
  static Future showNotificationWithDefaultSound(
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
}