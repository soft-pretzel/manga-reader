import 'package:flutter/material.dart';
import 'package:saf_util/saf_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () async {
          final safUtil = SafUtil();
          final prefsAsync = SharedPreferencesAsync();
          String? folder = await prefsAsync.getString('folder');

          if (folder == null) {
            final dir = await safUtil.pickDirectory(
              writePermission: true,
              persistablePermission: true,
            );
            if (dir != null) {
              await prefsAsync.setString('folder', dir.uri);
              folder = await prefsAsync.getString('folder');
            }
          }

          if (folder != null) {
            final list = await safUtil.list(folder);
            for (final file in list) {
              print(file.name);
            }
          }
        },
        child: Text('Select Folder'),
      ),
    );
  }
}

// void listFiles(String path) async {
//   var dir = Directory('$path');

//   await for (var file in dir.list(recursive: true, followLinks: false)) {
//     print(file.path);
//   }
// }
