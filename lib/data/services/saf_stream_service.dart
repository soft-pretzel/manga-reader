import 'dart:typed_data';

import 'package:saf_stream/saf_stream.dart';

class SafStreamService {
  Future<Stream<Uint8List>> readFileStream(String uri) async {
    final safStream = SafStream();
    return await safStream.readFileStream(uri);
  }
}
