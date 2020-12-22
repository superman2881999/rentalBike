///Lớp model chứa thông tin lịch sử giao dịch
class HistoryTransaction {
  HistoryTransaction({
    this.userId,
    this.transactionName,
    this.dateRentBike,
    this.paymentMoney,
    this.bikeId,
    this.timeRentBike,
    this.typeBike,
    this.licensePlate,
  });
  int bikeId;
  int userId;
  String timeRentBike;
  String typeBike;
  String licensePlate;
  int paymentMoney;
  String dateRentBike;
  String transactionName;
}
