// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'golden_success.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGoldenSuccessCollection on Isar {
  IsarCollection<GoldenSuccess> get goldenSuccess => this.collection();
}

const GoldenSuccessSchema = CollectionSchema(
  name: r'GoldenSuccess',
  id: 8450828179702062862,
  properties: {
    r'achievedAt': PropertySchema(
      id: 0,
      name: r'achievedAt',
      type: IsarType.dateTime,
    ),
    r'achievementScore': PropertySchema(
      id: 1,
      name: r'achievementScore',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'emotionAtCompletion': PropertySchema(
      id: 3,
      name: r'emotionAtCompletion',
      type: IsarType.string,
    ),
    r'encryptedCompanionLog': PropertySchema(
      id: 4,
      name: r'encryptedCompanionLog',
      type: IsarType.string,
    ),
    r'encryptedReflection': PropertySchema(
      id: 5,
      name: r'encryptedReflection',
      type: IsarType.string,
    ),
    r'isAchievedThisWeek': PropertySchema(
      id: 6,
      name: r'isAchievedThisWeek',
      type: IsarType.bool,
    ),
    r'isAchievedToday': PropertySchema(
      id: 7,
      name: r'isAchievedToday',
      type: IsarType.bool,
    ),
    r'stakedGems': PropertySchema(
      id: 8,
      name: r'stakedGems',
      type: IsarType.long,
    ),
    r'taskDescription': PropertySchema(
      id: 9,
      name: r'taskDescription',
      type: IsarType.string,
    ),
    r'taskId': PropertySchema(
      id: 10,
      name: r'taskId',
      type: IsarType.string,
    ),
    r'taskTitle': PropertySchema(
      id: 11,
      name: r'taskTitle',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(
      id: 12,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _goldenSuccessEstimateSize,
  serialize: _goldenSuccessSerialize,
  deserialize: _goldenSuccessDeserialize,
  deserializeProp: _goldenSuccessDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'achievedAt': IndexSchema(
      id: 3411637004514434470,
      name: r'achievedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'achievedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _goldenSuccessGetId,
  getLinks: _goldenSuccessGetLinks,
  attach: _goldenSuccessAttach,
  version: '3.1.0+1',
);

int _goldenSuccessEstimateSize(
  GoldenSuccess object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.emotionAtCompletion;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.encryptedCompanionLog;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.encryptedReflection;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.taskDescription;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.taskId.length * 3;
  bytesCount += 3 + object.taskTitle.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _goldenSuccessSerialize(
  GoldenSuccess object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.achievedAt);
  writer.writeDouble(offsets[1], object.achievementScore);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.emotionAtCompletion);
  writer.writeString(offsets[4], object.encryptedCompanionLog);
  writer.writeString(offsets[5], object.encryptedReflection);
  writer.writeBool(offsets[6], object.isAchievedThisWeek);
  writer.writeBool(offsets[7], object.isAchievedToday);
  writer.writeLong(offsets[8], object.stakedGems);
  writer.writeString(offsets[9], object.taskDescription);
  writer.writeString(offsets[10], object.taskId);
  writer.writeString(offsets[11], object.taskTitle);
  writer.writeString(offsets[12], object.userId);
}

GoldenSuccess _goldenSuccessDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GoldenSuccess();
  object.achievedAt = reader.readDateTime(offsets[0]);
  object.achievementScore = reader.readDouble(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.emotionAtCompletion = reader.readStringOrNull(offsets[3]);
  object.encryptedCompanionLog = reader.readStringOrNull(offsets[4]);
  object.encryptedReflection = reader.readStringOrNull(offsets[5]);
  object.id = id;
  object.stakedGems = reader.readLong(offsets[8]);
  object.taskDescription = reader.readStringOrNull(offsets[9]);
  object.taskId = reader.readString(offsets[10]);
  object.taskTitle = reader.readString(offsets[11]);
  object.userId = reader.readString(offsets[12]);
  return object;
}

P _goldenSuccessDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _goldenSuccessGetId(GoldenSuccess object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _goldenSuccessGetLinks(GoldenSuccess object) {
  return [];
}

void _goldenSuccessAttach(
    IsarCollection<dynamic> col, Id id, GoldenSuccess object) {
  object.id = id;
}

extension GoldenSuccessQueryWhereSort
    on QueryBuilder<GoldenSuccess, GoldenSuccess, QWhere> {
  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterWhere> anyAchievedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'achievedAt'),
      );
    });
  }
}

