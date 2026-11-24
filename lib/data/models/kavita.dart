class Kavita {
  final String id;
  final String apiKey;
  final DateTime dateAdded;
  final String name;
  final Uri url;

  Kavita({
    required this.id,
    required this.apiKey,
    required this.dateAdded,
    required this.name,
    required this.url,
  });

  Kavita.fromMap(Map<String, Object?> map)
    : id = map['id'].toString(),
      apiKey = map['api_key'].toString(),
      dateAdded = DateTime.fromMillisecondsSinceEpoch(
        int.parse(map['date_added'].toString()),
      ),
      name = map['name'].toString(),
      url = Uri.parse(map['url'].toString());

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'api_key': apiKey,
      'date_added': dateAdded,
      'name': name,
      'url': url,
    };
  }
}
