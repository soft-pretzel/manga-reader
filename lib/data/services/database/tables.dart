import 'package:drift/drift.dart';

@DataClassName('Server')
class Servers extends Table with AutoIncrementingPrimaryKey {
  TextColumn get apiKey => text().nullable()();
  DateTimeColumn get dateAdded => dateTime()();
  TextColumn get name => text()();
  TextColumn get password => text().nullable()();
  IntColumn get type => intEnum<ServerType>()();
  TextColumn get url => text()();
  TextColumn get username => text().nullable()();
}

mixin AutoIncrementingPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}

enum ServerType { kavita, opds, stump }
