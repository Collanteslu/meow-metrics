import 'package:flutter_test/flutter_test.dart';
import 'package:meow_metrics/services/sync_service.dart';

void main() {
  group('SyncService', () {
    late SyncService syncService;

    setUp(() {
      syncService = SyncService();
    });

    test('SyncStats calculation works correctly', () {
      final stats = SyncStats(
        unsyncedColonies: 2,
        unsyncedCats: 3,
        unsyncedHealthRecords: 1,
      );

      expect(stats.totalUnsynced, 6);
      expect(stats.hasUnsynced, true);
    });

    test('SyncStats with zero unsynced items', () {
      final stats = SyncStats(
        unsyncedColonies: 0,
        unsyncedCats: 0,
        unsyncedHealthRecords: 0,
      );

      expect(stats.totalUnsynced, 0);
      expect(stats.hasUnsynced, false);
    });

    test('SyncService is not syncing initially', () {
      expect(syncService.isSyncing, false);
    });
  });
}
