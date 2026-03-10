# Meow Metrics: Mobile App Implementation Plan (Flutter)

> **Execution:** Use subagent-driven-development. Can develop in parallel with backend/web using mock API.

**Goal:** Build fully functional Flutter app with offline support, camera integration, and native features.

**Architecture:** Flutter app using Riverpod for state, Isar for local storage, integrating with NestJS API.

**Tech Stack:** Flutter, Dart, Riverpod, Isar DB, Firebase (optional), Geolocator

**Estimated time:** 5-7 days (parallel work with web)

---

## Part 1: Project Setup & Core Structure (1 day)

### Structure
```
lib/
├── config/
│   ├── routes.dart
│   └── theme.dart
├── features/
│   ├── auth/
│   ├── colonies/
│   ├── cats/
│   └── health/
├── models/
├── services/
├── shared/
└── main.dart

test/
└── ...
```

### Key Tasks
1. **Flutter project init** - Create with iOS/Android templates
2. **Dependency setup** - Riverpod, Isar, http, geolocator
3. **Theme & branding** - Material Design 3, custom colors
4. **Navigation** - GoRouter setup, deep linking
5. **Local storage** - Isar database configuration

---

## Part 2: Authentication (1 day)

### Screens
- **Login** - Email/password with biometric option
- **Register** - Create account
- **Splash** - Check authentication state on startup

### Key Tasks
1. **Auth service** - API calls + JWT token management
2. **Secure storage** - Flutter secure storage for tokens
3. **Session handling** - Auto-refresh, logout
4. **Biometric auth** - Optional fingerprint/face ID
5. **State management** - Use Riverpod for auth state

---

## Part 3: Colonies & Maps (1.5 days)

### Screens
- **Colonies List** - Searchable list with filters
- **Colony Map** - Show all colonies on map with markers
- **Colony Detail** - Info, collaborators, tabs

### Key Features
1. **Maps integration** - Google Maps Flutter plugin
2. **GPS location** - Get current location for new colonies
3. **Offline support** - Cache colony data locally
4. **Pull-to-refresh** - Sync with server
5. **Search** - Filter colonies by name/city

### Offline-First Approach
```dart
// When creating colony
1. Save locally to Isar
2. Sync to API when connection available
3. Show sync status indicator
```

---

## Part 4: Cats & Photo Management (1.5 days)

### Screens
- **Cats List** - Per colony, with thumbnails
- **Cat Detail** - Photo gallery, health history
- **Add Cat** - Form + camera integration
- **Photo Gallery** - View all cat photos

### Key Features
1. **Camera integration** - image_picker plugin
2. **Photo compression** - Optimize before upload
3. **Offline photo storage** - Save to device
4. **QR scanner** - Scan microchip QR codes
5. **Batch operations** - Select multiple cats for CER

### Code Example
```dart
// Camera integration
final pickedFile = await ImagePicker().pickImage(
  source: ImageSource.camera,
);
// Compress and save locally
// Upload to backend when online
```

---

## Part 5: Health & CER Tracking (1 day)

### Screens
- **Health Records** - Timeline view per cat
- **CER Tracking** - Schedule, mark complete
- **Add Record** - Quick form for treatments/vaccinations

### Key Features
1. **Timeline UI** - Show chronological health events
2. **Status indicators** - Sterilized/pending/failed
3. **Notifications** - Remind about upcoming appointments
4. **Offline forms** - Fill forms without connection
5. **Sync conflict handling** - What if cat health status changes offline?

---

## Part 6: Offline Synchronization (1 day)

### Key Features
1. **Isar local database** - Mirror of server data
2. **Sync service** - Background sync when online
3. **Conflict resolution** - Server wins, or merge logic
4. **Sync status UI** - Show what's pending
5. **Background sync** - Use WorkManager for periodic sync

### Sync Flow
```
User works offline:
1. All changes saved to Isar
2. App shows "offline" indicator
3. When connection returns:
   - Check for conflicts
   - Upload changes
   - Download updates
   - Mark synced
```

---

## Critical Implementation Details

### API Client
```dart
// services/api_service.dart
class ApiService {
  Future<Response> get(String path) async {
    try {
      return await http.get(...);
    } on SocketException {
      // Handle offline
    }
  }
}
```

### Local Storage
```dart
// services/local_storage.dart using Isar
final isar = await Isar.open();
final colonies = await isar.collections.colony.where().findAll();
```

### State Management
```dart
// Using Riverpod
final coloniesProvider = FutureProvider((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getColonies();
});
```

### Navigation
```dart
// Using GoRouter
final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => SplashScreen()),
    GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
    GoRoute(path: '/colonies/:id', builder: (_, state) => ColonyDetail(id: state.params['id'])),
  ],
);
```

---

## Testing Strategy

- **Unit tests** - Services, models
- **Widget tests** - Individual screens
- **Integration tests** - Full user flows

---

## Platform-Specific Considerations

### iOS
- Privacy descriptions in Info.plist
- Camera permission handling
- Location permission handling

### Android
- Permissions in AndroidManifest.xml
- Material theme compatibility
- Back button handling

---

## Deliverables

- ✅ Fully functional Flutter app
- ✅ Authentication working (with local mock API if needed)
- ✅ Can view/create colonies
- ✅ Can manage cats with photos
- ✅ Health records and CER tracking
- ✅ Offline support working
- ✅ Camera and GPS integration
- ✅ Sync mechanism functional
- ✅ iOS and Android tested
- ✅ Tests passing

---

**Mobile plan complete. Ready for beta testing and app store submission.**
