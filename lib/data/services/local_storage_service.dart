import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:saf_stream/saf_stream.dart';
import 'package:saf_util/saf_util.dart';

class LocalStorageService {
  Future<Archive> extractTar(List<int> bytes) async {
    return TarDecoder().decodeBytes(bytes);
  }

  Future<Archive> extractZip(List<int> bytes) async {
    return ZipDecoder().decodeBytes(bytes);
  }

  Future<Directory> getCache() async {
    return getApplicationCacheDirectory();
  }

  Future<List<String>> getFiles(String path) async {
    final safUtil = SafUtil();
    final safDocumentFiles = await safUtil.list(path);
    return safDocumentFiles.map((file) => file.uri).toList();
  }

  Future<String> getFileType(String path) async {
    if (Platform.isAndroid) {
      final safUtil = SafUtil();
      final file = await safUtil.documentFileFromUri(path, null);
      return file!.name.split('.').last;
    } else {
      return path.split('.').last;
    }
  }

  Future<String> getName(String path) async {
    if (Platform.isAndroid) {
      final safUtil = SafUtil();
      final file = await safUtil.documentFileFromUri(path, null);
      if (file!.isDir) {
        return file.name;
      } else {
        final fileType = file.name.split('.').last;
        return file.name.substring(0, file.name.length - (fileType.length + 1));
      }
    } else {
      if (await Directory(path).exists()) {
        return path.split(Platform.pathSeparator).last;
      } else {
        final fileType = path.split('.').last;
        final file = path.split(Platform.pathSeparator).last;
        return file.substring(0, file.length - (fileType.length + 1));
      }
    }
  }

  Future<bool> isDir(String uri) async {
    final safUtil = SafUtil();
    final safDocumentFile = await safUtil.documentFileFromUri(uri, null);
    return safDocumentFile!.isDir;
  }

  // TODO: Add support for non-Android platforms
  Future<Stream<Uint8List>> readFileStream(String uri) async {
    final safStream = SafStream();
    return await safStream.readFileStream(uri);
  }

  Future<String?> selectFolder() async {
    if (Platform.isAndroid) {
      final safUtil = SafUtil();
      final safDocumentFile = await safUtil.pickDirectory(
        persistablePermission: true,
        writePermission: true,
      );
      return safDocumentFile?.uri;
    } else {
      return await FilePicker.getDirectoryPath();
    }
  }
}
