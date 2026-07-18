import 'package:uuid/uuid.dart';

class UuidService {
  String generate() {
    var uuid = Uuid();
    return uuid.v7();
  }
}
