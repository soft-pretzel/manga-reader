import 'package:saf_util/saf_util.dart';

class SafUtilService {
  Future<String?> selectFolder() async {
    final safUtil = SafUtil();
    final safDocumentFile = await safUtil.pickDirectory(
      persistablePermission: true,
      writePermission: true,
    );
    return safDocumentFile?.uri;
  }

  Future<List<String>> getFiles(String uri) async {
    final safUtil = SafUtil();
    final safDocumentFiles = await safUtil.list(uri);
    return safDocumentFiles.map((file) => file.uri).toList();
  }

  Future<bool> isDir(String uri) async {
    final safUtil = SafUtil();
    final safDocumentFile = await safUtil.documentFileFromUri(uri, null);
    return safDocumentFile!.isDir;
  }

  Future<String> getName(String uri) async {
    final safUtil = SafUtil();
    final safDocumentFile = await safUtil.documentFileFromUri(uri, null);
    return safDocumentFile!.name;
  }
}
