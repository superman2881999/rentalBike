class CreditCardModel {
  CreditCardModel(
      {this.cardId,
      this.amountMoney,
      this.userId,
      this.appCode,
      this.codeCard,
      this.cvvCode,
      this.dateExprited,
      this.secretKey});

  int amountMoney;
  String appCode;
  int cardId;
  String codeCard;
  int cvvCode;
  String dateExprited;
  String secretKey;
  int userId;


}
