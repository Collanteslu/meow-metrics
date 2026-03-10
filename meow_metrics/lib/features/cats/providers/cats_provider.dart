import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_metrics/models/cat.dart';
import 'package:meow_metrics/services/api_service.dart';
import 'package:meow_metrics/services/local_storage_service.dart';
import 'package:uuid/uuid.dart';

final catsProvider =
    StateNotifierProvider.family<CatsNotifier, AsyncValue<List<Cat>>, String>(
        (ref, colonyId) {
  final apiService = ref.watch(apiServiceProvider);
  final localStorage = ref.watch(localStorageProvider);

  return CatsNotifier(apiService, localStorage, colonyId);
});

final catSearchProvider = StateProvider<String>((ref) {
  return '';
});

final catFilterProvider = StateProvider<String>((ref) {
  return 'all';
});

class CatsNotifier extends StateNotifier<AsyncValue<List<Cat>>> {
  final ApiService _apiService;
  final AsyncValue<LocalStorageService> _localStorageAsync;
  final String _colonyId;
  final uuid = const Uuid();

  CatsNotifier(this._apiService, this._localStorageAsync, this._colonyId)
      : super(const AsyncValue.loading()) {
    _loadCats();
  }

  Future<void> _loadCats() async {
    try {
      state = const AsyncValue.loading();

      // Try to get from API first
      try {
        final response = await _apiService.get('/colonies/$_colonyId/cats');
        final catsList = response['cats'] as List?;

        if (catsList != null) {
          final cats = (catsList as List)
              .cast<Map<String, dynamic>>()
              .map((e) => _parseCat(e))
              .toList();

          // Save to local storage
          await _localStorageAsync.whenData((localStorage) {
            localStorage.saveCats(cats);
          });

          state = AsyncValue.data(cats);
        } else {
          state = AsyncValue.data([]);
        }
      } catch (e) {
        // Fall back to local storage
        final cats = await _localStorageAsync.whenData((localStorage) {
          return localStorage.getCatsByColony(_colonyId);
        });

        state = cats.when(
          data: (data) => AsyncValue.data(data),
          loading: () => const AsyncValue.loading(),
          error: (error, stack) => AsyncValue.error(error, stack),
        );
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addCat(Cat cat) async {
    try {
      // Add locally first
      final catWithId = cat.copyWith(
        catId: cat.catId.isEmpty ? uuid.v4() : cat.catId,
      );

      await _localStorageAsync.whenData((localStorage) {
        localStorage.saveCat(catWithId);
      });

      // Try to sync with API
      try {
        await _apiService.post(
          '/colonies/$_colonyId/cats',
          _catToJson(catWithId),
        );
        await _localStorageAsync.whenData((localStorage) {
          localStorage.markCatAsSynced(catWithId.catId);
        });
      } catch (e) {
        // Mark as unsynced, will retry later
      }

      // Reload cats
      await _loadCats();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateCat(Cat cat) async {
    try {
      // Update locally first
      await _localStorageAsync.whenData((localStorage) {
        localStorage.saveCat(cat.copyWith(isSynced: false));
      });

      // Try to sync with API
      try {
        await _apiService.put(
          '/colonies/$_colonyId/cats/${cat.catId}',
          _catToJson(cat),
        );
        await _localStorageAsync.whenData((localStorage) {
          localStorage.markCatAsSynced(cat.catId);
        });
      } catch (e) {
        // Mark as unsynced, will retry later
      }

      // Reload cats
      await _loadCats();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteCat(String catId) async {
    try {
      // Delete locally first
      await _localStorageAsync.whenData((localStorage) {
        localStorage.deleteCat(catId);
      });

      // Try to delete from API
      try {
        await _apiService.delete('/colonies/$_colonyId/cats/$catId');
      } catch (e) {
        // Handle delete error
      }

      // Reload cats
      await _loadCats();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Cat _parseCat(Map<String, dynamic> json) {
    return Cat(
      catId: json['id'] ?? '',
      colonyId: json['colonyId'] ?? _colonyId,
      name: json['name'] ?? '',
      color: json['color'],
      microchipId: json['microchipId'],
      gender: json['gender'] ?? 'unknown',
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'])
          : null,
      cerStatus: json['cerStatus'] ?? 'pending',
      sterilizationStatus: json['sterilizationStatus'] ?? 'not_sterilized',
      healthStatus: json['healthStatus'] ?? 'healthy',
      photoPath: json['photoPath'],
      description: json['description'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      isSynced: true,
    );
  }

  Map<String, dynamic> _catToJson(Cat cat) {
    return {
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
    };
  }
}
