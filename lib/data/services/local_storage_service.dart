import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:saf/saf.dart';

class LocalStorageService {
  Future<Archive?> decodeArchive(String path) async {
    final saf = Saf();
    Stream<List<int>> byteStream = await saf.readFileStream(path);
    List<int> bytes = [];
    await for (final byteList in byteStream) {
      for (final byte in byteList) {
        bytes.add(byte);
      }
    }

    Archive? archive;
    final archiveType = (await saf.stat(path))!.name.split('.').last;
    switch (archiveType) {
      case 'cbz' || 'zip':
        archive = ZipDecoder().decodeStream(InputMemoryStream(bytes));
      case 'cbt' || 'cbz':
        archive = TarDecoder().decodeStream(InputMemoryStream(bytes));
    }
    return archive;
  }

  Future<Directory> getCache() async {
    return getApplicationCacheDirectory();
  }

  Future<List<String>> getFiles(String path) async {
    final saf = Saf();
    final safDocumentFiles = await saf.list(path);
    return safDocumentFiles.map((file) => file.uri).toList();
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

  Future<bool> isDir(String uri) async {
    final saf = Saf();
    final safDocumentFile = await saf.stat(uri);
    return safDocumentFile!.isDir;
  }

  // TODO: Add support for non-Android platforms
  Future<Stream<Uint8List>> readFileStream(String uri) async {
    final saf = Saf();
    return await saf.readFileStream(uri);
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
