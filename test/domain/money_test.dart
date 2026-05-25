import 'package:flutter_test/flutter_test.dart';
import 'package:treasure_chest_records/domain/money.dart' as money;

void main() {
  group('formatCents', () {
    test('converts 1250 cents to SGD 12.50', () {
      expect(money.formatCents(1250), 'SGD 12.50');
    });

    test('converts 0 cents to SGD 0.00', () {
      expect(money.formatCents(0), 'SGD 0.00');
    });

    test('converts 99 cents to SGD 0.99', () {
      expect(money.formatCents(99), 'SGD 0.99');
    });
  });

}
