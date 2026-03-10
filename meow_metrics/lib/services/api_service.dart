import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:logger/logger.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

class ApiService {
  final String baseUrl = 'http://localhost:3000/api';
  final Logger logger = Logger();
  final http.Client _client = http.Client();

  Future<Map<String, dynamic>> get(String path) async {
    try {
      logger.i('GET request to: $baseUrl$path');
      final response = await _client
          .get(Uri.parse('$baseUrl$path'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        logger.e('Error: ${response.statusCode}');
        throw ApiException('Failed to load data: ${response.statusCode}');
      }
    } on SocketException {
      logger.e('No internet connection');
      throw OfflineException('No internet connection');
    } on TimeoutException {
      logger.e('Request timeout');
      throw ApiException('Request timeout');
    } catch (e) {
      logger.e('Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      logger.i('POST request to: $baseUrl$path');
      final response = await _client
          .post(
            Uri.parse('$baseUrl$path'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        logger.e('Error: ${response.statusCode}');
        throw ApiException('Failed to create data: ${response.statusCode}');
      }
    } on SocketException {
      logger.e('No internet connection');
      throw OfflineException('No internet connection');
    } on TimeoutException {
      logger.e('Request timeout');
      throw ApiException('Request timeout');
    } catch (e) {
      logger.e('Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      logger.i('PUT request to: $baseUrl$path');
      final response = await _client
          .put(
            Uri.parse('$baseUrl$path'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        logger.e('Error: ${response.statusCode}');
        throw ApiException('Failed to update data: ${response.statusCode}');
      }
    } on SocketException {
      logger.e('No internet connection');
      throw OfflineException('No internet connection');
    } on TimeoutException {
      logger.e('Request timeout');
      throw ApiException('Request timeout');
    } catch (e) {
      logger.e('Error: $e');
      rethrow;
    }
  }

  Future<void> delete(String path) async {
    try {
      logger.i('DELETE request to: $baseUrl$path');
      final response = await _client
          .delete(Uri.parse('$baseUrl$path'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 204 && response.statusCode != 200) {
        logger.e('Error: ${response.statusCode}');
        throw ApiException('Failed to delete data: ${response.statusCode}');
      }
    } on SocketException {
      logger.e('No internet connection');
      throw OfflineException('No internet connection');
    } on TimeoutException {
      logger.e('Request timeout');
      throw ApiException('Request timeout');
    } catch (e) {
      logger.e('Error: $e');
      rethrow;
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class OfflineException implements Exception {
  final String message;
  OfflineException(this.message);

  @override
  String toString() => message;
}
