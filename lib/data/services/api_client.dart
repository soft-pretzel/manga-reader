import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../utils/result.dart';
import '../models/library/library.dart';
import '../models/server/server.dart';

class ApiClient {
  Future<Result<List<Library>>> getLibraries(Server server) async {
    final client = http.Client();
    try {
      Map<String, String>? headers;
      Uri url = server.url;
      switch (server.type) {
        case .kavita:
          headers = {'x-api-key': server.apiKey!};
          url = server.url.replace(path: '/api/Library/libraries');
        case .opds:
        case .stump:
      }
      final response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List<dynamic>;
        return Result.ok(
          json.map((element) => Library.fromJson(element)).toList(),
        );
      } else {
        return const Result.error(HttpException('Invalid response'));
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      client.close();
    }
  }
}
