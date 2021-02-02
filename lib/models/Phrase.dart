class Phrase {
  final String id;
  final String text;
  final bool exists;
  final String path;

  const Phrase(this.id, this.text, {required this.path, this.exists = false});
  factory Phrase.fromMap(Map<String, dynamic> json) => Phrase(
        json['id'],
        json['text'],
        exists: json['exists'] ?? false,
        path: json['path'],
      );
}
