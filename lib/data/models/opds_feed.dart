import 'package:unseal/unseal.dart' as unseal;

import 'library.dart';

class OpdsFeed extends LibraryItem {
  final String id;
  final DateTime dateAdded;
  unseal.OpdsFeed? feed;
  Uri uri;

  OpdsFeed({
    required this.id,
    required this.dateAdded,
    this.feed,
    required this.uri,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date_added': dateAdded.millisecondsSinceEpoch,
      'uri': uri.toString(),
    };
  }

  OpdsFeed.fromMap(Map<String, Object?> map)
    : id = map['id'].toString(),
      dateAdded = DateTime.fromMillisecondsSinceEpoch(
        int.parse(map['date_added'].toString()),
      ),
      uri = Uri.parse(map['uri'].toString());
}
