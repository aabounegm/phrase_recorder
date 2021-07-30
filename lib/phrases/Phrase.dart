import 'dart:io';

class Phrase {
  final String id;
  final String text;
  final int index;
  late final File file;
  bool exists = false;

  Future<void> checkIfExists() async {
    exists = await file.exists();
  }

  Phrase({
    required this.id,
    required this.text,
    required this.index,
    required String root,
  }) {
    file = File('$root/$id.mp3');
    checkIfExists();
  }

  Phrase.fromJson(
    Map<String, dynamic> json, {
    required String id,
    required String root,
  }) : this(
          id: id,
          text: json['text'],
          index: int.parse(json['index']),
          root: root,
        );

  Map<String, dynamic> toJson() {
    final data = {};
    data['text'] = text;
    data['index'] = index.toString();
    return data as Map<String, dynamic>;
  }
}
