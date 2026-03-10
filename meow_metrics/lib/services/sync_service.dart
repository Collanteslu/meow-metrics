import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'api_service.dart';
import 'local_storage_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});

class SyncService {
  final Logger logger = Logger();
  bool _isSyncing = false;

  bool get isSyncing => _isSyncing;

  /// Sync all unsynced data with the server
  Future<void> syncAll(
    ApiService apiService,
    LocalStorageService localStorage,
  ) async {
    if (_isSyncing) {
      logger.w('Sync already in progress');
      return;
    }

    try {
      _isSyncing = true;
      logger.i('Starting full sync');

      // Sync colonies
      await _syncColonies(apiService, localStorage);

      // Sync cats
      await _syncCats(apiService, localStorage);

      // Sync health records
      await _syncHealthRecords(apiService, localStorage);

      logger.i('Full sync completed');
    } catch (e) {
      logger.e('Error during sync: $e');
      rethrow;
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync unsynced colonies
  Future<void> _syncColonies(
    ApiService apiService,
    LocalStorageService localStorage,
  ) async {
    try {
      final unsyncedColonies = await localStorage.getUnsyncedColonies();

      for (final colony in unsyncedColonies) {
        try {
          await apiService.post('/colonies', {
            'id': colony.colonyId,
            'name': colony.name,
            'city': colony.city,
            'address': colony.address,
            'latitude': colony.latitude,
            'longitude': colony.longitude,
            'description': colony.description,
            'approximateCatCount': colony.approximateCatCount,
            'status': colony.status,
          });

          await localStorage.markColonyAsSynced(colony.colonyId);
          logger.i('Colony synced: ${colony.colonyId}');
        } catch (e) {
          logger.w('Failed to sync colony ${colony.colonyId}: $e');
        }
      }
    } catch (e) {
      logger.e('Error syncing colonies: $e');
    }
  }

  /// Sync unsynced cats
  Future<void> _syncCats(
    ApiService apiService,
    LocalStorageService localStorage,
  ) async {
    try {
      final unsyncedCats = await localStorage.getUnsyncedCats();

      for (final cat in unsyncedCats) {
        try {
          await apiService.post('/cats', {
            'id': cat.catId,
            'colonyId': cat.colonyId,
            'name': cat.name,
            'color': cat.color,
            'microchipId': cat.microchipId,
            'gender': cat.gender,
            'birthDate': cat.birthDate?.toIso8601String(),
            'cerStatus': cat.cerStatus,
            'sterilizationStatus': cat.sterilizationStatus,
            'healthStatus': cat.healthStatus,
            'description': cat.description,
          });

          await localStorage.markCatAsSynced(cat.catId);
          logger.i('Cat synced: ${cat.catId}');
        } catch (e) {
          logger.w('Failed to sync cat ${cat.catId}: $e');
        }
      }
    } catch (e) {
      logger.e('Error syncing cats: $e');
    }
  }

  /// Sync unsynced health records
  Future<void> _syncHealthRecords(
    ApiService apiService,
    LocalStorageService localStorage,
  ) async {
    try {
      final unsyncedRecords = await localStorage.getUnsyncedHealthRecords();

      for (final record in unsyncedRecords) {
        try {
          await apiService.post('/health-records', {
            'id': record.recordId,
            'catId': record.catId,
            'recordType': record.recordType,
            'description': record.description,
            'recordDate': record.recordDate.toIso8601String(),
            'vetName': record.vetName,
            'vetClinic': record.vetClinic,
            'notes': record.notes,
          });

          await localStorage.markHealthRecordAsSynced(record.recordId);
          logger.i('Health record synced: ${record.recordId}');
        } catch (e) {
          logger.w('Failed to sync health record ${record.recordId}: $e');
        }
      }
    } catch (e) {
      logger.e('Error syncing health records: $e');
    }
  }

  /// Get sync statistics
  Future<SyncStats> getSyncStats(LocalStorageService localStorage) async {
    try {
      final unsyncedColonies = await localStorage.getUnsyncedColonies();
      final unsyncedCats = await localStorage.getUnsyncedCats();
      final unsyncedRecords = await localStorage.getUnsyncedHealthRecords();

      return SyncStats(
        unsyncedColonies: unsyncedColonies.length,
        unsyncedCats: unsyncedCats.length,
        unsyncedHealthRecords: unsyncedRecords.length,
      );
    } catch (e) {
      logger.e('Error getting sync stats: $e');
      return SyncStats(
        unsyncedColonies: 0,
        unsyncedCats: 0,
        unsyncedHealthRecords: 0,
      );
    }
  }
}

class SyncStats {
  final int unsyncedColonies;
  final int unsyncedCats;
  final int unsyncedHealthRecords;

  SyncStats({
    required this.unsyncedColonies,
    required this.unsyncedCats,
    required this.unsyncedHealthRecords,
  });

  int get totalUnsynced =>
      unsyncedColonies + unsyncedCats + unsyncedHealthRecords;

  bool get hasUnsynced => totalUnsynced > 0;
}
