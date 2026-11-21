import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:saf_util/saf_util.dart';
import 'package:saf_stream/saf_stream.dart';
import 'package:unseal/unseal.dart';

class LocalStorageService {
  Future<void> clearStorageAccess(String path) async {
    if (Platform.isAndroid) {
      final safUtil = SafUtil();
      if (await safUtil.hasPersistedPermission(
        path,
        checkRead: true,
        checkWrite: true,
      )) {
        await safUtil.releasePersistedPermission(path, read: true, write: true);
      }
    }
  }

  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (file.existsSync()) {
      await File(path).delete();
    }
  }

  Future<BookSession> getBookSession(String path) async {
    BookSession session;
    if (Platform.isAndroid) {
      final safStream = SafStream();
      session = await BookSession.open(await safStream.readFileBytes(path));
    } else {
      session = await BookSession.openFile(path);
    }
    return session;
  }

  Future<FileStat> getCacheInfo() async {
    final cache = await getApplicationCacheDirectory();
    return await cache.stat();
  }

  Future<Directory> getCoversCache() async {
    final cache = await getApplicationCacheDirectory();
    final coversCache = Directory(
      '${cache.path}${Platform.pathSeparator}covers',
    );
    if (!await coversCache.exists()) {
      await coversCache.create(recursive: true);
    }
    return coversCache;
  }

  Future<List<String>> getFiles(String path) async {
    if (Platform.isAndroid) {
      final safUtil = SafUtil();
      final files = await safUtil.list(path);
      return files.map((file) => file.uri).toList();
    } else {
      final files = Directory(path).listSync(followLinks: false);
      return files.map((file) => file.path).toList();
    }
  }

  Future<String> getFileType(String path) async {
    if (Platform.isAndroid) {
      final safUtil = SafUtil();
      final file = await safUtil.stat(path, null);
      return file!.name.split('.').last;
    } else {
      return path.split('.').last;
    }
  }

  Future<String> getFileName(String path) async {
    if (Platform.isAndroid) {
      final safUtil = SafUtil();
      final file = await safUtil.stat(path, null);
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

  Future<bool> getFilePermission(String path) async {
    if (Platform.isAndroid) {
      final safUtil = SafUtil();
      return await safUtil.hasPersistedPermission(path);
    } else {
      return true;
    }
  }

  Future<DateTime> getLastModified(String path) async {
    if (Platform.isAndroid) {
      final safUtil = SafUtil();
      final file = await safUtil.documentFileFromUri(path, null);
      return DateTime.fromMillisecondsSinceEpoch(file!.lastModified);
    } else {
      return File(path).lastModifiedSync();
    }
  }

  Future<bool> isDir(String path) async {
    if (Platform.isAndroid) {
      final safUtil = SafUtil();
      final safDocumentFile = await safUtil.stat(path, null);
      return safDocumentFile!.isDir;
    } else {
      return Directory(path).exists();
    }
  }

  Future<String?> pickDirectory() async {
    if (Platform.isAndroid) {
      final safUtil = SafUtil();
      final safDocumentFile = await safUtil.pickDirectory(
        persistablePermission: true,
        writePermission: true,
      );
      return safDocumentFile?.uri;
    } else {
      return (await FilePicker.pickDirectory())?.path;
    }
  }

  Future<String?> saveBookCover(BookCover? cover, String id) async {
    if (cover != null) {
      final cache = await getCoversCache();
      final file = File(
        '${cache.path}${Platform.pathSeparator}$id.${cover.fileExtension}',
      );
      await file.writeAsBytes(cover.bytes, flush: true);
      return file.path;
    } else {
      return null;
    }
  }
}
