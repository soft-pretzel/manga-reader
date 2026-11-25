class Library {
  final int id;
  final String name;
  final String? coverImage;

  Library({required this.id, required this.name, this.coverImage});

  Library.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int,
      name = json['name'] as String,
      coverImage = json['coverImage']?.toString();
}
