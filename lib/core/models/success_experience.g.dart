// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'success_experience.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSuccessExperienceCollection on Isar {
  IsarCollection<SuccessExperience> get successExperiences => this.collection();
}

const SuccessExperienceSchema = CollectionSchema(
  name: r'SuccessExperience',
  id: 7425184152231886,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'emotionAfter': PropertySchema(
      id: 2,
      name: r'emotionAfter',
      type: IsarType.string,
    ),
    r'emotionBefore': PropertySchema(
      id: 3,
      name: r'emotionBefore',
      type: IsarType.string,
    ),
    r'lastReferencedAt': PropertySchema(
      id: 4,
      name: r'lastReferencedAt',
      type: IsarType.dateTime,
    ),
    r'lessonsLearned': PropertySchema(
      id: 5,
      name: r'lessonsLearned',
      type: IsarType.string,
    ),
    r'referenceCount': PropertySchema(
      id: 6,
      name: r'referenceCount',
      type: IsarType.long,
    ),
    r'tagList': PropertySchema(
      id: 7,
      name: r'tagList',
      type: IsarType.stringList,
    ),
    r'tags': PropertySchema(
      id: 8,
      name: r'tags',
      type: IsarType.string,
    ),
    r'taskUuid': PropertySchema(
      id: 9,
      name: r'taskUuid',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 10,
      name: r'title',
      type: IsarType.string,
    ),
    r'userUuid': PropertySchema(
      id: 11,
      name: r'userUuid',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(
      id: 12,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _successExperienceEstimateSize,
  serialize: _successExperienceSerialize,
  deserialize: _successExperienceDeserialize,
  deserializeProp: _successExperienceDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 8698316308850860,
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
      id: 8659171062196520,
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
    r'createdAt': IndexSchema(
      id: 7214631323756360,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _successExperienceGetId,
  getLinks: _successExperienceGetLinks,
  attach: _successExperienceAttach,
  version: '3.1.0+1',
);

int _successExperienceEstimateSize(
  SuccessExperience object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  {
    final value = object.emotionAfter;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.emotionBefore;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lessonsLearned;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tagList.length * 3;
  {
    for (var i = 0; i < object.tagList.length; i++) {
      final value = object.tagList[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.tags;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.taskUuid;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.userUuid.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _successExperienceSerialize(
  SuccessExperience object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.description);
  writer.writeString(offsets[2], object.emotionAfter);
  writer.writeString(offsets[3], object.emotionBefore);
  writer.writeDateTime(offsets[4], object.lastReferencedAt);
  writer.writeString(offsets[5], object.lessonsLearned);
  writer.writeLong(offsets[6], object.referenceCount);
  writer.writeStringList(offsets[7], object.tagList);
  writer.writeString(offsets[8], object.tags);
  writer.writeString(offsets[9], object.taskUuid);
  writer.writeString(offsets[10], object.title);
  writer.writeString(offsets[11], object.userUuid);
  writer.writeString(offsets[12], object.uuid);
}

SuccessExperience _successExperienceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SuccessExperience();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.description = reader.readString(offsets[1]);
  object.emotionAfter = reader.readStringOrNull(offsets[2]);
  object.emotionBefore = reader.readStringOrNull(offsets[3]);
  object.id = id;
  object.lastReferencedAt = reader.readDateTimeOrNull(offsets[4]);
  object.lessonsLearned = reader.readStringOrNull(offsets[5]);
  object.referenceCount = reader.readLong(offsets[6]);
  object.tagList = reader.readStringList(offsets[7]) ?? [];
  object.tags = reader.readStringOrNull(offsets[8]);
  object.taskUuid = reader.readStringOrNull(offsets[9]);
  object.title = reader.readString(offsets[10]);
  object.userUuid = reader.readString(offsets[11]);
  object.uuid = reader.readString(offsets[12]);
  return object;
}

P _successExperienceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringList(offset) ?? []) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
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

Id _successExperienceGetId(SuccessExperience object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _successExperienceGetLinks(
    SuccessExperience object) {
  return [];
}

void _successExperienceAttach(
    IsarCollection<dynamic> col, Id id, SuccessExperience object) {
  object.id = id;
}

extension SuccessExperienceQueryWhereSort
    on QueryBuilder<SuccessExperience, SuccessExperience, QWhere> {
  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhere>
      anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension SuccessExperienceQueryWhere
    on QueryBuilder<SuccessExperience, SuccessExperience, QWhereClause> {
  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhereClause>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhereClause>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhereClause>
      uuidEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhereClause>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhereClause>
      userUuidEqualTo(String userUuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userUuid',
        value: [userUuid],
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhereClause>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhereClause>
      createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhereClause>
      createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhereClause>
      createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterWhereClause>
      createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SuccessExperienceQueryFilter
    on QueryBuilder<SuccessExperience, SuccessExperience, QFilterCondition> {
  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      descriptionEqualTo(
    String value, {
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      descriptionLessThan(
    String value, {
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      descriptionBetween(
    String lower,
    String upper, {
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionAfterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'emotionAfter',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionAfterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'emotionAfter',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionAfterEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emotionAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionAfterGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emotionAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionAfterLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emotionAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionAfterBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emotionAfter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionAfterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'emotionAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionAfterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'emotionAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionAfterContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emotionAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionAfterMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emotionAfter',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionAfterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emotionAfter',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionAfterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emotionAfter',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionBeforeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'emotionBefore',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionBeforeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'emotionBefore',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionBeforeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emotionBefore',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionBeforeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emotionBefore',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionBeforeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emotionBefore',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionBeforeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emotionBefore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionBeforeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'emotionBefore',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionBeforeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'emotionBefore',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionBeforeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emotionBefore',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionBeforeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emotionBefore',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionBeforeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emotionBefore',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      emotionBeforeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emotionBefore',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lastReferencedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastReferencedAt',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lastReferencedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastReferencedAt',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lastReferencedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReferencedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lastReferencedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReferencedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lastReferencedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReferencedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lastReferencedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReferencedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lessonsLearnedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lessonsLearned',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lessonsLearnedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lessonsLearned',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lessonsLearnedEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lessonsLearned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lessonsLearnedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lessonsLearned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lessonsLearnedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lessonsLearned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lessonsLearnedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lessonsLearned',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lessonsLearnedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lessonsLearned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lessonsLearnedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lessonsLearned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lessonsLearnedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lessonsLearned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lessonsLearnedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lessonsLearned',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lessonsLearnedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lessonsLearned',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      lessonsLearnedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lessonsLearned',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      referenceCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referenceCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      referenceCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'referenceCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      referenceCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'referenceCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      referenceCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'referenceCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tagList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tagList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tagList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tagList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tagList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tagList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tagList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagList',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tagList',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tags',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tags',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      tagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      taskUuidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taskUuid',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      taskUuidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taskUuid',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      taskUuidEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      taskUuidGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      taskUuidLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      taskUuidBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskUuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      taskUuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      taskUuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      taskUuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      taskUuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskUuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      taskUuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      taskUuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      userUuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      userUuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userUuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      userUuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      userUuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
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

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      uuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension SuccessExperienceQueryObject
    on QueryBuilder<SuccessExperience, SuccessExperience, QFilterCondition> {}

extension SuccessExperienceQueryLinks
    on QueryBuilder<SuccessExperience, SuccessExperience, QFilterCondition> {}

extension SuccessExperienceQuerySortBy
    on QueryBuilder<SuccessExperience, SuccessExperience, QSortBy> {
  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByEmotionAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionAfter', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByEmotionAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionAfter', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByEmotionBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionBefore', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByEmotionBeforeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionBefore', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByLastReferencedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReferencedAt', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByLastReferencedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReferencedAt', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByLessonsLearned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonsLearned', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByLessonsLearnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonsLearned', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByReferenceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceCount', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByReferenceCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceCount', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tags', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByTagsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tags', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByTaskUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskUuid', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByTaskUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskUuid', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByUserUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUuid', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByUserUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUuid', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension SuccessExperienceQuerySortThenBy
    on QueryBuilder<SuccessExperience, SuccessExperience, QSortThenBy> {
  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByEmotionAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionAfter', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByEmotionAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionAfter', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByEmotionBefore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionBefore', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByEmotionBeforeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionBefore', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByLastReferencedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReferencedAt', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByLastReferencedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReferencedAt', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByLessonsLearned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonsLearned', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByLessonsLearnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonsLearned', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByReferenceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceCount', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByReferenceCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceCount', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tags', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByTagsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tags', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByTaskUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskUuid', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByTaskUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskUuid', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByUserUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUuid', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByUserUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUuid', Sort.desc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QAfterSortBy>
      thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension SuccessExperienceQueryWhereDistinct
    on QueryBuilder<SuccessExperience, SuccessExperience, QDistinct> {
  QueryBuilder<SuccessExperience, SuccessExperience, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QDistinct>
      distinctByEmotionAfter({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emotionAfter', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QDistinct>
      distinctByEmotionBefore({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emotionBefore',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QDistinct>
      distinctByLastReferencedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReferencedAt');
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QDistinct>
      distinctByLessonsLearned({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lessonsLearned',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QDistinct>
      distinctByReferenceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'referenceCount');
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QDistinct>
      distinctByTagList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tagList');
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QDistinct> distinctByTags(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tags', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QDistinct>
      distinctByTaskUuid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskUuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QDistinct>
      distinctByUserUuid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userUuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SuccessExperience, SuccessExperience, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension SuccessExperienceQueryProperty
    on QueryBuilder<SuccessExperience, SuccessExperience, QQueryProperty> {
  QueryBuilder<SuccessExperience, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SuccessExperience, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<SuccessExperience, String, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<SuccessExperience, String?, QQueryOperations>
      emotionAfterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emotionAfter');
    });
  }

  QueryBuilder<SuccessExperience, String?, QQueryOperations>
      emotionBeforeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emotionBefore');
    });
  }

  QueryBuilder<SuccessExperience, DateTime?, QQueryOperations>
      lastReferencedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReferencedAt');
    });
  }

  QueryBuilder<SuccessExperience, String?, QQueryOperations>
      lessonsLearnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lessonsLearned');
    });
  }

  QueryBuilder<SuccessExperience, int, QQueryOperations>
      referenceCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referenceCount');
    });
  }

  QueryBuilder<SuccessExperience, List<String>, QQueryOperations>
      tagListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tagList');
    });
  }

  QueryBuilder<SuccessExperience, String?, QQueryOperations> tagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tags');
    });
  }

  QueryBuilder<SuccessExperience, String?, QQueryOperations>
      taskUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskUuid');
    });
  }

  QueryBuilder<SuccessExperience, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<SuccessExperience, String, QQueryOperations> userUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userUuid');
    });
  }

  QueryBuilder<SuccessExperience, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
