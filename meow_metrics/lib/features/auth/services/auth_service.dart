import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meow_metrics/services/api_service.dart';
import 'package:logger/logger.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthService(apiService);
});

class AuthService {
  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Logger logger = Logger();

  AuthService(this._apiService);

  // Store token securely
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: 'auth_token', value: token);
      logger.i('Token saved securely');
    } catch (e) {
      logger.e('Failed to save token: $e');
      rethrow;
    }
  }

  // Retrieve token from secure storage
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: 'auth_token');
    } catch (e) {
      logger.e('Failed to get token: $e');
      return null;
    }
  }

  // Clear all authentication data
  Future<void> logout() async {
    try {
      await _secureStorage.delete(key: 'auth_token');
      await _secureStorage.delete(key: 'user_id');
      logger.i('User logged out');
    } catch (e) {
      logger.e('Failed to logout: $e');
      rethrow;
    }
  }

  // Login user
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response.containsKey('token')) {
        await saveToken(response['token']);
        logger.i('User logged in successfully');
      }

      return response;
    } catch (e) {
      logger.e('Login failed: $e');
      rethrow;
    }
  }

  // Register new user
  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      final response = await _apiService.post('/auth/register', {
        'email': email,
        'password': password,
        'name': name,
      });

      if (response.containsKey('token')) {
        await saveToken(response['token']);
        logger.i('User registered successfully');
      }

      return response;
    } catch (e) {
      logger.e('Registration failed: $e');
      rethrow;
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      logger.e('Error checking authentication: $e');
      return false;
    }
  }

  // Refresh token
  Future<String?> refreshToken() async {
    try {
      final response = await _apiService.post('/auth/refresh', {});

      if (response.containsKey('token')) {
        await saveToken(response['token']);
        logger.i('Token refreshed');
        return response['token'];
      }

      return null;
    } catch (e) {
      logger.e('Failed to refresh token: $e');
      rethrow;
    }
  }
}
