import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:saf/saf.dart';

class LocalStorageService {
  Future<Archive?> decodeArchive(String path) async {
    InputStream stream;
    String archiveType;
    if (Platform.isAndroid) {
      final saf = Saf();
      Stream<List<int>> byteStream = await saf.readFileStream(path);
      List<int> bytes = [];
      await for (final byteList in byteStream) {
        for (final byte in byteList) {
          bytes.add(byte);
        }
      }
      stream = InputMemoryStream(bytes);
      archiveType = (await saf.stat(path))!.name.split('.').last;
    } else {
      stream = InputFileStream(path);
      archiveType = path.split('.').last;
    }

    Archive? archive;
    switch (archiveType) {
      case 'cbz' || 'zip':
        archive = ZipDecoder().decodeStream(stream);
      case 'cbt' || 'cbz':
        archive = TarDecoder().decodeStream(stream);
    }

    return archive;
  }

  Future<List<String>> getFiles(String path) async {
    if (Platform.isAndroid) {
      final saf = Saf();
      final files = await saf.list(path);
      return files.map((file) => file.uri).toList();
    } else {
      final files = Directory(
        path,
      ).listSync(recursive: false, followLinks: false);
      return files.map((file) => file.path).toList();
    }
  }

  Future<String> getFileType(String path) async {
    if (Platform.isAndroid) {
      final saf = Saf();
      final file = await saf.stat(path);
      return file!.name.split('.').last;
    } else {
      return path.split('.').last;
    }
  }

  Future<String> getName(String path) async {
    if (Platform.isAndroid) {
      final saf = Saf();
      final file = await saf.stat(path);
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

  Future<Directory> getThumbnailCache() async {
    final cache = await getApplicationCacheDirectory();
    final thumbnailCache = Directory(
      '${cache.path}${Platform.pathSeparator}thumbnails',
    );
    if (!await thumbnailCache.exists()) {
      await thumbnailCache.create(recursive: true);
    }
    return thumbnailCache;
  }

  Future<Directory> getReadingCache() async {
    final cache = await getApplicationCacheDirectory();
    final readingCache = Directory(
      '${cache.path}${Platform.pathSeparator}reading',
    );
    if (!await readingCache.exists()) {
      await readingCache.create(recursive: true);
    }
    return readingCache;
  }

  Future<bool> isDir(String path) async {
    if (Platform.isAndroid) {
      final saf = Saf();
      final safDocumentFile = await saf.stat(path);
      return safDocumentFile!.isDir;
    } else {
      return Directory(path).exists();
    }
  }

  Future<String?> selectFolder() async {
    if (Platform.isAndroid) {
      final saf = Saf();
      final safDocumentFile = await saf.pickDirectory(
        persistablePermission: true,
        writePermission: true,
      );
      return safDocumentFile?.uri;
    } else {
      return await FilePicker.getDirectoryPath();
    }
  }

  Future<String> writeArchiveFile(
    ArchiveFile file,
    String path, [
    String? name,
  ]) async {
    final outputPath = '$path${Platform.pathSeparator}${name ?? file.name}';
    final outputStream = OutputFileStream(outputPath);
    file.writeContent(outputStream);
    outputStream.closeSync();
    return outputPath;
  }
}
