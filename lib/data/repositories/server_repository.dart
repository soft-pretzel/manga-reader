import 'package:drift/drift.dart';

import '../../utils/result.dart';
import '../services/database/database.dart';

class ServerRepository {
  ServerRepository({required this._database});

  final Database _database;

  Future<Result<void>> addServer(Server server) async {
    try {
      await _database.servers.insertOne(server);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Stream<List<Server>> getServers() {
    return _database.allServers;
  }
}
