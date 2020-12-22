// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:EcobikeRental/RentBike/calculator_money.dart';
import 'package:EcobikeRental/Service/widget.dart';
import 'package:test/test.dart';

void main() {
  //Unit test cho việc nhập mã số xe
  group('cokeBike', () {
    test('Check cokeBike', () async {
      final result = Service.validatorCodeBike(null);
      expect(result, 'Hãy nhập mã số xe');
    });

    test('Check cokeBike', () async {
      final result = Service.validatorCodeBike('123fdsfds#@');
      expect(result, 'Mã xe chỉ chứa chữ số');
    });

    test('Check cokeBike', () async {
      final result = Service.validatorCodeBike('123');
      expect(result, 'Thành công');
    });
  });

  //Unit test cho việc tính tiền thuê xe
  group('calculatorMoney', () {
    test('Check calculatorMoney', () async {
      final result = CalculatorMoney.calculatorMoney(10);
      expect(result, 0);
    });

    test('Check calculatorMoney', () async {
      final result = CalculatorMoney.calculatorMoney(15);
      expect(result, 10000);
    });

    test('Check calculatorMoney', () async {
      final result = CalculatorMoney.calculatorMoney(40);
      expect(result, 13000);
    });

    test('Check calculatorMoney', () async {
      final result = CalculatorMoney.calculatorMoney(45);
      expect(result, 14000);
    });
  });
}
