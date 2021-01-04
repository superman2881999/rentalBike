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
}
