class CalculatorMoney{
  //Xử lý tiền thuê xe theo yêu cầu
  static int calculatorMoney(int minuteTime) {
    int result;
    if (minuteTime > 10) {
      if (minuteTime >= 40) {
        result = (10000 + ((minuteTime - 40) / 15 + 1) * 3000).round();
      } else {
        result = 10000;
      }
    } else {
      result = 0;
    }
    return result;
  }
}