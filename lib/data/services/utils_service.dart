import 'package:screen_brightness/screen_brightness.dart';

class UtilsService {
  Future<void> brightnessDown() async {
    final brightness = (await ScreenBrightness.instance.application) - 0.0075;
    if (brightness >= 0) {
      await ScreenBrightness.instance.setApplicationScreenBrightness(
        brightness,
      );
    }
  }

  Future<void> brightnessUp() async {
    final brightness = (await ScreenBrightness.instance.application) + 0.0075;
    if (brightness <= 1) {
      await ScreenBrightness.instance.setApplicationScreenBrightness(
        brightness,
      );
    }
  }
}
