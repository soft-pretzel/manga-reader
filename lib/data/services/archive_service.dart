import 'package:archive/archive.dart';

class ArchiveService {
  Future<Archive> extractTar(List<int> bytes) async {
    return TarDecoder().decodeBytes(bytes);
  }

  Future<Archive> extractZip(List<int> bytes) async {
    return ZipDecoder().decodeBytes(bytes);
  }
}
