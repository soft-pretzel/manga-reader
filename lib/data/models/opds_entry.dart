import 'package:unseal/unseal.dart' as unseal;

import 'library.dart';

class OpdsEntry extends LibraryItem {
  unseal.OpdsEntry entry;
  final String parentId;

  OpdsEntry({required this.entry, required this.parentId});
}
