///Lớp model chứa thông tin thông báo
class NotificationModel {
  NotificationModel(
      {this.userId,
      this.bikeId,
      this.parkingId,
      this.description,
      this.nameNotification,
      this.time});
  String nameNotification;
  String time;
  int bikeId;
  int parkingId;
  String description;
  int userId;
}
