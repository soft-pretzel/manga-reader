import '../../utils/result.dart';
import '../models/library.dart';
import '../models/server.dart';
import '../services/api_client.dart';

class LibraryRepository {
  LibraryRepository({required this._apiClient});

  final ApiClient _apiClient;

  List<Library>? _cachedLibraries;

  Future<Result<List<Library>>> getLibraries(Server server) async {
    if (_cachedLibraries == null) {
      final result = await _apiClient.getLibraries(server);
      if (result is Ok<List<Library>>) {
        _cachedLibraries = result.value;
      }
      return result;
    } else {
      return Result.ok(_cachedLibraries!);
    }
  }
}
