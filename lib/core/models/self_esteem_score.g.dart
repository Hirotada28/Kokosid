// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_esteem_score.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSelfEsteemScoreCollection on Isar {
  IsarCollection<SelfEsteemScore> get selfEsteemScores => this.collection();
}

const SelfEsteemScoreSchema = CollectionSchema(
  name: r'SelfEsteemScore',
  id: -6891320114721402583,
  properties: {
    r'calculationBasisJson': PropertySchema(
      id: 0,
      name: r'calculationBasisJson',
      type: IsarType.string,
    ),
    r'completionRate': PropertySchema(
      id: 1,
      name: r'completionRate',
      type: IsarType.double,
    ),
    r'engagementScore': PropertySchema(
      id: 2,
      name: r'engagementScore',
      type: IsarType.double,
    ),
    r'isToday': PropertySchema(
      id: 3,
      name: r'isToday',
      type: IsarType.bool,
    ),
    r'measuredAt': PropertySchema(
      id: 4,
      name: r'measuredAt',
      type: IsarType.dateTime,
    ),
    r'positiveEmotionRatio': PropertySchema(
      id: 5,
      name: r'positiveEmotionRatio',
      type: IsarType.double,
    ),
    r'score': PropertySchema(
      id: 6,
      name: r'score',
      type: IsarType.double,
    ),
    r'streakScore': PropertySchema(
      id: 7,
      name: r'streakScore',
      type: IsarType.double,
    ),
    r'userUuid': PropertySchema(
      id: 8,
      name: r'userUuid',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(
      id: 9,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _selfEsteemScoreEstimateSize,
  serialize: _selfEsteemScoreSerialize,
  deserialize: _selfEsteemScoreDeserialize,
  deserializeProp: _selfEsteemScoreDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'userUuid': IndexSchema(
      id: -2441299026227353304,
      name: r'userUuid',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userUuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'measuredAt': IndexSchema(
      id: -8950142462655383883,
      name: r'measuredAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'measuredAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _selfEsteemScoreGetId,
  getLinks: _selfEsteemScoreGetLinks,
  attach: _selfEsteemScoreAttach,
  version: '3.1.0+1',
);

int _selfEsteemScoreEstimateSize(
  SelfEsteemScore object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.calculationBasisJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.userUuid.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _selfEsteemScoreSerialize(
  SelfEsteemScore object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.calculationBasisJson);
  writer.writeDouble(offsets[1], object.completionRate);
  writer.writeDouble(offsets[2], object.engagementScore);
  writer.writeBool(offsets[3], object.isToday);
  writer.writeDateTime(offsets[4], object.measuredAt);
  writer.writeDouble(offsets[5], object.positiveEmotionRatio);
  writer.writeDouble(offsets[6], object.score);
  writer.writeDouble(offsets[7], object.streakScore);
  writer.writeString(offsets[8], object.userUuid);
  writer.writeString(offsets[9], object.uuid);
}

SelfEsteemScore _selfEsteemScoreDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SelfEsteemScore();
  object.calculationBasisJson = reader.readStringOrNull(offsets[0]);
  object.completionRate = reader.readDoubleOrNull(offsets[1]);
  object.engagementScore = reader.readDoubleOrNull(offsets[2]);
  object.id = id;
  object.measuredAt = reader.readDateTime(offsets[4]);
  object.positiveEmotionRatio = reader.readDoubleOrNull(offsets[5]);
  object.score = reader.readDouble(offsets[6]);
  object.streakScore = reader.readDoubleOrNull(offsets[7]);
  object.userUuid = reader.readString(offsets[8]);
  object.uuid = reader.readString(offsets[9]);
  return object;
}

P _selfEsteemScoreDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _selfEsteemScoreGetId(SelfEsteemScore object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _selfEsteemScoreGetLinks(SelfEsteemScore object) {
  return [];
}

void _selfEsteemScoreAttach(
    IsarCollection<dynamic> col, Id id, SelfEsteemScore object) {
  object.id = id;
}

extension SelfEsteemScoreQueryWhereSort
    on QueryBuilder<SelfEsteemScore, SelfEsteemScore, QWhere> {
  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhere> anyMeasuredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'measuredAt'),
      );
    });
  }
}

