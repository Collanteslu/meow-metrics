import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:meow_metrics/services/api_service.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('ApiService', () {
    late ApiService apiService;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      apiService = ApiService();
    });

    test('ApiException has correct message', () {
      const message = 'Test error message';
      final exception = ApiException(message);

      expect(exception.toString(), equals(message));
    });

    test('OfflineException has correct message', () {
      const message = 'No internet connection';
      final exception = OfflineException(message);

      expect(exception.toString(), equals(message));
    });
  });
}
