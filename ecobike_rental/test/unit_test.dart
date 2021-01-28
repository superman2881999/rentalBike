import 'package:EcobikeRental/Helper/widget.dart';
import 'package:EcobikeRental/model/bike_model.dart';
import 'package:test/test.dart';

void main() {
  final bikeModel = BikeModel();
  //Unit test cho việc nhập mã số xe
  group('cokeBike', () {
    test('Check cokeBike', () async {
      final result = Helper.validatorCodeBike(null);
      expect(result, 'Hãy nhập mã số xe');
    });

    test('Check cokeBike', () async {
      final result = Helper.validatorCodeBike('123fdsfds#@');
      expect(result, 'Mã xe chỉ chứa chữ số');
    });

    test('Check cokeBike', () async {
      final result = Helper.validatorCodeBike('123');
      expect(result, 'Thành công');
    });
  });

  //Unit test cho việc tính tiền thuê xe
  group('calculatorMoney', () {
    test('Check calculatorMoney', () async {
      final result = bikeModel.calculatorMoney(10,"Xe Đạp");
      expect(result, 0);
    });

    test('Check calculatorMoney', () async {
      final result = bikeModel.calculatorMoney(15,'Xe Đạp');
      expect(result, 10000);
    });

    test('Check calculatorMoney', () async {
      final result = bikeModel.calculatorMoney(40,"Xe Đạp");
      expect(result, 13000);
    });

    test('Check calculatorMoney', () async {
      final result = bikeModel.calculatorMoney(45,"Xe Đạp");
      expect(result, 14000);
    });

    test('Check calculatorMoney', () async {
      final result = bikeModel.calculatorMoney(10,"Xe Đạp Điện");
      expect(result, 0);
    });

    test('Check calculatorMoney', () async {
      final result = bikeModel.calculatorMoney(15,"Xe Đạp Điện");
      expect(result, 15000);
    });

    test('Check calculatorMoney', () async {
      final result = bikeModel.calculatorMoney(40,"Xe Đạp Điện");
      expect(result, 19500);
    });

    test('Check calculatorMoney', () async {
      final result = bikeModel.calculatorMoney(45,"Xe Đạp Điện");
      expect(result, 21000);
    });
  });
}
