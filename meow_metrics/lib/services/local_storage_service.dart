import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import '../models/user.dart';
import '../models/colony.dart';
import '../models/cat.dart';
import '../models/health_record.dart';

final localStorageProvider = FutureProvider<LocalStorageService>((ref) async {
  final service = LocalStorageService();
  await service.initialize();
  return service;
});

class LocalStorageService {
  late Isar _isar;
  final Logger logger = Logger();

  Future<void> initialize() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [UserSchema, ColonySchema, CatSchema, HealthRecordSchema],
        directory: dir.path,
        inspector: true,
      );
      logger.i('LocalStorageService initialized');
    } catch (e) {
      logger.e('Failed to initialize LocalStorageService: $e');
      rethrow;
    }
  }

  // User operations
  Future<void> saveUser(User user) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.users.put(user);
      });
      logger.i('User saved: ${user.userId}');
    } catch (e) {
      logger.e('Error saving user: $e');
      rethrow;
    }
  }

  Future<User?> getUser(String userId) async {
    try {
      return await _isar.users.filter().userIdEqualTo(userId).findFirst();
    } catch (e) {
      logger.e('Error getting user: $e');
      return null;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      return await _isar.users.where().findAll();
    } catch (e) {
      logger.e('Error getting all users: $e');
      return [];
    }
  }

  // Colony operations
  Future<void> saveColony(Colony colony) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.colonys.put(colony);
      });
      logger.i('Colony saved: ${colony.colonyId}');
    } catch (e) {
      logger.e('Error saving colony: $e');
      rethrow;
    }
  }

  Future<void> saveColonies(List<Colony> colonies) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.colonys.putAll(colonies);
      });
      logger.i('${colonies.length} colonies saved');
    } catch (e) {
      logger.e('Error saving colonies: $e');
      rethrow;
    }
  }

  Future<Colony?> getColony(String colonyId) async {
    try {
      return await _isar.colonys.filter().colonyIdEqualTo(colonyId).findFirst();
    } catch (e) {
      logger.e('Error getting colony: $e');
      return null;
    }
  }

  Future<List<Colony>> getAllColonies() async {
    try {
      return await _isar.colonys.where().findAll();
    } catch (e) {
      logger.e('Error getting all colonies: $e');
      return [];
    }
  }

  Future<List<Colony>> getUnsyncedColonies() async {
    try {
      return await _isar.colonys.filter().isSyncedEqualTo(false).findAll();
    } catch (e) {
      logger.e('Error getting unsynced colonies: $e');
      return [];
    }
  }

  // Cat operations
  Future<void> saveCat(Cat cat) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.cats.put(cat);
      });
      logger.i('Cat saved: ${cat.catId}');
    } catch (e) {
      logger.e('Error saving cat: $e');
      rethrow;
    }
  }

  Future<void> saveCats(List<Cat> cats) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.cats.putAll(cats);
      });
      logger.i('${cats.length} cats saved');
    } catch (e) {
      logger.e('Error saving cats: $e');
      rethrow;
    }
  }

  Future<Cat?> getCat(String catId) async {
    try {
      return await _isar.cats.filter().catIdEqualTo(catId).findFirst();
    } catch (e) {
      logger.e('Error getting cat: $e');
      return null;
    }
  }

  Future<List<Cat>> getCatsByColony(String colonyId) async {
    try {
      return await _isar.cats.filter().colonyIdEqualTo(colonyId).findAll();
    } catch (e) {
      logger.e('Error getting cats by colony: $e');
      return [];
    }
  }

  Future<List<Cat>> getUnsyncedCats() async {
    try {
      return await _isar.cats.filter().isSyncedEqualTo(false).findAll();
    } catch (e) {
      logger.e('Error getting unsynced cats: $e');
      return [];
    }
  }

  // Health Record operations
  Future<void> saveHealthRecord(HealthRecord record) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.healthRecords.put(record);
      });
      logger.i('Health record saved: ${record.recordId}');
    } catch (e) {
      logger.e('Error saving health record: $e');
      rethrow;
    }
  }

  Future<void> saveHealthRecords(List<HealthRecord> records) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.healthRecords.putAll(records);
      });
      logger.i('${records.length} health records saved');
    } catch (e) {
      logger.e('Error saving health records: $e');
      rethrow;
    }
  }

  Future<List<HealthRecord>> getHealthRecordsByCat(String catId) async {
    try {
      return await _isar.healthRecords
          .filter()
          .catIdEqualTo(catId)
          .sortByRecordDateDesc()
          .findAll();
    } catch (e) {
      logger.e('Error getting health records: $e');
      return [];
    }
  }

  Future<List<HealthRecord>> getUnsyncedHealthRecords() async {
    try {
      return await _isar.healthRecords.filter().isSyncedEqualTo(false).findAll();
    } catch (e) {
      logger.e('Error getting unsynced health records: $e');
      return [];
    }
  }

  // Sync operations
  Future<void> markColonyAsSynced(String colonyId) async {
    try {
      final colony = await getColony(colonyId);
      if (colony != null) {
        await _isar.writeTxn(() async {
          await _isar.colonys.put(colony.copyWith(isSynced: true));
        });
        logger.i('Colony marked as synced: $colonyId');
      }
    } catch (e) {
      logger.e('Error marking colony as synced: $e');
    }
  }

  Future<void> markCatAsSynced(String catId) async {
    try {
      final cat = await getCat(catId);
      if (cat != null) {
        await _isar.writeTxn(() async {
          await _isar.cats.put(cat.copyWith(isSynced: true));
        });
        logger.i('Cat marked as synced: $catId');
      }
    } catch (e) {
      logger.e('Error marking cat as synced: $e');
    }
  }

  Future<void> markHealthRecordAsSynced(String recordId) async {
    try {
      final record = await _isar.healthRecords
          .filter()
          .recordIdEqualTo(recordId)
          .findFirst();
      if (record != null) {
        await _isar.writeTxn(() async {
          await _isar.healthRecords.put(record.copyWith(isSynced: true));
        });
        logger.i('Health record marked as synced: $recordId');
      }
    } catch (e) {
      logger.e('Error marking health record as synced: $e');
    }
  }

  Future<void> deleteColony(String colonyId) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.colonys.filter().colonyIdEqualTo(colonyId).deleteAll();
      });
      logger.i('Colony deleted: $colonyId');
    } catch (e) {
      logger.e('Error deleting colony: $e');
      rethrow;
    }
  }

  Future<void> deleteCat(String catId) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.cats.filter().catIdEqualTo(catId).deleteAll();
      });
      logger.i('Cat deleted: $catId');
    } catch (e) {
      logger.e('Error deleting cat: $e');
      rethrow;
    }
  }

  void close() {
    _isar.close();
    logger.i('LocalStorageService closed');
  }
}
