import 'package:isar/isar.dart';

part 'cat.g.dart';

@collection
class Cat {
  final Id? id;
  final String catId;
  final String colonyId;
  final String name;
  final String? color;
  final String? microchipId;
  final String gender; // male, female, unknown
  final DateTime? birthDate;
  final String cerStatus; // pending, in_progress, completed, failed
  final String sterilizationStatus; // not_sterilized, sterilized, pending
  final String healthStatus; // healthy, sick, deceased
  final String? photoPath;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  Cat({
    this.id,
    required this.catId,
    required this.colonyId,
    required this.name,
    this.color,
    this.microchipId,
    this.gender = 'unknown',
    this.birthDate,
    this.cerStatus = 'pending',
    this.sterilizationStatus = 'not_sterilized',
    this.healthStatus = 'healthy',
    this.photoPath,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  Cat copyWith({
    Id? id,
    String? catId,
    String? colonyId,
    String? name,
    String? color,
    String? microchipId,
    String? gender,
    DateTime? birthDate,
    String? cerStatus,
    String? sterilizationStatus,
    String? healthStatus,
    String? photoPath,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return Cat(
      id: id ?? this.id,
      catId: catId ?? this.catId,
      colonyId: colonyId ?? this.colonyId,
      name: name ?? this.name,
      color: color ?? this.color,
      microchipId: microchipId ?? this.microchipId,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      cerStatus: cerStatus ?? this.cerStatus,
      sterilizationStatus: sterilizationStatus ?? this.sterilizationStatus,
      healthStatus: healthStatus ?? this.healthStatus,
      photoPath: photoPath ?? this.photoPath,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cat &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          catId == other.catId &&
          colonyId == other.colonyId &&
          name == other.name &&
          color == other.color &&
          microchipId == other.microchipId &&
          gender == other.gender &&
          birthDate == other.birthDate &&
          cerStatus == other.cerStatus &&
          sterilizationStatus == other.sterilizationStatus &&
          healthStatus == other.healthStatus &&
          photoPath == other.photoPath &&
          description == other.description &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          isSynced == other.isSynced;

  @override
  int get hashCode =>
      id.hashCode ^
      catId.hashCode ^
      colonyId.hashCode ^
      name.hashCode ^
      color.hashCode ^
      microchipId.hashCode ^
      gender.hashCode ^
      birthDate.hashCode ^
      cerStatus.hashCode ^
      sterilizationStatus.hashCode ^
      healthStatus.hashCode ^
      photoPath.hashCode ^
      description.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isSynced.hashCode;
}
