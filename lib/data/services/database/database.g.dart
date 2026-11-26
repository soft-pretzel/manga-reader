// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ServersTable extends Servers with TableInfo<$ServersTable, Server> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _apiKeyMeta = const VerificationMeta('apiKey');
  @override
  late final GeneratedColumn<String> apiKey = GeneratedColumn<String>(
    'api_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateAddedMeta = const VerificationMeta(
    'dateAdded',
  );
  @override
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
    'date_added',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ServerType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ServerType>($ServersTable.$convertertype);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    apiKey,
    dateAdded,
    name,
    password,
    type,
    url,
    username,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'servers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Server> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('api_key')) {
      context.handle(
        _apiKeyMeta,
        apiKey.isAcceptableOrUnknown(data['api_key']!, _apiKeyMeta),
      );
    }
    if (data.containsKey('date_added')) {
      context.handle(
        _dateAddedMeta,
        dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta),
      );
    } else if (isInserting) {
      context.missing(_dateAddedMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Server map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Server(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      apiKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}api_key'],
      ),
      dateAdded: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_added'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      ),
      type: $ServersTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
    );
  }

  @override
  $ServersTable createAlias(String alias) {
    return $ServersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ServerType, int, int> $convertertype =
      const EnumIndexConverter<ServerType>(ServerType.values);
}

class Server extends DataClass implements Insertable<Server> {
  final int id;
  final String? apiKey;
  final DateTime dateAdded;
  final String name;
  final String? password;
  final ServerType type;
  final String url;
  final String? username;
  const Server({
    required this.id,
    this.apiKey,
    required this.dateAdded,
    required this.name,
    this.password,
    required this.type,
    required this.url,
    this.username,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || apiKey != null) {
      map['api_key'] = Variable<String>(apiKey);
    }
    map['date_added'] = Variable<DateTime>(dateAdded);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    {
      map['type'] = Variable<int>($ServersTable.$convertertype.toSql(type));
    }
    map['url'] = Variable<String>(url);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    return map;
  }

  ServersCompanion toCompanion(bool nullToAbsent) {
    return ServersCompanion(
      id: Value(id),
      apiKey: apiKey == null && nullToAbsent
          ? const Value.absent()
          : Value(apiKey),
      dateAdded: Value(dateAdded),
      name: Value(name),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      type: Value(type),
      url: Value(url),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
    );
  }

  factory Server.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Server(
      id: serializer.fromJson<int>(json['id']),
      apiKey: serializer.fromJson<String?>(json['apiKey']),
      dateAdded: serializer.fromJson<DateTime>(json['dateAdded']),
      name: serializer.fromJson<String>(json['name']),
      password: serializer.fromJson<String?>(json['password']),
      type: $ServersTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      url: serializer.fromJson<String>(json['url']),
      username: serializer.fromJson<String?>(json['username']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'apiKey': serializer.toJson<String?>(apiKey),
      'dateAdded': serializer.toJson<DateTime>(dateAdded),
      'name': serializer.toJson<String>(name),
      'password': serializer.toJson<String?>(password),
      'type': serializer.toJson<int>($ServersTable.$convertertype.toJson(type)),
      'url': serializer.toJson<String>(url),
      'username': serializer.toJson<String?>(username),
    };
  }

