import 'package:flutter_test/flutter_test.dart';
import 'package:meow_metrics/models/user.dart';

void main() {
  group('User Model', () {
    test('User creation with required fields', () {
      final now = DateTime.now();
      final user = User(
        userId: 'user123',
        email: 'test@example.com',
        createdAt: now,
        updatedAt: now,
      );

      expect(user.userId, 'user123');
      expect(user.email, 'test@example.com');
      expect(user.isVerified, false);
    });

    test('User copyWith updates fields correctly', () {
      final now = DateTime.now();
      final user = User(
        userId: 'user123',
        email: 'test@example.com',
        createdAt: now,
        updatedAt: now,
        name: 'John Doe',
      );

      final updatedUser = user.copyWith(
        email: 'newemail@example.com',
        isVerified: true,
      );

      expect(updatedUser.email, 'newemail@example.com');
      expect(updatedUser.isVerified, true);
      expect(updatedUser.name, 'John Doe'); // Unchanged
    });

    test('Users with same properties are equal', () {
      final now = DateTime.now();
      final user1 = User(
        userId: 'user123',
        email: 'test@example.com',
        createdAt: now,
        updatedAt: now,
      );

      final user2 = User(
        userId: 'user123',
        email: 'test@example.com',
        createdAt: now,
        updatedAt: now,
      );

      expect(user1, user2);
    });
  });
}
