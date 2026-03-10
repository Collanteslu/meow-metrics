import 'package:flutter_test/flutter_test.dart';
import 'package:meow_metrics/models/colony.dart';

void main() {
  group('Colony Model', () {
    test('Colony creation with required fields', () {
      final now = DateTime.now();
      final colony = Colony(
        colonyId: 'colony123',
        name: 'Test Colony',
        createdAt: now,
        updatedAt: now,
      );

      expect(colony.colonyId, 'colony123');
      expect(colony.name, 'Test Colony');
      expect(colony.status, 'active');
      expect(colony.isSynced, false);
    });

    test('Colony with all fields', () {
      final now = DateTime.now();
      final colony = Colony(
        colonyId: 'colony123',
        name: 'Test Colony',
        city: 'Test City',
        address: '123 Main St',
        latitude: 40.7128,
        longitude: -74.0060,
        description: 'Test description',
        approximateCatCount: 10,
        status: 'active',
        createdAt: now,
        updatedAt: now,
        isSynced: false,
      );

      expect(colony.city, 'Test City');
      expect(colony.address, '123 Main St');
      expect(colony.latitude, 40.7128);
      expect(colony.longitude, -74.0060);
      expect(colony.approximateCatCount, 10);
    });

    test('Colony copyWith updates fields correctly', () {
      final now = DateTime.now();
      final colony = Colony(
        colonyId: 'colony123',
        name: 'Test Colony',
        city: 'Old City',
        createdAt: now,
        updatedAt: now,
      );

      final updatedColony = colony.copyWith(
        city: 'New City',
        isSynced: true,
      );

      expect(updatedColony.city, 'New City');
      expect(updatedColony.isSynced, true);
      expect(updatedColony.name, 'Test Colony'); // Unchanged
    });

    test('Colonies with same properties are equal', () {
      final now = DateTime.now();
      final colony1 = Colony(
        colonyId: 'colony123',
        name: 'Test Colony',
        createdAt: now,
        updatedAt: now,
      );

      final colony2 = Colony(
        colonyId: 'colony123',
        name: 'Test Colony',
        createdAt: now,
        updatedAt: now,
      );

      expect(colony1, colony2);
    });
  });
}
