import 'package:phrase_recorder/phrases/phrase.dart';

class Chapter {
  final String id;
  final String title;
  final String? subtitle;
  final List<Phrase> phrases = [];
  int get recorded => phrases.where((p) => p.exists).length;

  Chapter({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  Chapter.fromJson(
    Map<String, dynamic> json, {
    required String id,
  }) : this(
          id: id,
          title: json['title'],
          subtitle: json['subtitle'],
        );

  Map<String, dynamic> toJson() {
    final data = {};
    data['title'] = title;
    data['subtitle'] = subtitle;
    return data as Map<String, dynamic>;
  }
}
