// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'honesty_score_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHonestyScoreRecordCollection on Isar {
  IsarCollection<HonestyScoreRecord> get honestyScoreRecords =>
      this.collection();
}

const HonestyScoreRecordSchema = CollectionSchema(
  name: r'HonestyScoreRecord',
  id: -2623648424095714833,
  properties: {
    r'currentScore': PropertySchema(
      id: 0,
      name: r'currentScore',
      type: IsarType.long,
    ),
    r'historyJson': PropertySchema(
      id: 1,
      name: r'historyJson',
      type: IsarType.string,
    ),
    r'lastUpdated': PropertySchema(
      id: 2,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 3,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _honestyScoreRecordEstimateSize,
  serialize: _honestyScoreRecordSerialize,
  deserialize: _honestyScoreRecordDeserialize,
  deserializeProp: _honestyScoreRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _honestyScoreRecordGetId,
  getLinks: _honestyScoreRecordGetLinks,
  attach: _honestyScoreRecordAttach,
  version: '3.1.0+1',
);

int _honestyScoreRecordEstimateSize(
  HonestyScoreRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.historyJson.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _honestyScoreRecordSerialize(
  HonestyScoreRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currentScore);
  writer.writeString(offsets[1], object.historyJson);
  writer.writeDateTime(offsets[2], object.lastUpdated);
  writer.writeString(offsets[3], object.userId);
}

HonestyScoreRecord _honestyScoreRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HonestyScoreRecord();
  object.currentScore = reader.readLong(offsets[0]);
  object.historyJson = reader.readString(offsets[1]);
  object.id = id;
  object.lastUpdated = reader.readDateTime(offsets[2]);
  object.userId = reader.readString(offsets[3]);
  return object;
}

P _honestyScoreRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _honestyScoreRecordGetId(HonestyScoreRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _honestyScoreRecordGetLinks(
    HonestyScoreRecord object) {
  return [];
}

void _honestyScoreRecordAttach(
    IsarCollection<dynamic> col, Id id, HonestyScoreRecord object) {
  object.id = id;
}

extension HonestyScoreRecordByIndex on IsarCollection<HonestyScoreRecord> {
  Future<HonestyScoreRecord?> getByUserId(String userId) {
    return getByIndex(r'userId', [userId]);
  }

  HonestyScoreRecord? getByUserIdSync(String userId) {
    return getByIndexSync(r'userId', [userId]);
  }

  Future<bool> deleteByUserId(String userId) {
    return deleteByIndex(r'userId', [userId]);
  }

  bool deleteByUserIdSync(String userId) {
    return deleteByIndexSync(r'userId', [userId]);
  }

  Future<List<HonestyScoreRecord?>> getAllByUserId(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'userId', values);
  }

  List<HonestyScoreRecord?> getAllByUserIdSync(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'userId', values);
  }

  Future<int> deleteAllByUserId(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'userId', values);
  }

  int deleteAllByUserIdSync(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'userId', values);
  }

  Future<Id> putByUserId(HonestyScoreRecord object) {
    return putByIndex(r'userId', object);
  }

  Id putByUserIdSync(HonestyScoreRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'userId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUserId(List<HonestyScoreRecord> objects) {
    return putAllByIndex(r'userId', objects);
  }

  List<Id> putAllByUserIdSync(List<HonestyScoreRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'userId', objects, saveLinks: saveLinks);
  }
}

extension HonestyScoreRecordQueryWhereSort
    on QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QWhere> {
  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HonestyScoreRecordQueryWhere
    on QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QWhereClause> {
  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterWhereClause>
      userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterWhereClause>
      userIdNotEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension HonestyScoreRecordQueryFilter
    on QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QFilterCondition> {
  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      currentScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentScore',
        value: value,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      currentScoreGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentScore',
        value: value,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      currentScoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentScore',
        value: value,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      currentScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      historyJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'historyJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      historyJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'historyJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      historyJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'historyJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      historyJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'historyJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      historyJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'historyJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      historyJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'historyJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      historyJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'historyJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      historyJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'historyJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      historyJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'historyJson',
        value: '',
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      historyJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'historyJson',
        value: '',
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
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

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      idLessThan(
    Id value, {
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

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      lastUpdatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      lastUpdatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension HonestyScoreRecordQueryObject
    on QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QFilterCondition> {}

extension HonestyScoreRecordQueryLinks
    on QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QFilterCondition> {}

extension HonestyScoreRecordQuerySortBy
    on QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QSortBy> {
  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      sortByCurrentScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentScore', Sort.asc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      sortByCurrentScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentScore', Sort.desc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      sortByHistoryJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'historyJson', Sort.asc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      sortByHistoryJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'historyJson', Sort.desc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension HonestyScoreRecordQuerySortThenBy
    on QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QSortThenBy> {
  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      thenByCurrentScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentScore', Sort.asc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      thenByCurrentScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentScore', Sort.desc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      thenByHistoryJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'historyJson', Sort.asc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      thenByHistoryJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'historyJson', Sort.desc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension HonestyScoreRecordQueryWhereDistinct
    on QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QDistinct> {
  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QDistinct>
      distinctByCurrentScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentScore');
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QDistinct>
      distinctByHistoryJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'historyJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QDistinct>
      distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension HonestyScoreRecordQueryProperty
    on QueryBuilder<HonestyScoreRecord, HonestyScoreRecord, QQueryProperty> {
  QueryBuilder<HonestyScoreRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HonestyScoreRecord, int, QQueryOperations>
      currentScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentScore');
    });
  }

  QueryBuilder<HonestyScoreRecord, String, QQueryOperations>
      historyJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'historyJson');
    });
  }

  QueryBuilder<HonestyScoreRecord, DateTime, QQueryOperations>
      lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<HonestyScoreRecord, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
