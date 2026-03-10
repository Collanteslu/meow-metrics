import 'package:isar/isar.dart';

part 'health_record.g.dart';

@collection
class HealthRecord {
  final Id? id;
  final String recordId;
  final String catId;
  final String recordType; // vaccination, treatment, checkup, sterilization
  final String? description;
  final DateTime recordDate;
  final String? vetName;
  final String? vetClinic;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  HealthRecord({
    this.id,
    required this.recordId,
    required this.catId,
    required this.recordType,
    this.description,
    required this.recordDate,
    this.vetName,
    this.vetClinic,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  HealthRecord copyWith({
    Id? id,
    String? recordId,
    String? catId,
    String? recordType,
    String? description,
    DateTime? recordDate,
    String? vetName,
    String? vetClinic,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return HealthRecord(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      catId: catId ?? this.catId,
      recordType: recordType ?? this.recordType,
      description: description ?? this.description,
      recordDate: recordDate ?? this.recordDate,
      vetName: vetName ?? this.vetName,
      vetClinic: vetClinic ?? this.vetClinic,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthRecord &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          recordId == other.recordId &&
          catId == other.catId &&
          recordType == other.recordType &&
          description == other.description &&
          recordDate == other.recordDate &&
          vetName == other.vetName &&
          vetClinic == other.vetClinic &&
          notes == other.notes &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          isSynced == other.isSynced;

  @override
  int get hashCode =>
      id.hashCode ^
      recordId.hashCode ^
      catId.hashCode ^
      recordType.hashCode ^
      description.hashCode ^
      recordDate.hashCode ^
      vetName.hashCode ^
      vetClinic.hashCode ^
      notes.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isSynced.hashCode;
}