  Server copyWith({
    int? id,
    Value<String?> apiKey = const Value.absent(),
    DateTime? dateAdded,
    String? name,
    Value<String?> password = const Value.absent(),
    ServerType? type,
    String? url,
    Value<String?> username = const Value.absent(),
  }) => Server(
    id: id ?? this.id,
    apiKey: apiKey.present ? apiKey.value : this.apiKey,
    dateAdded: dateAdded ?? this.dateAdded,
    name: name ?? this.name,
    password: password.present ? password.value : this.password,
    type: type ?? this.type,
    url: url ?? this.url,
    username: username.present ? username.value : this.username,
  );
  Server copyWithCompanion(ServersCompanion data) {
    return Server(
      id: data.id.present ? data.id.value : this.id,
      apiKey: data.apiKey.present ? data.apiKey.value : this.apiKey,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      name: data.name.present ? data.name.value : this.name,
      password: data.password.present ? data.password.value : this.password,
      type: data.type.present ? data.type.value : this.type,
      url: data.url.present ? data.url.value : this.url,
      username: data.username.present ? data.username.value : this.username,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Server(')
          ..write('id: $id, ')
          ..write('apiKey: $apiKey, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('name: $name, ')
          ..write('password: $password, ')
          ..write('type: $type, ')
          ..write('url: $url, ')
          ..write('username: $username')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, apiKey, dateAdded, name, password, type, url, username);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Server &&
          other.id == this.id &&
          other.apiKey == this.apiKey &&
          other.dateAdded == this.dateAdded &&
          other.name == this.name &&
          other.password == this.password &&
          other.type == this.type &&
          other.url == this.url &&
          other.username == this.username);
}

class ServersCompanion extends UpdateCompanion<Server> {
  final Value<int> id;
  final Value<String?> apiKey;
  final Value<DateTime> dateAdded;
  final Value<String> name;
  final Value<String?> password;
  final Value<ServerType> type;
  final Value<String> url;
  final Value<String?> username;
  const ServersCompanion({
    this.id = const Value.absent(),
    this.apiKey = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.name = const Value.absent(),
    this.password = const Value.absent(),
    this.type = const Value.absent(),
    this.url = const Value.absent(),
    this.username = const Value.absent(),
  });
  ServersCompanion.insert({
    this.id = const Value.absent(),
    this.apiKey = const Value.absent(),
    required DateTime dateAdded,
    required String name,
    this.password = const Value.absent(),
    required ServerType type,
    required String url,
    this.username = const Value.absent(),
  }) : dateAdded = Value(dateAdded),
       name = Value(name),
       type = Value(type),
       url = Value(url);
  static Insertable<Server> custom({
    Expression<int>? id,
    Expression<String>? apiKey,
    Expression<DateTime>? dateAdded,
    Expression<String>? name,
    Expression<String>? password,
    Expression<int>? type,
    Expression<String>? url,
    Expression<String>? username,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (apiKey != null) 'api_key': apiKey,
      if (dateAdded != null) 'date_added': dateAdded,
      if (name != null) 'name': name,
      if (password != null) 'password': password,
      if (type != null) 'type': type,
      if (url != null) 'url': url,
      if (username != null) 'username': username,
    });
  }

  ServersCompanion copyWith({
    Value<int>? id,
    Value<String?>? apiKey,
    Value<DateTime>? dateAdded,
    Value<String>? name,
    Value<String?>? password,
    Value<ServerType>? type,
    Value<String>? url,
    Value<String?>? username,
  }) {
    return ServersCompanion(
      id: id ?? this.id,
      apiKey: apiKey ?? this.apiKey,
      dateAdded: dateAdded ?? this.dateAdded,
      name: name ?? this.name,
      password: password ?? this.password,
      type: type ?? this.type,
      url: url ?? this.url,
      username: username ?? this.username,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (apiKey.present) {
      map['api_key'] = Variable<String>(apiKey.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $ServersTable.$convertertype.toSql(type.value),
      );
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServersCompanion(')
          ..write('id: $id, ')
          ..write('apiKey: $apiKey, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('name: $name, ')
          ..write('password: $password, ')
          ..write('type: $type, ')
          ..write('url: $url, ')
          ..write('username: $username')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  $DatabaseManager get managers => $DatabaseManager(this);
  late final $ServersTable servers = $ServersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [servers];
}

typedef $$ServersTableCreateCompanionBuilder = ServersCompanion Function({
  Value<int> id,
  Value<String?> apiKey,
  required DateTime dateAdded,
  required String name,
  Value<String?> password,
  required ServerType type,
  required String url,
  Value<String?> username,
});
typedef $$ServersTableUpdateCompanionBuilder = ServersCompanion Function({
  Value<int> id,
  Value<String?> apiKey,
  Value<DateTime> dateAdded,
  Value<String> name,
  Value<String?> password,
  Value<ServerType> type,
  Value<String> url,
  Value<String?> username,
});

class $$ServersTableFilterComposer extends Composer<_$Database, $ServersTable> {
  $$ServersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apiKey => $composableBuilder(
    column: $table.apiKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ServerType, ServerType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServersTableOrderingComposer
    extends Composer<_$Database, $ServersTable> {
  $$ServersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apiKey => $composableBuilder(
    column: $table.apiKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServersTableAnnotationComposer
    extends Composer<_$Database, $ServersTable> {
  $$ServersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get apiKey =>
      $composableBuilder(column: $table.apiKey, builder: (column) => column);

  GeneratedColumn<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ServerType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);
}

class $$ServersTableTableManager
    extends
        RootTableManager<
          _$Database,
          $ServersTable,
          Server,
          $$ServersTableFilterComposer,
          $$ServersTableOrderingComposer,
          $$ServersTableAnnotationComposer,
          $$ServersTableCreateCompanionBuilder,
          $$ServersTableUpdateCompanionBuilder,
          (Server, BaseReferences<_$Database, $ServersTable, Server>),
          Server,
          PrefetchHooks Function()
        > {
  $$ServersTableTableManager(_$Database db, $ServersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> apiKey = const Value.absent(),
                Value<DateTime> dateAdded = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> password = const Value.absent(),
                Value<ServerType> type = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String?> username = const Value.absent(),
              }) => ServersCompanion(
                id: id,
                apiKey: apiKey,
                dateAdded: dateAdded,
                name: name,
                password: password,
                type: type,
                url: url,
                username: username,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> apiKey = const Value.absent(),
                required DateTime dateAdded,
                required String name,
                Value<String?> password = const Value.absent(),
                required ServerType type,
                required String url,
                Value<String?> username = const Value.absent(),
              }) => ServersCompanion.insert(
                id: id,
                apiKey: apiKey,
                dateAdded: dateAdded,
                name: name,
                password: password,
                type: type,
                url: url,
                username: username,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ServersTable, Server>(table),
                  BaseReferences<_$Database, $ServersTable, Server>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServersTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $ServersTable,
      Server,
      $$ServersTableFilterComposer,
      $$ServersTableOrderingComposer,
      $$ServersTableAnnotationComposer,
      $$ServersTableCreateCompanionBuilder,
      $$ServersTableUpdateCompanionBuilder,
      (Server, BaseReferences<_$Database, $ServersTable, Server>),
      Server,
      PrefetchHooks Function()
    >;

class $DatabaseManager {
  final _$Database _db;
  $DatabaseManager(this._db);
  $$ServersTableTableManager get servers =>
      $$ServersTableTableManager(_db, _db.servers);
}
