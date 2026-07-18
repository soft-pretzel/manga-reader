import 'package:saf_util/saf_util.dart';
import 'package:saf_util/saf_util_platform_interface.dart';

class SafUtilService {
  Future<SafDocumentFile?> selectFolder() async {
    final safUtil = SafUtil();
    return await safUtil.pickDirectory(
      persistablePermission: true,
      writePermission: true,
    );
  }

  Future<List<SafDocumentFile>> getFiles(String uri) async {
    final safUtil = SafUtil();
    return await safUtil.list(uri);
  }
}
