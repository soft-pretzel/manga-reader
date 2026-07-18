import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathProviderService {
  Future<Directory> getCache() async {
    return getApplicationCacheDirectory();
  }
}