extension SelfEsteemScoreQueryWhere
    on QueryBuilder<SelfEsteemScore, SelfEsteemScore, QWhereClause> {
  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhereClause>
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

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhereClause> idBetween(
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

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhereClause> uuidEqualTo(
      String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhereClause>
      uuidNotEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhereClause>
      userUuidEqualTo(String userUuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userUuid',
        value: [userUuid],
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhereClause>
      userUuidNotEqualTo(String userUuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userUuid',
              lower: [],
              upper: [userUuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userUuid',
              lower: [userUuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userUuid',
              lower: [userUuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userUuid',
              lower: [],
              upper: [userUuid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhereClause>
      measuredAtEqualTo(DateTime measuredAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'measuredAt',
        value: [measuredAt],
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhereClause>
      measuredAtNotEqualTo(DateTime measuredAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'measuredAt',
              lower: [],
              upper: [measuredAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'measuredAt',
              lower: [measuredAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'measuredAt',
              lower: [measuredAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'measuredAt',
              lower: [],
              upper: [measuredAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhereClause>
      measuredAtGreaterThan(
    DateTime measuredAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'measuredAt',
        lower: [measuredAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhereClause>
      measuredAtLessThan(
    DateTime measuredAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'measuredAt',
        lower: [],
        upper: [measuredAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterWhereClause>
      measuredAtBetween(
    DateTime lowerMeasuredAt,
    DateTime upperMeasuredAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'measuredAt',
        lower: [lowerMeasuredAt],
        includeLower: includeLower,
        upper: [upperMeasuredAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SelfEsteemScoreQueryFilter
    on QueryBuilder<SelfEsteemScore, SelfEsteemScore, QFilterCondition> {
  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      calculationBasisJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'calculationBasisJson',
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      calculationBasisJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'calculationBasisJson',
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      calculationBasisJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calculationBasisJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      calculationBasisJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calculationBasisJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      calculationBasisJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calculationBasisJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      calculationBasisJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calculationBasisJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      calculationBasisJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'calculationBasisJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      calculationBasisJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'calculationBasisJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      calculationBasisJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'calculationBasisJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      calculationBasisJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'calculationBasisJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      calculationBasisJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calculationBasisJson',
        value: '',
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      calculationBasisJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'calculationBasisJson',
        value: '',
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      completionRateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completionRate',
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      completionRateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completionRate',
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      completionRateEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completionRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      completionRateGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completionRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      completionRateLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completionRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      completionRateBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completionRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      engagementScoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'engagementScore',
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      engagementScoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'engagementScore',
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      engagementScoreEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'engagementScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      engagementScoreGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'engagementScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      engagementScoreLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'engagementScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      engagementScoreBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'engagementScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
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

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
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

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
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

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      isTodayEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isToday',
        value: value,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      measuredAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'measuredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      measuredAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'measuredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      measuredAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'measuredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      measuredAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'measuredAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      positiveEmotionRatioIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'positiveEmotionRatio',
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      positiveEmotionRatioIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'positiveEmotionRatio',
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      positiveEmotionRatioEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'positiveEmotionRatio',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      positiveEmotionRatioGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'positiveEmotionRatio',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      positiveEmotionRatioLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'positiveEmotionRatio',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      positiveEmotionRatioBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'positiveEmotionRatio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      scoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'score',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      scoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'score',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      scoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'score',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      scoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'score',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      streakScoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'streakScore',
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      streakScoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'streakScore',
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      streakScoreEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'streakScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      streakScoreGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'streakScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      streakScoreLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'streakScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      streakScoreBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'streakScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      userUuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      userUuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      userUuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      userUuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userUuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      userUuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      userUuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      userUuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      userUuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userUuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      userUuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      userUuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      uuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension SelfEsteemScoreQueryObject
    on QueryBuilder<SelfEsteemScore, SelfEsteemScore, QFilterCondition> {}

extension SelfEsteemScoreQueryLinks
    on QueryBuilder<SelfEsteemScore, SelfEsteemScore, QFilterCondition> {}

extension SelfEsteemScoreQuerySortBy
    on QueryBuilder<SelfEsteemScore, SelfEsteemScore, QSortBy> {
  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByCalculationBasisJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculationBasisJson', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByCalculationBasisJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculationBasisJson', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByCompletionRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRate', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByCompletionRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRate', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByEngagementScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engagementScore', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByEngagementScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engagementScore', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy> sortByIsToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isToday', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByIsTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isToday', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByMeasuredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measuredAt', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByMeasuredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measuredAt', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByPositiveEmotionRatio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positiveEmotionRatio', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByPositiveEmotionRatioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positiveEmotionRatio', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy> sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByStreakScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakScore', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByStreakScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakScore', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByUserUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUuid', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByUserUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUuid', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension SelfEsteemScoreQuerySortThenBy
    on QueryBuilder<SelfEsteemScore, SelfEsteemScore, QSortThenBy> {
  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByCalculationBasisJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculationBasisJson', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByCalculationBasisJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculationBasisJson', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByCompletionRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRate', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByCompletionRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRate', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByEngagementScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engagementScore', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByEngagementScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engagementScore', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy> thenByIsToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isToday', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByIsTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isToday', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByMeasuredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measuredAt', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByMeasuredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measuredAt', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByPositiveEmotionRatio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positiveEmotionRatio', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByPositiveEmotionRatioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positiveEmotionRatio', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy> thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByStreakScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakScore', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByStreakScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakScore', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByUserUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUuid', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByUserUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUuid', Sort.desc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QAfterSortBy>
      thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension SelfEsteemScoreQueryWhereDistinct
    on QueryBuilder<SelfEsteemScore, SelfEsteemScore, QDistinct> {
  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QDistinct>
      distinctByCalculationBasisJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calculationBasisJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QDistinct>
      distinctByCompletionRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completionRate');
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QDistinct>
      distinctByEngagementScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'engagementScore');
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QDistinct>
      distinctByIsToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isToday');
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QDistinct>
      distinctByMeasuredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'measuredAt');
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QDistinct>
      distinctByPositiveEmotionRatio() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'positiveEmotionRatio');
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QDistinct> distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QDistinct>
      distinctByStreakScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streakScore');
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QDistinct> distinctByUserUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userUuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SelfEsteemScore, SelfEsteemScore, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension SelfEsteemScoreQueryProperty
    on QueryBuilder<SelfEsteemScore, SelfEsteemScore, QQueryProperty> {
  QueryBuilder<SelfEsteemScore, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SelfEsteemScore, String?, QQueryOperations>
      calculationBasisJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calculationBasisJson');
    });
  }

  QueryBuilder<SelfEsteemScore, double?, QQueryOperations>
      completionRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completionRate');
    });
  }

  QueryBuilder<SelfEsteemScore, double?, QQueryOperations>
      engagementScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'engagementScore');
    });
  }

  QueryBuilder<SelfEsteemScore, bool, QQueryOperations> isTodayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isToday');
    });
  }

  QueryBuilder<SelfEsteemScore, DateTime, QQueryOperations>
      measuredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'measuredAt');
    });
  }

  QueryBuilder<SelfEsteemScore, double?, QQueryOperations>
      positiveEmotionRatioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'positiveEmotionRatio');
    });
  }

  QueryBuilder<SelfEsteemScore, double, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }

  QueryBuilder<SelfEsteemScore, double?, QQueryOperations>
      streakScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streakScore');
    });
  }

  QueryBuilder<SelfEsteemScore, String, QQueryOperations> userUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userUuid');
    });
  }

  QueryBuilder<SelfEsteemScore, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
