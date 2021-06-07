import 'dart:io';
import 'package:phrase_recorder/phrases/phrase.dart';

class Chapter {
  final String id;
  final String title;
  final String? subtitle;
  final List<Phrase> phrases = [];
  late final Directory directory;

  Chapter({
    required this.id,
    required this.title,
    required this.subtitle,
    required String filesRoot,
  }) {
    directory = Directory('$filesRoot/$id');
    directory.create(recursive: true);
  }

  Chapter.fromJson(
    Map<String, dynamic> json, {
    required String id,
    required String root,
  }) : this(
          id: id,
          title: json['title'],
          subtitle: json['subtitle'],
          filesRoot: root,
        );

  Map<String, dynamic> toJson() {
    final data = {};
    data['title'] = title;
    data['subtitle'] = subtitle;
    return data as Map<String, dynamic>;
  }
}
