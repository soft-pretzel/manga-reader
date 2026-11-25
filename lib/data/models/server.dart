class Server {
  final int? id;
  final String? apiKey;
  final DateTime dateAdded;
  final String name;
  final String? password;
  final ServerType type;
  final Uri url;
  final String? username;

  Server({
    this.id,
    this.apiKey,
    required this.dateAdded,
    required this.name,
    this.password,
    required this.type,
    required this.url,
    this.username,
  });

  Server.fromMap(Map<String, Object?> map)
    : id = int.tryParse(map['id'].toString()),
      apiKey = map['api_key']?.toString(),
      dateAdded = DateTime.fromMillisecondsSinceEpoch(
        int.parse(map['date_added'].toString()),
      ),
      name = map['name'].toString(),
      password = map['password']?.toString(),
      type = ServerType.values[int.parse(map['type'].toString())],
      url = Uri.parse(map['url'].toString()),
      username = map['username']?.toString();

  Map<String, Object?> toMap() {
    return {
      if (apiKey != null) 'api_key': apiKey,
      'date_added': dateAdded,
      'name': name,
      if (password != null) 'password': password,
      'type': type.index,
      'url': url,
      if (username != null) 'username': username,
    };
  }
}

enum ServerType { kavita, opds, stump }
