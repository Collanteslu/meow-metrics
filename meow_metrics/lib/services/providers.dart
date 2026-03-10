import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

// Providers for services
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Auth State Providers
final isAuthenticatedProvider = StateProvider<bool>((ref) {
  // TODO: Check actual auth state from secure storage
  return false;
});

final currentUserIdProvider = StateProvider<String?>((ref) {
  // TODO: Get current user ID from secure storage
  return null;
});

final userTokenProvider = StateProvider<String?>((ref) {
  // TODO: Get token from secure storage
  return null;
});

// Network state provider
final isOnlineProvider = StateProvider<bool>((ref) {
  // TODO: Implement connectivity monitoring
  return true;
});
