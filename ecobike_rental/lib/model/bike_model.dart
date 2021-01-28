///Lớp Model chứa thông tin của xe
class BikeModel {
  BikeModel(
      {this.parkingId,
      this.state,
      this.nameBike,
      this.typeBike,
        this.urlImage,
      this.batteryCapacity,
      this.bikeId,
      this.codeBike,
      this.deposit,
      this.licensePlate});
  final int parkingId;
  final int bikeId;
  final String codeBike;
  final Map<dynamic,dynamic> urlImage;
  final int deposit;
  final String licensePlate;
  final int batteryCapacity;
  final String typeBike;
  final String nameBike;
  final String state;

  //Xử lý tiền thuê xe theo yêu cầu
  int calculatorMoney(int minuteTime,String typeBike) {
    double result;
    if (minuteTime > 10) {
      if (minuteTime >= 40) {
        result = 10000 + ((minuteTime - 40) / 15 + 1) * 3000;
      } else {
        result = 10000;
      }
    } else {
      result = 0;
    }
    if(typeBike == "Xe Đạp"){
      return result.round();
    }
    else{
      return (result*1.5).round();
    }
  }
}