extension GoldenSuccessQueryWhere
    on QueryBuilder<GoldenSuccess, GoldenSuccess, QWhereClause> {
  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterWhereClause> idBetween(
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

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterWhereClause> userIdEqualTo(
      String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterWhereClause>
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

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterWhereClause>
      achievedAtEqualTo(DateTime achievedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'achievedAt',
        value: [achievedAt],
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterWhereClause>
      achievedAtNotEqualTo(DateTime achievedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'achievedAt',
              lower: [],
              upper: [achievedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'achievedAt',
              lower: [achievedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'achievedAt',
              lower: [achievedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'achievedAt',
              lower: [],
              upper: [achievedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterWhereClause>
      achievedAtGreaterThan(
    DateTime achievedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'achievedAt',
        lower: [achievedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterWhereClause>
      achievedAtLessThan(
    DateTime achievedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'achievedAt',
        lower: [],
        upper: [achievedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterWhereClause>
      achievedAtBetween(
    DateTime lowerAchievedAt,
    DateTime upperAchievedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'achievedAt',
        lower: [lowerAchievedAt],
        includeLower: includeLower,
        upper: [upperAchievedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GoldenSuccessQueryFilter
    on QueryBuilder<GoldenSuccess, GoldenSuccess, QFilterCondition> {
  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      achievedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'achievedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      achievedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'achievedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      achievedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'achievedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      achievedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'achievedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      achievementScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'achievementScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      achievementScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'achievementScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      achievementScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'achievementScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      achievementScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'achievementScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
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

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
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

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
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

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      emotionAtCompletionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'emotionAtCompletion',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      emotionAtCompletionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'emotionAtCompletion',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      emotionAtCompletionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emotionAtCompletion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      emotionAtCompletionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emotionAtCompletion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      emotionAtCompletionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emotionAtCompletion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      emotionAtCompletionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emotionAtCompletion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      emotionAtCompletionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'emotionAtCompletion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      emotionAtCompletionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'emotionAtCompletion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      emotionAtCompletionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emotionAtCompletion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      emotionAtCompletionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emotionAtCompletion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      emotionAtCompletionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emotionAtCompletion',
        value: '',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      emotionAtCompletionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emotionAtCompletion',
        value: '',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedCompanionLogIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'encryptedCompanionLog',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedCompanionLogIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'encryptedCompanionLog',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedCompanionLogEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedCompanionLog',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedCompanionLogGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'encryptedCompanionLog',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedCompanionLogLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'encryptedCompanionLog',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedCompanionLogBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'encryptedCompanionLog',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedCompanionLogStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'encryptedCompanionLog',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedCompanionLogEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'encryptedCompanionLog',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedCompanionLogContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedCompanionLog',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedCompanionLogMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedCompanionLog',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedCompanionLogIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedCompanionLog',
        value: '',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedCompanionLogIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedCompanionLog',
        value: '',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedReflectionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'encryptedReflection',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedReflectionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'encryptedReflection',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedReflectionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedReflectionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'encryptedReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedReflectionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'encryptedReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedReflectionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'encryptedReflection',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedReflectionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'encryptedReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedReflectionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'encryptedReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedReflectionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedReflectionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedReflection',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedReflectionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedReflection',
        value: '',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      encryptedReflectionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedReflection',
        value: '',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
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

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition> idBetween(
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

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      isAchievedThisWeekEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAchievedThisWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      isAchievedTodayEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAchievedToday',
        value: value,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      stakedGemsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stakedGems',
        value: value,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      stakedGemsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stakedGems',
        value: value,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      stakedGemsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stakedGems',
        value: value,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      stakedGemsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stakedGems',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskDescriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taskDescription',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskDescriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taskDescription',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskDescriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskDescriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskDescriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskDescriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: '',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskId',
        value: '',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      taskTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
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

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
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

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
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

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
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

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
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

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
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

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension GoldenSuccessQueryObject
    on QueryBuilder<GoldenSuccess, GoldenSuccess, QFilterCondition> {}

extension GoldenSuccessQueryLinks
    on QueryBuilder<GoldenSuccess, GoldenSuccess, QFilterCondition> {}

extension GoldenSuccessQuerySortBy
    on QueryBuilder<GoldenSuccess, GoldenSuccess, QSortBy> {
  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> sortByAchievedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievedAt', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByAchievedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievedAt', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByAchievementScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievementScore', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByAchievementScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievementScore', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByEmotionAtCompletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionAtCompletion', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByEmotionAtCompletionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionAtCompletion', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByEncryptedCompanionLog() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedCompanionLog', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByEncryptedCompanionLogDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedCompanionLog', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByEncryptedReflection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedReflection', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByEncryptedReflectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedReflection', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByIsAchievedThisWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAchievedThisWeek', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByIsAchievedThisWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAchievedThisWeek', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByIsAchievedToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAchievedToday', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByIsAchievedTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAchievedToday', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> sortByStakedGems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedGems', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByStakedGemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedGems', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByTaskDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDescription', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByTaskDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDescription', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> sortByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> sortByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> sortByTaskTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      sortByTaskTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension GoldenSuccessQuerySortThenBy
    on QueryBuilder<GoldenSuccess, GoldenSuccess, QSortThenBy> {
  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> thenByAchievedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievedAt', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByAchievedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievedAt', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByAchievementScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievementScore', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByAchievementScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievementScore', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByEmotionAtCompletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionAtCompletion', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByEmotionAtCompletionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionAtCompletion', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByEncryptedCompanionLog() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedCompanionLog', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByEncryptedCompanionLogDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedCompanionLog', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByEncryptedReflection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedReflection', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByEncryptedReflectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedReflection', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByIsAchievedThisWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAchievedThisWeek', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByIsAchievedThisWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAchievedThisWeek', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByIsAchievedToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAchievedToday', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByIsAchievedTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAchievedToday', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> thenByStakedGems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedGems', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByStakedGemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedGems', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByTaskDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDescription', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByTaskDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskDescription', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> thenByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> thenByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> thenByTaskTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy>
      thenByTaskTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskTitle', Sort.desc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension GoldenSuccessQueryWhereDistinct
    on QueryBuilder<GoldenSuccess, GoldenSuccess, QDistinct> {
  QueryBuilder<GoldenSuccess, GoldenSuccess, QDistinct> distinctByAchievedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'achievedAt');
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QDistinct>
      distinctByAchievementScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'achievementScore');
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QDistinct>
      distinctByEmotionAtCompletion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emotionAtCompletion',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QDistinct>
      distinctByEncryptedCompanionLog({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedCompanionLog',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QDistinct>
      distinctByEncryptedReflection({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedReflection',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QDistinct>
      distinctByIsAchievedThisWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAchievedThisWeek');
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QDistinct>
      distinctByIsAchievedToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAchievedToday');
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QDistinct> distinctByStakedGems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stakedGems');
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QDistinct>
      distinctByTaskDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QDistinct> distinctByTaskId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QDistinct> distinctByTaskTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GoldenSuccess, GoldenSuccess, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension GoldenSuccessQueryProperty
    on QueryBuilder<GoldenSuccess, GoldenSuccess, QQueryProperty> {
  QueryBuilder<GoldenSuccess, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GoldenSuccess, DateTime, QQueryOperations> achievedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'achievedAt');
    });
  }

  QueryBuilder<GoldenSuccess, double, QQueryOperations>
      achievementScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'achievementScore');
    });
  }

  QueryBuilder<GoldenSuccess, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<GoldenSuccess, String?, QQueryOperations>
      emotionAtCompletionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emotionAtCompletion');
    });
  }

  QueryBuilder<GoldenSuccess, String?, QQueryOperations>
      encryptedCompanionLogProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedCompanionLog');
    });
  }

  QueryBuilder<GoldenSuccess, String?, QQueryOperations>
      encryptedReflectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedReflection');
    });
  }

  QueryBuilder<GoldenSuccess, bool, QQueryOperations>
      isAchievedThisWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAchievedThisWeek');
    });
  }

  QueryBuilder<GoldenSuccess, bool, QQueryOperations>
      isAchievedTodayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAchievedToday');
    });
  }

  QueryBuilder<GoldenSuccess, int, QQueryOperations> stakedGemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stakedGems');
    });
  }

  QueryBuilder<GoldenSuccess, String?, QQueryOperations>
      taskDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskDescription');
    });
  }

  QueryBuilder<GoldenSuccess, String, QQueryOperations> taskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskId');
    });
  }

  QueryBuilder<GoldenSuccess, String, QQueryOperations> taskTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskTitle');
    });
  }

  QueryBuilder<GoldenSuccess, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
