import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:meow_metrics/features/auth/services/auth_service.dart';
import 'package:meow_metrics/services/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      authService = AuthService(mockApiService);
    });

    test('AuthService initializes correctly', () {
      expect(authService, isNotNull);
    });

    test('AuthService has logger', () {
      expect(authService.logger, isNotNull);
    });
  });
}
