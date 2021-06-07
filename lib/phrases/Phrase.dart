import 'dart:io';

class Phrase {
  final String id;
  final String text;
  late final File file;
  bool exists = false;

  Future<void> checkIfExists() async {
    exists = await file.exists();
  }

  Phrase({
    required this.id,
    required this.text,
    required String root,
  }) {
    file = File('$root/$id.aac');
    checkIfExists();
  }

  Phrase.fromJson(
    Map<String, dynamic> json, {
    required String id,
    required String root,
  }) : this(
          id: id,
          text: json['text'],
          root: root,
        );

  Map<String, dynamic> toJson() {
    final data = {};
    data['text'] = text;
    return data as Map<String, dynamic>;
  }
}
