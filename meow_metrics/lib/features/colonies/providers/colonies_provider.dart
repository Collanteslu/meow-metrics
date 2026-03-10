import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_metrics/models/colony.dart';
import 'package:meow_metrics/services/api_service.dart';
import 'package:meow_metrics/services/local_storage_service.dart';
import 'package:uuid/uuid.dart';

final coloniesProvider =
    StateNotifierProvider<ColoniesNotifier, AsyncValue<List<Colony>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final localStorage = ref.watch(localStorageProvider);

  return ColoniesNotifier(apiService, localStorage);
});

final selectedColonyProvider = StateProvider<Colony?>((ref) {
  return null;
});

final colonySearchProvider = StateProvider<String>((ref) {
  return '';
});

class ColoniesNotifier extends StateNotifier<AsyncValue<List<Colony>>> {
  final ApiService _apiService;
  final AsyncValue<LocalStorageService> _localStorageAsync;
  final uuid = const Uuid();

  ColoniesNotifier(this._apiService, this._localStorageAsync)
      : super(const AsyncValue.loading()) {
    _loadColonies();
  }

  Future<void> _loadColonies() async {
    try {
      state = const AsyncValue.loading();

      // Try to get from API first
      try {
        final response = await _apiService.get('/colonies');
        final coloniesList = response['colonies'] as List?;

        if (coloniesList != null) {
          final colonies = (coloniesList as List)
              .cast<Map<String, dynamic>>()
              .map((e) => _parseColony(e))
              .toList();

          // Save to local storage
          await _localStorageAsync.whenData((localStorage) {
            localStorage.saveColonies(colonies);
          });

          state = AsyncValue.data(colonies);
        } else {
          state = AsyncValue.data([]);
        }
      } catch (e) {
        // Fall back to local storage
        final colonies = await _localStorageAsync.whenData((localStorage) {
          return localStorage.getAllColonies();
        });

        state = colonies.when(
          data: (data) => AsyncValue.data(data),
          loading: () => const AsyncValue.loading(),
          error: (error, stack) => AsyncValue.error(error, stack),
        );
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addColony(Colony colony) async {
    try {
      // Add locally first
      final colonyWithId = colony.copyWith(
        colonyId: colony.colonyId.isEmpty ? uuid.v4() : colony.colonyId,
      );

      await _localStorageAsync.whenData((localStorage) {
        localStorage.saveColony(colonyWithId);
      });

      // Try to sync with API
      try {
        await _apiService.post('/colonies', _colonyToJson(colonyWithId));
        await _localStorageAsync.whenData((localStorage) {
          localStorage.markColonyAsSynced(colonyWithId.colonyId);
        });
      } catch (e) {
        // Mark as unsynced, will retry later
      }

      // Reload colonies
      await _loadColonies();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateColony(Colony colony) async {
    try {
      // Update locally first
      await _localStorageAsync.whenData((localStorage) {
        localStorage.saveColony(colony.copyWith(isSynced: false));
      });

      // Try to sync with API
      try {
        await _apiService.put('/colonies/${colony.colonyId}',
            _colonyToJson(colony));
        await _localStorageAsync.whenData((localStorage) {
          localStorage.markColonyAsSynced(colony.colonyId);
        });
      } catch (e) {
        // Mark as unsynced, will retry later
      }

      // Reload colonies
      await _loadColonies();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteColony(String colonyId) async {
    try {
      // Delete locally first
      await _localStorageAsync.whenData((localStorage) {
        localStorage.deleteColony(colonyId);
      });

      // Try to delete from API
      try {
        await _apiService.delete('/colonies/$colonyId');
      } catch (e) {
        // Handle delete error
      }

      // Reload colonies
      await _loadColonies();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Colony _parseColony(Map<String, dynamic> json) {
    return Colony(
      colonyId: json['id'] ?? '',
      name: json['name'] ?? '',
      city: json['city'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      description: json['description'],
      approximateCatCount: json['approximateCatCount'] ?? 0,
      status: json['status'] ?? 'active',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      isSynced: true,
    );
  }

  Map<String, dynamic> _colonyToJson(Colony colony) {
    return {
      'id': colony.colonyId,
      'name': colony.name,
      'city': colony.city,
      'address': colony.address,
      'latitude': colony.latitude,
      'longitude': colony.longitude,
      'description': colony.description,
      'approximateCatCount': colony.approximateCatCount,
      'status': colony.status,
    };
  }
}
