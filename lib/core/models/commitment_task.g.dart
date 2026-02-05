// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commitment_task.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCommitmentTaskCollection on Isar {
  IsarCollection<CommitmentTask> get commitmentTasks => this.collection();
}

const CommitmentTaskSchema = CollectionSchema(
  name: r'CommitmentTask',
  id: -3679465518896559044,
  properties: {
    r'achievementScore': PropertySchema(
      id: 0,
      name: r'achievementScore',
      type: IsarType.double,
    ),
    r'companionLevel': PropertySchema(
      id: 1,
      name: r'companionLevel',
      type: IsarType.string,
      enumMap: _CommitmentTaskcompanionLevelEnumValueMap,
    ),
    r'completedAt': PropertySchema(
      id: 2,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'failedAt': PropertySchema(
      id: 4,
      name: r'failedAt',
      type: IsarType.dateTime,
    ),
    r'honestyBonus': PropertySchema(
      id: 5,
      name: r'honestyBonus',
      type: IsarType.double,
    ),
    r'isCompleted': PropertySchema(
      id: 6,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'isFailed': PropertySchema(
      id: 7,
      name: r'isFailed',
      type: IsarType.bool,
    ),
    r'isGoldenSuccess': PropertySchema(
      id: 8,
      name: r'isGoldenSuccess',
      type: IsarType.bool,
    ),
    r'midExecutionSupportAt': PropertySchema(
      id: 9,
      name: r'midExecutionSupportAt',
      type: IsarType.dateTime,
    ),
    r'postExecutionSupportAt': PropertySchema(
      id: 10,
      name: r'postExecutionSupportAt',
      type: IsarType.dateTime,
    ),
    r'preExecutionSupportAt': PropertySchema(
      id: 11,
      name: r'preExecutionSupportAt',
      type: IsarType.dateTime,
    ),
    r'scoreMultiplier': PropertySchema(
      id: 12,
      name: r'scoreMultiplier',
      type: IsarType.double,
    ),
    r'stakedGems': PropertySchema(
      id: 13,
      name: r'stakedGems',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 14,
      name: r'status',
      type: IsarType.string,
      enumMap: _CommitmentTaskstatusEnumValueMap,
    ),
    r'taskId': PropertySchema(
      id: 15,
      name: r'taskId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 16,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 17,
      name: r'userId',
      type: IsarType.string,
    ),
    r'wasHonestFailure': PropertySchema(
      id: 18,
      name: r'wasHonestFailure',
      type: IsarType.bool,
    )
  },
  estimateSize: _commitmentTaskEstimateSize,
  serialize: _commitmentTaskSerialize,
  deserialize: _commitmentTaskDeserialize,
  deserializeProp: _commitmentTaskDeserializeProp,
  idName: r'id',
  indexes: {
    r'taskId': IndexSchema(
      id: -6391211041487498726,
      name: r'taskId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'taskId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _commitmentTaskGetId,
  getLinks: _commitmentTaskGetLinks,
  attach: _commitmentTaskAttach,
  version: '3.1.0+1',
);

int _commitmentTaskEstimateSize(
  CommitmentTask object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.companionLevel.name.length * 3;
  bytesCount += 3 + object.status.name.length * 3;
  bytesCount += 3 + object.taskId.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _commitmentTaskSerialize(
  CommitmentTask object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.achievementScore);
  writer.writeString(offsets[1], object.companionLevel.name);
  writer.writeDateTime(offsets[2], object.completedAt);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeDateTime(offsets[4], object.failedAt);
  writer.writeDouble(offsets[5], object.honestyBonus);
  writer.writeBool(offsets[6], object.isCompleted);
  writer.writeBool(offsets[7], object.isFailed);
  writer.writeBool(offsets[8], object.isGoldenSuccess);
  writer.writeDateTime(offsets[9], object.midExecutionSupportAt);
  writer.writeDateTime(offsets[10], object.postExecutionSupportAt);
  writer.writeDateTime(offsets[11], object.preExecutionSupportAt);
  writer.writeDouble(offsets[12], object.scoreMultiplier);
  writer.writeLong(offsets[13], object.stakedGems);
  writer.writeString(offsets[14], object.status.name);
  writer.writeString(offsets[15], object.taskId);
  writer.writeDateTime(offsets[16], object.updatedAt);
  writer.writeString(offsets[17], object.userId);
  writer.writeBool(offsets[18], object.wasHonestFailure);
}

CommitmentTask _commitmentTaskDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CommitmentTask();
  object.achievementScore = reader.readDoubleOrNull(offsets[0]);
  object.companionLevel = _CommitmentTaskcompanionLevelValueEnumMap[
          reader.readStringOrNull(offsets[1])] ??
      AICompanionLevel.none;
  object.completedAt = reader.readDateTimeOrNull(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.failedAt = reader.readDateTimeOrNull(offsets[4]);
  object.honestyBonus = reader.readDoubleOrNull(offsets[5]);
  object.id = id;
  object.midExecutionSupportAt = reader.readDateTimeOrNull(offsets[9]);
  object.postExecutionSupportAt = reader.readDateTimeOrNull(offsets[10]);
  object.preExecutionSupportAt = reader.readDateTimeOrNull(offsets[11]);
  object.scoreMultiplier = reader.readDoubleOrNull(offsets[12]);
  object.stakedGems = reader.readLong(offsets[13]);
  object.status =
      _CommitmentTaskstatusValueEnumMap[reader.readStringOrNull(offsets[14])] ??
          CommitmentStatus.pending;
  object.taskId = reader.readString(offsets[15]);
  object.updatedAt = reader.readDateTime(offsets[16]);
  object.userId = reader.readString(offsets[17]);
  object.wasHonestFailure = reader.readBool(offsets[18]);
  return object;
}

P _commitmentTaskDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (_CommitmentTaskcompanionLevelValueEnumMap[
              reader.readStringOrNull(offset)] ??
          AICompanionLevel.none) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (reader.readDoubleOrNull(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (_CommitmentTaskstatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          CommitmentStatus.pending) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readDateTime(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CommitmentTaskcompanionLevelEnumValueMap = {
  r'none': r'none',
  r'quiet': r'quiet',
  r'moderate': r'moderate',
  r'intensive': r'intensive',
};
const _CommitmentTaskcompanionLevelValueEnumMap = {
  r'none': AICompanionLevel.none,
  r'quiet': AICompanionLevel.quiet,
  r'moderate': AICompanionLevel.moderate,
  r'intensive': AICompanionLevel.intensive,
};
const _CommitmentTaskstatusEnumValueMap = {
  r'pending': r'pending',
  r'inProgress': r'inProgress',
  r'completed': r'completed',
  r'failed': r'failed',
};
const _CommitmentTaskstatusValueEnumMap = {
  r'pending': CommitmentStatus.pending,
  r'inProgress': CommitmentStatus.inProgress,
  r'completed': CommitmentStatus.completed,
  r'failed': CommitmentStatus.failed,
};

Id _commitmentTaskGetId(CommitmentTask object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _commitmentTaskGetLinks(CommitmentTask object) {
  return [];
}

void _commitmentTaskAttach(
    IsarCollection<dynamic> col, Id id, CommitmentTask object) {
  object.id = id;
}

extension CommitmentTaskQueryWhereSort
    on QueryBuilder<CommitmentTask, CommitmentTask, QWhere> {
  QueryBuilder<CommitmentTask, CommitmentTask, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CommitmentTaskQueryWhere
    on QueryBuilder<CommitmentTask, CommitmentTask, QWhereClause> {
  QueryBuilder<CommitmentTask, CommitmentTask, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterWhereClause> idBetween(
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterWhereClause> taskIdEqualTo(
      String taskId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'taskId',
        value: [taskId],
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterWhereClause>
      taskIdNotEqualTo(String taskId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [],
              upper: [taskId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [taskId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [taskId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [],
              upper: [taskId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterWhereClause> userIdEqualTo(
      String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterWhereClause>
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

extension CommitmentTaskQueryFilter
    on QueryBuilder<CommitmentTask, CommitmentTask, QFilterCondition> {
  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      achievementScoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'achievementScore',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      achievementScoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'achievementScore',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      achievementScoreEqualTo(
    double? value, {
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      achievementScoreGreaterThan(
    double? value, {
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      achievementScoreLessThan(
    double? value, {
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      achievementScoreBetween(
    double? lower,
    double? upper, {
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      companionLevelEqualTo(
    AICompanionLevel value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companionLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      companionLevelGreaterThan(
    AICompanionLevel value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'companionLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      companionLevelLessThan(
    AICompanionLevel value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'companionLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      companionLevelBetween(
    AICompanionLevel lower,
    AICompanionLevel upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'companionLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      companionLevelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'companionLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      companionLevelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'companionLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      companionLevelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'companionLevel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      companionLevelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'companionLevel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      companionLevelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companionLevel',
        value: '',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      companionLevelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'companionLevel',
        value: '',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      failedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'failedAt',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      failedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'failedAt',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      failedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'failedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      failedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'failedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      failedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'failedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      failedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'failedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      honestyBonusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'honestyBonus',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      honestyBonusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'honestyBonus',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      honestyBonusEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'honestyBonus',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      honestyBonusGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'honestyBonus',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      honestyBonusLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'honestyBonus',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      honestyBonusBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'honestyBonus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      isFailedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFailed',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      isGoldenSuccessEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isGoldenSuccess',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      midExecutionSupportAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'midExecutionSupportAt',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      midExecutionSupportAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'midExecutionSupportAt',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      midExecutionSupportAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'midExecutionSupportAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      midExecutionSupportAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'midExecutionSupportAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      midExecutionSupportAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'midExecutionSupportAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      midExecutionSupportAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'midExecutionSupportAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      postExecutionSupportAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'postExecutionSupportAt',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      postExecutionSupportAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'postExecutionSupportAt',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      postExecutionSupportAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'postExecutionSupportAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      postExecutionSupportAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'postExecutionSupportAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      postExecutionSupportAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'postExecutionSupportAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      postExecutionSupportAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'postExecutionSupportAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      preExecutionSupportAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'preExecutionSupportAt',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      preExecutionSupportAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'preExecutionSupportAt',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      preExecutionSupportAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preExecutionSupportAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      preExecutionSupportAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'preExecutionSupportAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      preExecutionSupportAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'preExecutionSupportAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      preExecutionSupportAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'preExecutionSupportAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      scoreMultiplierIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scoreMultiplier',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      scoreMultiplierIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scoreMultiplier',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      scoreMultiplierEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scoreMultiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      scoreMultiplierGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scoreMultiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      scoreMultiplierLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scoreMultiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      scoreMultiplierBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scoreMultiplier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      stakedGemsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stakedGems',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      statusEqualTo(
    CommitmentStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      statusGreaterThan(
    CommitmentStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      statusLessThan(
    CommitmentStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      statusBetween(
    CommitmentStatus lower,
    CommitmentStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      taskIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      taskIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      taskIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: '',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      taskIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskId',
        value: '',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
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

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterFilterCondition>
      wasHonestFailureEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wasHonestFailure',
        value: value,
      ));
    });
  }
}

extension CommitmentTaskQueryObject
    on QueryBuilder<CommitmentTask, CommitmentTask, QFilterCondition> {}

extension CommitmentTaskQueryLinks
    on QueryBuilder<CommitmentTask, CommitmentTask, QFilterCondition> {}

extension CommitmentTaskQuerySortBy
    on QueryBuilder<CommitmentTask, CommitmentTask, QSortBy> {
  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByAchievementScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievementScore', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByAchievementScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievementScore', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByCompanionLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companionLevel', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByCompanionLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companionLevel', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> sortByFailedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedAt', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByFailedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedAt', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByHonestyBonus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'honestyBonus', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByHonestyBonusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'honestyBonus', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> sortByIsFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFailed', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByIsFailedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFailed', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByIsGoldenSuccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGoldenSuccess', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByIsGoldenSuccessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGoldenSuccess', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByMidExecutionSupportAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'midExecutionSupportAt', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByMidExecutionSupportAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'midExecutionSupportAt', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByPostExecutionSupportAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postExecutionSupportAt', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByPostExecutionSupportAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postExecutionSupportAt', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByPreExecutionSupportAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preExecutionSupportAt', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByPreExecutionSupportAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preExecutionSupportAt', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByScoreMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreMultiplier', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByScoreMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreMultiplier', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByStakedGems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedGems', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByStakedGemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedGems', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> sortByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByWasHonestFailure() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasHonestFailure', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      sortByWasHonestFailureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasHonestFailure', Sort.desc);
    });
  }
}

extension CommitmentTaskQuerySortThenBy
    on QueryBuilder<CommitmentTask, CommitmentTask, QSortThenBy> {
  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByAchievementScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievementScore', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByAchievementScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'achievementScore', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByCompanionLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companionLevel', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByCompanionLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companionLevel', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> thenByFailedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedAt', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByFailedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedAt', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByHonestyBonus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'honestyBonus', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByHonestyBonusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'honestyBonus', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> thenByIsFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFailed', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByIsFailedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFailed', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByIsGoldenSuccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGoldenSuccess', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByIsGoldenSuccessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGoldenSuccess', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByMidExecutionSupportAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'midExecutionSupportAt', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByMidExecutionSupportAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'midExecutionSupportAt', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByPostExecutionSupportAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postExecutionSupportAt', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByPostExecutionSupportAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postExecutionSupportAt', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByPreExecutionSupportAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preExecutionSupportAt', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByPreExecutionSupportAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preExecutionSupportAt', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByScoreMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreMultiplier', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByScoreMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scoreMultiplier', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByStakedGems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedGems', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByStakedGemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedGems', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> thenByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByWasHonestFailure() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasHonestFailure', Sort.asc);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QAfterSortBy>
      thenByWasHonestFailureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasHonestFailure', Sort.desc);
    });
  }
}

extension CommitmentTaskQueryWhereDistinct
    on QueryBuilder<CommitmentTask, CommitmentTask, QDistinct> {
  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct>
      distinctByAchievementScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'achievementScore');
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct>
      distinctByCompanionLevel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companionLevel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct> distinctByFailedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'failedAt');
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct>
      distinctByHonestyBonus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'honestyBonus');
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct> distinctByIsFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFailed');
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct>
      distinctByIsGoldenSuccess() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isGoldenSuccess');
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct>
      distinctByMidExecutionSupportAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'midExecutionSupportAt');
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct>
      distinctByPostExecutionSupportAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'postExecutionSupportAt');
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct>
      distinctByPreExecutionSupportAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preExecutionSupportAt');
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct>
      distinctByScoreMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scoreMultiplier');
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct>
      distinctByStakedGems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stakedGems');
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct> distinctByTaskId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CommitmentTask, CommitmentTask, QDistinct>
      distinctByWasHonestFailure() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wasHonestFailure');
    });
  }
}

extension CommitmentTaskQueryProperty
    on QueryBuilder<CommitmentTask, CommitmentTask, QQueryProperty> {
  QueryBuilder<CommitmentTask, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CommitmentTask, double?, QQueryOperations>
      achievementScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'achievementScore');
    });
  }

  QueryBuilder<CommitmentTask, AICompanionLevel, QQueryOperations>
      companionLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companionLevel');
    });
  }

  QueryBuilder<CommitmentTask, DateTime?, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<CommitmentTask, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CommitmentTask, DateTime?, QQueryOperations> failedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'failedAt');
    });
  }

  QueryBuilder<CommitmentTask, double?, QQueryOperations>
      honestyBonusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'honestyBonus');
    });
  }

  QueryBuilder<CommitmentTask, bool, QQueryOperations> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<CommitmentTask, bool, QQueryOperations> isFailedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFailed');
    });
  }

  QueryBuilder<CommitmentTask, bool, QQueryOperations>
      isGoldenSuccessProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isGoldenSuccess');
    });
  }

  QueryBuilder<CommitmentTask, DateTime?, QQueryOperations>
      midExecutionSupportAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'midExecutionSupportAt');
    });
  }

  QueryBuilder<CommitmentTask, DateTime?, QQueryOperations>
      postExecutionSupportAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'postExecutionSupportAt');
    });
  }

  QueryBuilder<CommitmentTask, DateTime?, QQueryOperations>
      preExecutionSupportAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preExecutionSupportAt');
    });
  }

  QueryBuilder<CommitmentTask, double?, QQueryOperations>
      scoreMultiplierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scoreMultiplier');
    });
  }

  QueryBuilder<CommitmentTask, int, QQueryOperations> stakedGemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stakedGems');
    });
  }

  QueryBuilder<CommitmentTask, CommitmentStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<CommitmentTask, String, QQueryOperations> taskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskId');
    });
  }

  QueryBuilder<CommitmentTask, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<CommitmentTask, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<CommitmentTask, bool, QQueryOperations>
      wasHonestFailureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wasHonestFailure');
    });
  }
}
