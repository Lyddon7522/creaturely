import 'package:creaturely/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('completedAgeMonths', () {
    test('counts only completed calendar months', () {
      final birthDate = DateTime(2024, 6, 15);

      expect(completedAgeMonths(birthDate, DateTime(2025, 6, 14)), 11);
      expect(completedAgeMonths(birthDate, DateTime(2025, 6, 15)), 12);
    });

    test('treats the end of a shorter month as the monthly anniversary', () {
      final birthDate = DateTime(2025, 1, 31);

      expect(completedAgeMonths(birthDate, DateTime(2025, 2, 27)), 0);
      expect(completedAgeMonths(birthDate, DateTime(2025, 2, 28)), 1);
    });

    test('does not return a negative age for a future date', () {
      expect(completedAgeMonths(DateTime(2027, 1, 1), DateTime(2026, 1, 1)), 0);
    });
  });
}
