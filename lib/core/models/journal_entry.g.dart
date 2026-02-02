// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetJournalEntryCollection on Isar {
  IsarCollection<JournalEntry> get journalEntrys => this.collection();
}

const JournalEntrySchema = CollectionSchema(
  name: r'JournalEntry',
  id: 5342179754485350,
  properties: {
    r'aiReflection': PropertySchema(
      id: 0,
      name: r'aiReflection',
      type: IsarType.string,
    ),
    r'audioUrl': PropertySchema(
      id: 1,
      name: r'audioUrl',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'emotionConfidence': PropertySchema(
      id: 3,
      name: r'emotionConfidence',
      type: IsarType.double,
    ),
    r'emotionDetected': PropertySchema(
      id: 4,
      name: r'emotionDetected',
      type: IsarType.string,
      enumMap: _JournalEntryemotionDetectedEnumValueMap,
    ),
    r'encryptedAiResponse': PropertySchema(
      id: 5,
      name: r'encryptedAiResponse',
      type: IsarType.string,
    ),
    r'encryptedContent': PropertySchema(
      id: 6,
      name: r'encryptedContent',
      type: IsarType.string,
    ),
    r'isEncrypted': PropertySchema(
      id: 7,
      name: r'isEncrypted',
      type: IsarType.bool,
    ),
    r'isToday': PropertySchema(
      id: 8,
      name: r'isToday',
      type: IsarType.bool,
    ),
    r'syncedAt': PropertySchema(
      id: 9,
      name: r'syncedAt',
      type: IsarType.dateTime,
    ),
    r'transcription': PropertySchema(
      id: 10,
      name: r'transcription',
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
  estimateSize: _journalEntryEstimateSize,
  serialize: _journalEntrySerialize,
  deserialize: _journalEntryDeserialize,
  deserializeProp: _journalEntryDeserializeProp,
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
  getId: _journalEntryGetId,
  getLinks: _journalEntryGetLinks,
  attach: _journalEntryAttach,
  version: '3.1.0+1',
);

int _journalEntryEstimateSize(
  JournalEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.aiReflection;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.audioUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.emotionDetected;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.encryptedAiResponse;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.encryptedContent;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.transcription;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.userUuid.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _journalEntrySerialize(
  JournalEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.aiReflection);
  writer.writeString(offsets[1], object.audioUrl);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeDouble(offsets[3], object.emotionConfidence);
  writer.writeString(offsets[4], object.emotionDetected?.name);
  writer.writeString(offsets[5], object.encryptedAiResponse);
  writer.writeString(offsets[6], object.encryptedContent);
  writer.writeBool(offsets[7], object.isEncrypted);
  writer.writeBool(offsets[8], object.isToday);
  writer.writeDateTime(offsets[9], object.syncedAt);
  writer.writeString(offsets[10], object.transcription);
  writer.writeString(offsets[11], object.userUuid);
  writer.writeString(offsets[12], object.uuid);
}

JournalEntry _journalEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = JournalEntry();
  object.aiReflection = reader.readStringOrNull(offsets[0]);
  object.audioUrl = reader.readStringOrNull(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.emotionConfidence = reader.readDoubleOrNull(offsets[3]);
  object.emotionDetected = _JournalEntryemotionDetectedValueEnumMap[
      reader.readStringOrNull(offsets[4])];
  object.encryptedAiResponse = reader.readStringOrNull(offsets[5]);
  object.encryptedContent = reader.readStringOrNull(offsets[6]);
  object.id = id;
  object.isEncrypted = reader.readBool(offsets[7]);
  object.syncedAt = reader.readDateTimeOrNull(offsets[9]);
  object.transcription = reader.readStringOrNull(offsets[10]);
  object.userUuid = reader.readString(offsets[11]);
  object.uuid = reader.readString(offsets[12]);
  return object;
}

P _journalEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (_JournalEntryemotionDetectedValueEnumMap[
          reader.readStringOrNull(offset)]) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _JournalEntryemotionDetectedEnumValueMap = {
  r'happy': r'happy',
  r'sad': r'sad',
  r'angry': r'angry',
  r'anxious': r'anxious',
  r'tired': r'tired',
  r'neutral': r'neutral',
};
const _JournalEntryemotionDetectedValueEnumMap = {
  r'happy': EmotionType.happy,
  r'sad': EmotionType.sad,
  r'angry': EmotionType.angry,
  r'anxious': EmotionType.anxious,
  r'tired': EmotionType.tired,
  r'neutral': EmotionType.neutral,
};

Id _journalEntryGetId(JournalEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _journalEntryGetLinks(JournalEntry object) {
  return [];
}

void _journalEntryAttach(
    IsarCollection<dynamic> col, Id id, JournalEntry object) {
  object.id = id;
}

extension JournalEntryQueryWhereSort
    on QueryBuilder<JournalEntry, JournalEntry, QWhere> {
  QueryBuilder<JournalEntry, JournalEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension JournalEntryQueryWhere
    on QueryBuilder<JournalEntry, JournalEntry, QWhereClause> {
  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> idBetween(
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> uuidEqualTo(
      String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> uuidNotEqualTo(
      String uuid) {
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> userUuidEqualTo(
      String userUuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userUuid',
        value: [userUuid],
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause>
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> createdAtEqualTo(
      DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause>
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause>
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> createdAtLessThan(
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterWhereClause> createdAtBetween(
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

extension JournalEntryQueryFilter
    on QueryBuilder<JournalEntry, JournalEntry, QFilterCondition> {
  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      aiReflectionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'aiReflection',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      aiReflectionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'aiReflection',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      aiReflectionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      aiReflectionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aiReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      aiReflectionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aiReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      aiReflectionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aiReflection',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      aiReflectionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aiReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      aiReflectionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aiReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      aiReflectionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aiReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      aiReflectionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aiReflection',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      aiReflectionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiReflection',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      aiReflectionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aiReflection',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      audioUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'audioUrl',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      audioUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'audioUrl',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      audioUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      audioUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      audioUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      audioUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audioUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      audioUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'audioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      audioUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'audioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      audioUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'audioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      audioUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'audioUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      audioUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      audioUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'audioUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionConfidenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'emotionConfidence',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionConfidenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'emotionConfidence',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionConfidenceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emotionConfidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionConfidenceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emotionConfidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionConfidenceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emotionConfidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionConfidenceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emotionConfidence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionDetectedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'emotionDetected',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionDetectedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'emotionDetected',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionDetectedEqualTo(
    EmotionType? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emotionDetected',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionDetectedGreaterThan(
    EmotionType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emotionDetected',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionDetectedLessThan(
    EmotionType? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emotionDetected',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionDetectedBetween(
    EmotionType? lower,
    EmotionType? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emotionDetected',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionDetectedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'emotionDetected',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionDetectedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'emotionDetected',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionDetectedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emotionDetected',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionDetectedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emotionDetected',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionDetectedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emotionDetected',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      emotionDetectedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emotionDetected',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedAiResponseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'encryptedAiResponse',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedAiResponseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'encryptedAiResponse',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedAiResponseEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedAiResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedAiResponseGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'encryptedAiResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedAiResponseLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'encryptedAiResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedAiResponseBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'encryptedAiResponse',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedAiResponseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'encryptedAiResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedAiResponseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'encryptedAiResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedAiResponseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedAiResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedAiResponseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedAiResponse',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedAiResponseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedAiResponse',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedAiResponseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedAiResponse',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedContentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'encryptedContent',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedContentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'encryptedContent',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedContentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedContentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'encryptedContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedContentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'encryptedContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedContentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'encryptedContent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedContentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'encryptedContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedContentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'encryptedContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedContentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedContentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedContent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedContentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedContent',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      encryptedContentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedContent',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      isEncryptedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEncrypted',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      isTodayEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isToday',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      syncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'syncedAt',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      syncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'syncedAt',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      syncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      syncedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      syncedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      syncedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      transcriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'transcription',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      transcriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'transcription',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      transcriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transcription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      transcriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transcription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      transcriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transcription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      transcriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transcription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      transcriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transcription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      transcriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transcription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      transcriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transcription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      transcriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transcription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      transcriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transcription',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      transcriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transcription',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      userUuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      userUuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userUuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      userUuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      userUuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> uuidEqualTo(
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> uuidEndsWith(
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

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> uuidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition> uuidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension JournalEntryQueryObject
    on QueryBuilder<JournalEntry, JournalEntry, QFilterCondition> {}

extension JournalEntryQueryLinks
    on QueryBuilder<JournalEntry, JournalEntry, QFilterCondition> {}

extension JournalEntryQuerySortBy
    on QueryBuilder<JournalEntry, JournalEntry, QSortBy> {
  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByAiReflection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiReflection', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByAiReflectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiReflection', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByAudioUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioUrl', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByAudioUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioUrl', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByEmotionConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionConfidence', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByEmotionConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionConfidence', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByEmotionDetected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionDetected', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByEmotionDetectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionDetected', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByEncryptedAiResponse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedAiResponse', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByEncryptedAiResponseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedAiResponse', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByEncryptedContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedContent', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByEncryptedContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedContent', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByIsEncrypted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEncrypted', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByIsEncryptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEncrypted', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByIsToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isToday', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByIsTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isToday', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByTranscription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transcription', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      sortByTranscriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transcription', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByUserUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUuid', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByUserUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUuid', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension JournalEntryQuerySortThenBy
    on QueryBuilder<JournalEntry, JournalEntry, QSortThenBy> {
  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByAiReflection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiReflection', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByAiReflectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiReflection', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByAudioUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioUrl', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByAudioUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioUrl', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByEmotionConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionConfidence', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByEmotionConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionConfidence', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByEmotionDetected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionDetected', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByEmotionDetectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionDetected', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByEncryptedAiResponse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedAiResponse', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByEncryptedAiResponseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedAiResponse', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByEncryptedContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedContent', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByEncryptedContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedContent', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByIsEncrypted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEncrypted', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByIsEncryptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEncrypted', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByIsToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isToday', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByIsTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isToday', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByTranscription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transcription', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy>
      thenByTranscriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transcription', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByUserUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUuid', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByUserUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUuid', Sort.desc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension JournalEntryQueryWhereDistinct
    on QueryBuilder<JournalEntry, JournalEntry, QDistinct> {
  QueryBuilder<JournalEntry, JournalEntry, QDistinct> distinctByAiReflection(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aiReflection', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct> distinctByAudioUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct>
      distinctByEmotionConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emotionConfidence');
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct> distinctByEmotionDetected(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emotionDetected',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct>
      distinctByEncryptedAiResponse({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedAiResponse',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct>
      distinctByEncryptedContent({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedContent',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct> distinctByIsEncrypted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEncrypted');
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct> distinctByIsToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isToday');
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct> distinctBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncedAt');
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct> distinctByTranscription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transcription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct> distinctByUserUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userUuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JournalEntry, JournalEntry, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension JournalEntryQueryProperty
    on QueryBuilder<JournalEntry, JournalEntry, QQueryProperty> {
  QueryBuilder<JournalEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<JournalEntry, String?, QQueryOperations> aiReflectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aiReflection');
    });
  }

  QueryBuilder<JournalEntry, String?, QQueryOperations> audioUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioUrl');
    });
  }

  QueryBuilder<JournalEntry, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<JournalEntry, double?, QQueryOperations>
      emotionConfidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emotionConfidence');
    });
  }

  QueryBuilder<JournalEntry, EmotionType?, QQueryOperations>
      emotionDetectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emotionDetected');
    });
  }

  QueryBuilder<JournalEntry, String?, QQueryOperations>
      encryptedAiResponseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedAiResponse');
    });
  }

  QueryBuilder<JournalEntry, String?, QQueryOperations>
      encryptedContentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedContent');
    });
  }

  QueryBuilder<JournalEntry, bool, QQueryOperations> isEncryptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEncrypted');
    });
  }

  QueryBuilder<JournalEntry, bool, QQueryOperations> isTodayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isToday');
    });
  }

  QueryBuilder<JournalEntry, DateTime?, QQueryOperations> syncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncedAt');
    });
  }

  QueryBuilder<JournalEntry, String?, QQueryOperations>
      transcriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transcription');
    });
  }

  QueryBuilder<JournalEntry, String, QQueryOperations> userUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userUuid');
    });
  }

  QueryBuilder<JournalEntry, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
