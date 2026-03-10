import 'package:flutter_test/flutter_test.dart';
import 'package:meow_metrics/models/health_record.dart';

void main() {
  group('HealthRecord Model', () {
    test('HealthRecord creation with required fields', () {
      final now = DateTime.now();
      final record = HealthRecord(
        recordId: 'record123',
        catId: 'cat123',
        recordType: 'vaccination',
        recordDate: now,
        createdAt: now,
        updatedAt: now,
      );

      expect(record.recordId, 'record123');
      expect(record.catId, 'cat123');
      expect(record.recordType, 'vaccination');
      expect(record.isSynced, false);
    });

    test('HealthRecord with all fields', () {
      final now = DateTime.now();
      final record = HealthRecord(
        recordId: 'record123',
        catId: 'cat123',
        recordType: 'sterilization',
        description: 'Successful sterilization',
        recordDate: now,
        vetName: 'Dr. Smith',
        vetClinic: 'Happy Paws Clinic',
        notes: 'No complications',
        createdAt: now,
        updatedAt: now,
      );

      expect(record.description, 'Successful sterilization');
      expect(record.vetName, 'Dr. Smith');
      expect(record.vetClinic, 'Happy Paws Clinic');
      expect(record.notes, 'No complications');
    });

    test('HealthRecord copyWith updates fields correctly', () {
      final now = DateTime.now();
      final record = HealthRecord(
        recordId: 'record123',
        catId: 'cat123',
        recordType: 'vaccination',
        recordDate: now,
        createdAt: now,
        updatedAt: now,
      );

      final updatedRecord = record.copyWith(
        vetName: 'Dr. Jones',
        isSynced: true,
      );

      expect(updatedRecord.vetName, 'Dr. Jones');
      expect(updatedRecord.isSynced, true);
      expect(updatedRecord.recordType, 'vaccination'); // Unchanged
    });

    test('HealthRecords with same properties are equal', () {
      final now = DateTime.now();
      final record1 = HealthRecord(
        recordId: 'record123',
        catId: 'cat123',
        recordType: 'vaccination',
        recordDate: now,
        createdAt: now,
        updatedAt: now,
      );

      final record2 = HealthRecord(
        recordId: 'record123',
        catId: 'cat123',
        recordType: 'vaccination',
        recordDate: now,
        createdAt: now,
        updatedAt: now,
      );

      expect(record1, record2);
    });
  });
}
