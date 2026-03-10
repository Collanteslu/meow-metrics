import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_metrics/models/health_record.dart';
import 'package:meow_metrics/services/api_service.dart';
import 'package:meow_metrics/services/local_storage_service.dart';
import 'package:uuid/uuid.dart';

final healthRecordsProvider = StateNotifierProvider.family<
    HealthRecordsNotifier,
    AsyncValue<List<HealthRecord>>,
    String>((ref, catId) {
  final apiService = ref.watch(apiServiceProvider);
  final localStorage = ref.watch(localStorageProvider);

  return HealthRecordsNotifier(apiService, localStorage, catId);
});

class HealthRecordsNotifier extends StateNotifier<AsyncValue<List<HealthRecord>>> {
  final ApiService _apiService;
  final AsyncValue<LocalStorageService> _localStorageAsync;
  final String _catId;
  final uuid = const Uuid();

  HealthRecordsNotifier(this._apiService, this._localStorageAsync, this._catId)
      : super(const AsyncValue.loading()) {
    _loadHealthRecords();
  }

  Future<void> _loadHealthRecords() async {
    try {
      state = const AsyncValue.loading();

      // Try to get from API first
      try {
        final response =
            await _apiService.get('/cats/$_catId/health-records');
        final recordsList = response['records'] as List?;

        if (recordsList != null) {
          final records = (recordsList as List)
              .cast<Map<String, dynamic>>()
              .map((e) => _parseHealthRecord(e))
              .toList();

          // Save to local storage
          await _localStorageAsync.whenData((localStorage) {
            localStorage.saveHealthRecords(records);
          });

          state = AsyncValue.data(records);
        } else {
          state = AsyncValue.data([]);
        }
      } catch (e) {
        // Fall back to local storage
        final records = await _localStorageAsync.whenData((localStorage) {
          return localStorage.getHealthRecordsByCat(_catId);
        });

        state = records.when(
          data: (data) => AsyncValue.data(data),
          loading: () => const AsyncValue.loading(),
          error: (error, stack) => AsyncValue.error(error, stack),
        );
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addHealthRecord(HealthRecord record) async {
    try {
      // Add locally first
      final recordWithId = record.copyWith(
        recordId: record.recordId.isEmpty ? uuid.v4() : record.recordId,
      );

      await _localStorageAsync.whenData((localStorage) {
        localStorage.saveHealthRecord(recordWithId);
      });

      // Try to sync with API
      try {
        await _apiService.post(
          '/cats/$_catId/health-records',
          _healthRecordToJson(recordWithId),
        );
        await _localStorageAsync.whenData((localStorage) {
          localStorage.markHealthRecordAsSynced(recordWithId.recordId);
        });
      } catch (e) {
        // Mark as unsynced, will retry later
      }

      // Reload records
      await _loadHealthRecords();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateHealthRecord(HealthRecord record) async {
    try {
      // Update locally first
      await _localStorageAsync.whenData((localStorage) {
        localStorage.saveHealthRecord(record.copyWith(isSynced: false));
      });

      // Try to sync with API
      try {
        await _apiService.put(
          '/cats/$_catId/health-records/${record.recordId}',
          _healthRecordToJson(record),
        );
        await _localStorageAsync.whenData((localStorage) {
          localStorage.markHealthRecordAsSynced(record.recordId);
        });
      } catch (e) {
        // Mark as unsynced, will retry later
      }

      // Reload records
      await _loadHealthRecords();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  HealthRecord _parseHealthRecord(Map<String, dynamic> json) {
    return HealthRecord(
      recordId: json['id'] ?? '',
      catId: json['catId'] ?? _catId,
      recordType: json['recordType'] ?? '',
      description: json['description'],
      recordDate:
          DateTime.tryParse(json['recordDate'] ?? '') ?? DateTime.now(),
      vetName: json['vetName'],
      vetClinic: json['vetClinic'],
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      isSynced: true,
    );
  }

  Map<String, dynamic> _healthRecordToJson(HealthRecord record) {
    return {
      'id': record.recordId,
      'catId': record.catId,
      'recordType': record.recordType,
      'description': record.description,
      'recordDate': record.recordDate.toIso8601String(),
      'vetName': record.vetName,
      'vetClinic': record.vetClinic,
      'notes': record.notes,
    };
  }
}
