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
  int parkingId;
  int bikeId;
  String codeBike;
  Map<dynamic,dynamic> urlImage;
  int deposit;
  String licensePlate;
  int batteryCapacity;
  String typeBike;
  String nameBike;
  String state;
}
