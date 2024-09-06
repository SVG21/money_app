import 'package:flutter_test/flutter_test.dart';
import 'package:money_app/core/utils.dart';

void main() {
  group('Date Utils', () {
    test('Formats dates as TODAY if date is today', () {
      final today = DateTime.now();
      expect(formatDate(today), 'TODAY');
    });

    test('Formats dates as YESTERDAY if date is yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(formatDate(yesterday), 'YESTERDAY');
    });

    test('Formats dates in "d MMMM" format for older dates', () {
      final date = DateTime(2022, 8, 15);
      expect(formatDate(date), '15 August');
    });
  });
}
