// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHealthRecordCollection on Isar {
  IsarCollection<HealthRecord> get healthRecords => this.collection();
}

const HealthRecordSchema = CollectionSchema(
  name: r'HealthRecord',
  id: -2306919757135349190,
  properties: {
    r'catId': PropertySchema(
      id: 0,
      name: r'catId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 2,
      name: r'description',
      type: IsarType.string,
    ),
    r'hashCode': PropertySchema(
      id: 3,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'isSynced': PropertySchema(
      id: 4,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'notes': PropertySchema(
      id: 5,
      name: r'notes',
      type: IsarType.string,
    ),
    r'recordDate': PropertySchema(
      id: 6,
      name: r'recordDate',
      type: IsarType.dateTime,
    ),
    r'recordId': PropertySchema(
      id: 7,
      name: r'recordId',
      type: IsarType.string,
    ),
    r'recordType': PropertySchema(
      id: 8,
      name: r'recordType',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'vetClinic': PropertySchema(
      id: 10,
      name: r'vetClinic',
      type: IsarType.string,
    ),
    r'vetName': PropertySchema(
      id: 11,
      name: r'vetName',
      type: IsarType.string,
    )
  },
  estimateSize: _healthRecordEstimateSize,
  serialize: _healthRecordSerialize,
  deserialize: _healthRecordDeserialize,
  deserializeProp: _healthRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _healthRecordGetId,
  getLinks: _healthRecordGetLinks,
  attach: _healthRecordAttach,
  version: '3.1.0+1',
);

int _healthRecordEstimateSize(
  HealthRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.catId.length * 3;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.recordId.length * 3;
  bytesCount += 3 + object.recordType.length * 3;
  {
    final value = object.vetClinic;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.vetName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _healthRecordSerialize(
  HealthRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.catId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.description);
  writer.writeLong(offsets[3], object.hashCode);
  writer.writeBool(offsets[4], object.isSynced);
  writer.writeString(offsets[5], object.notes);
  writer.writeDateTime(offsets[6], object.recordDate);
  writer.writeString(offsets[7], object.recordId);
  writer.writeString(offsets[8], object.recordType);
  writer.writeDateTime(offsets[9], object.updatedAt);
  writer.writeString(offsets[10], object.vetClinic);
  writer.writeString(offsets[11], object.vetName);
}

HealthRecord _healthRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HealthRecord(
    catId: reader.readString(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    description: reader.readStringOrNull(offsets[2]),
    id: id,
    isSynced: reader.readBoolOrNull(offsets[4]) ?? false,
    notes: reader.readStringOrNull(offsets[5]),
    recordDate: reader.readDateTime(offsets[6]),
    recordId: reader.readString(offsets[7]),
    recordType: reader.readString(offsets[8]),
    updatedAt: reader.readDateTime(offsets[9]),
    vetClinic: reader.readStringOrNull(offsets[10]),
    vetName: reader.readStringOrNull(offsets[11]),
  );
  return object;
}

P _healthRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _healthRecordGetId(HealthRecord object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _healthRecordGetLinks(HealthRecord object) {
  return [];
}

void _healthRecordAttach(
    IsarCollection<dynamic> col, Id id, HealthRecord object) {}

extension HealthRecordQueryWhereSort
    on QueryBuilder<HealthRecord, HealthRecord, QWhere> {
  QueryBuilder<HealthRecord, HealthRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HealthRecordQueryWhere
    on QueryBuilder<HealthRecord, HealthRecord, QWhereClause> {
  QueryBuilder<HealthRecord, HealthRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HealthRecordQueryFilter
    on QueryBuilder<HealthRecord, HealthRecord, QFilterCondition> {
  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> catIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      catIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'catId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> catIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'catId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> catIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'catId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      catIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'catId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> catIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'catId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> catIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'catId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> catIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'catId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      catIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catId',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      catIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catId',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recordDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recordDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recordDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recordId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recordId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordId',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recordId',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recordType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recordType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recordType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recordType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recordType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recordType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recordType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordType',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      recordTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recordType',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetClinicIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vetClinic',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetClinicIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vetClinic',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetClinicEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vetClinic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetClinicGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vetClinic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetClinicLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vetClinic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetClinicBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vetClinic',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetClinicStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vetClinic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetClinicEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vetClinic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetClinicContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vetClinic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetClinicMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vetClinic',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetClinicIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vetClinic',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetClinicIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vetClinic',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vetName',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vetName',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vetName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vetName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vetName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vetName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vetName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vetName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vetName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vetName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vetName',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      vetNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vetName',
        value: '',
      ));
    });
  }
}

extension HealthRecordQueryObject
    on QueryBuilder<HealthRecord, HealthRecord, QFilterCondition> {}

extension HealthRecordQueryLinks
    on QueryBuilder<HealthRecord, HealthRecord, QFilterCondition> {}

extension HealthRecordQuerySortBy
    on QueryBuilder<HealthRecord, HealthRecord, QSortBy> {
  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByCatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catId', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByCatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catId', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByRecordDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordDate', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy>
      sortByRecordDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordDate', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByRecordType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordType', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy>
      sortByRecordTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordType', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByVetClinic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetClinic', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByVetClinicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetClinic', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByVetName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetName', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByVetNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetName', Sort.desc);
    });
  }
}

extension HealthRecordQuerySortThenBy
    on QueryBuilder<HealthRecord, HealthRecord, QSortThenBy> {
  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByCatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catId', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByCatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catId', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByRecordDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordDate', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy>
      thenByRecordDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordDate', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByRecordType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordType', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy>
      thenByRecordTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordType', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByVetClinic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetClinic', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByVetClinicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetClinic', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByVetName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetName', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByVetNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vetName', Sort.desc);
    });
  }
}

extension HealthRecordQueryWhereDistinct
    on QueryBuilder<HealthRecord, HealthRecord, QDistinct> {
  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByCatId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByRecordDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordDate');
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByRecordId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByRecordType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByVetClinic(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vetClinic', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByVetName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vetName', caseSensitive: caseSensitive);
    });
  }
}

extension HealthRecordQueryProperty
    on QueryBuilder<HealthRecord, HealthRecord, QQueryProperty> {
  QueryBuilder<HealthRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HealthRecord, String, QQueryOperations> catIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catId');
    });
  }

  QueryBuilder<HealthRecord, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<HealthRecord, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<HealthRecord, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<HealthRecord, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<HealthRecord, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<HealthRecord, DateTime, QQueryOperations> recordDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordDate');
    });
  }

  QueryBuilder<HealthRecord, String, QQueryOperations> recordIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordId');
    });
  }

  QueryBuilder<HealthRecord, String, QQueryOperations> recordTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordType');
    });
  }

  QueryBuilder<HealthRecord, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<HealthRecord, String?, QQueryOperations> vetClinicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vetClinic');
    });
  }

  QueryBuilder<HealthRecord, String?, QQueryOperations> vetNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vetName');
    });
  }
}
