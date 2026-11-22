import 'package:unseal/unseal.dart';

import 'library_item.dart';

class Server extends LibraryItem {
  OpdsFeed? feed;
  Uri uri;

  Server({
    required super.id,
    required super.dateAdded,
    this.feed,
    required this.uri,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date_added': dateAdded.millisecondsSinceEpoch,
      'uri': uri.toString(),
    };
  }

  Server.fromMap(super.map)
    : uri = Uri.parse(map['uri'].toString()),
      super.fromMap();
}
