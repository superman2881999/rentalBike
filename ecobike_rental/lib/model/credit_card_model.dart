///Lớp model chứa thông tin của thẻ tín dụng
class CreditCardModel {
  CreditCardModel(
      {this.cardId,
      this.amountMoney,
      this.userId,
      this.appCode,
      this.codeCard,
      this.cvvCode,
      this.dateExpired,
      this.secretKey});

  int amountMoney;
  String appCode;
  int cardId;
  String codeCard;
  int cvvCode;
  String dateExpired;
  String secretKey;
  int userId;
}
