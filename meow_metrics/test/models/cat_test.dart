import 'package:flutter_test/flutter_test.dart';
import 'package:meow_metrics/models/cat.dart';

void main() {
  group('Cat Model', () {
    test('Cat creation with required fields', () {
      final now = DateTime.now();
      final cat = Cat(
        catId: 'cat123',
        colonyId: 'colony123',
        name: 'Whiskers',
        createdAt: now,
        updatedAt: now,
      );

      expect(cat.catId, 'cat123');
      expect(cat.colonyId, 'colony123');
      expect(cat.name, 'Whiskers');
      expect(cat.gender, 'unknown');
      expect(cat.cerStatus, 'pending');
      expect(cat.sterilizationStatus, 'not_sterilized');
      expect(cat.healthStatus, 'healthy');
    });

    test('Cat with all fields', () {
      final now = DateTime.now();
      final birthDate = DateTime(2020, 1, 15);
      final cat = Cat(
        catId: 'cat123',
        colonyId: 'colony123',
        name: 'Whiskers',
        color: 'Orange',
        microchipId: 'chip123',
        gender: 'male',
        birthDate: birthDate,
        cerStatus: 'completed',
        sterilizationStatus: 'sterilized',
        healthStatus: 'healthy',
        photoPath: '/path/to/photo.jpg',
        description: 'A lovely orange cat',
        createdAt: now,
        updatedAt: now,
      );

      expect(cat.color, 'Orange');
      expect(cat.microchipId, 'chip123');
      expect(cat.gender, 'male');
      expect(cat.birthDate, birthDate);
      expect(cat.cerStatus, 'completed');
      expect(cat.sterilizationStatus, 'sterilized');
    });

    test('Cat copyWith updates fields correctly', () {
      final now = DateTime.now();
      final cat = Cat(
        catId: 'cat123',
        colonyId: 'colony123',
        name: 'Whiskers',
        createdAt: now,
        updatedAt: now,
      );

      final updatedCat = cat.copyWith(
        sterilizationStatus: 'sterilized',
        cerStatus: 'in_progress',
      );

      expect(updatedCat.sterilizationStatus, 'sterilized');
      expect(updatedCat.cerStatus, 'in_progress');
      expect(updatedCat.name, 'Whiskers'); // Unchanged
    });

    test('Cats with same properties are equal', () {
      final now = DateTime.now();
      final cat1 = Cat(
        catId: 'cat123',
        colonyId: 'colony123',
        name: 'Whiskers',
        createdAt: now,
        updatedAt: now,
      );

      final cat2 = Cat(
        catId: 'cat123',
        colonyId: 'colony123',
        name: 'Whiskers',
        createdAt: now,
        updatedAt: now,
      );

      expect(cat1, cat2);
    });
  });
}
