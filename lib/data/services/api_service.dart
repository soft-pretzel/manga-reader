import 'package:url_launcher/url_launcher.dart';

class ApiService {
  Future<void> openLink(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
