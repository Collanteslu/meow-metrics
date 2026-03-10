import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class User {
  final Id? id;
  final String userId;
  final String email;
  final String? name;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;

  User({
    this.id,
    required this.userId,
    required this.email,
    this.name,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
  });

  User copyWith({
    Id? id,
    String? userId,
    String? email,
    String? name,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          email == other.email &&
          name == other.name &&
          phoneNumber == other.phoneNumber &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          isVerified == other.isVerified;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      email.hashCode ^
      name.hashCode ^
      phoneNumber.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isVerified.hashCode;
}
