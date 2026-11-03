import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:proper_filesize/proper_filesize.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:url_launcher/url_launcher.dart';

class UtilsService {
  Future<void> brightnessDown() async {
    final brightness = (await ScreenBrightness.instance.application) - 0.0005;
    if (brightness >= 0) {
      await ScreenBrightness.instance.setApplicationScreenBrightness(
        brightness,
      );
    }
  }

  Future<void> brightnessReset() async {
    await ScreenBrightness.instance.resetApplicationScreenBrightness();
  }

  Future<void> brightnessUp() async {
    final brightness = (await ScreenBrightness.instance.application) + 0.0005;
    if (brightness <= 1) {
      await ScreenBrightness.instance.setApplicationScreenBrightness(
        brightness,
      );
    }
  }

  Future<String> formatFileSize(int size) async {
    return FileSize.fromBytes(size).toString(
      decimals: 1,
      unit: Unit.auto(size: size, baseType: BaseType.metric),
    );
  }

  Future<String> getAppVersion() async {
    return (await PackageInfo.fromPlatform()).version;
  }

  Future<Map<String, dynamic>> makeHttpRequest(Uri uri) async {
    final result = await http.read(uri);
    return json.decode(result) as Map<String, dynamic>;
  }

  Future<void> openLink(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}
