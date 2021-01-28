import '../../helper/database.dart';
import '../../model/bike_model.dart';

class SliderBikeController {
  //Hàm lấy ra danh sách xe từ database
  void getBike(
      {List<BikeModel> listBike,
      List<BikeModel> listBikeById,
      int parkingId,
      String typeBike}) {
    // Lấy ra danh sách xe và add vào List listBikeById ở trên từ server
    DatabaseService.getListBike().then((values) {
      listBike.clear();
      values.once().then((snapshot) {
        snapshot.value.forEach((key, value) {
          if (value["typeBike"] == typeBike) {
            listBike.add(BikeModel(
                bikeId: value["bikeId"],
                batteryCapacity: value["batteryCapacity"],
                typeBike: value["typeBike"],
                urlImage: value["colorBike"],
                nameBike: value["nameBike"],
                codeBike: value["codeBike"],
                deposit: value["deposit"],
                state: value["state"],
                licensePlate: value["licensePlate"],
                parkingId: value["parkingId"]));
          }
        });
      });
    });
    // Lọc ra những xe có id trùng với id của bãi xe
    for (var i = 0; i < listBike.length; i++) {
      if (listBike[i].parkingId == parkingId) {
        listBikeById.add(listBike[i]);
      }
    }
  }
}
