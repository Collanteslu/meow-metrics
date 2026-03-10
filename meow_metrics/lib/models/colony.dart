import 'package:isar/isar.dart';

part 'colony.g.dart';

@collection
class Colony {
  final Id? id;
  final String colonyId;
  final String name;
  final String? city;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? description;
  final int approximateCatCount;
  final String status; // active, inactive, archived
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  Colony({
    this.id,
    required this.colonyId,
    required this.name,
    this.city,
    this.address,
    this.latitude,
    this.longitude,
    this.description,
    this.approximateCatCount = 0,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  Colony copyWith({
    Id? id,
    String? colonyId,
    String? name,
    String? city,
    String? address,
    double? latitude,
    double? longitude,
    String? description,
    int? approximateCatCount,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return Colony(
      id: id ?? this.id,
      colonyId: colonyId ?? this.colonyId,
      name: name ?? this.name,
      city: city ?? this.city,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      approximateCatCount: approximateCatCount ?? this.approximateCatCount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Colony &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          colonyId == other.colonyId &&
          name == other.name &&
          city == other.city &&
          address == other.address &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          description == other.description &&
          approximateCatCount == other.approximateCatCount &&
          status == other.status &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          isSynced == other.isSynced;

  @override
  int get hashCode =>
      id.hashCode ^
      colonyId.hashCode ^
      name.hashCode ^
      city.hashCode ^
      address.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      description.hashCode ^
      approximateCatCount.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isSynced.hashCode;
}
