import 'package:flutter/services.dart';

class Constant{
  //Khởi tạo tên MethodChannel để bên java bắt sự kiện
  static const platform = MethodChannel("Transaction");
  //Thông tin chủ thẻ
  static const codeCard = "118609_group5_2020";
  static const owner = "Group 5";
  static const cvvCode = 271;
  static const dateExpired = "1125";
}