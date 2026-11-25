import '../../utils/result.dart';
import '../models/server.dart';
import '../services/database_service.dart';

class ServerRepository {
  ServerRepository({required this._databaseService});

  final DatabaseService _databaseService;

  Future<Result<void>> addServer(Server server) async {
    try {
      return await _databaseService.insertServer(server);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<Server>>> getServers() async {
    return await _databaseService.getServers();
  }
}
