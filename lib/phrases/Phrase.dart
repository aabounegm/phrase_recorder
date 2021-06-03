import 'dart:io';

class Phrase {
  final String id;
  final String text;
  String path = '';
  bool exists = false;

  Future<void> checkIfExists() async {
    exists = await File(path).exists();
  }

  Phrase({
    required this.id,
    required this.text,
  });

  Phrase.fromJson(Map<String, dynamic> json, String id)
      : this(
          id: id,
          text: json['text'],
        );

  Map<String, dynamic> toJson() {
    final data = {};
    data['text'] = text;
    return data as Map<String, dynamic>;
  }
}
