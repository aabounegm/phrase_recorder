import 'dart:io';
import 'package:phrase_recorder/phrases/phrase.dart';

class Chapter {
  final String id;
  final String title;
  final String? subtitle;
  final List<Phrase> phrases = [];
  late final Directory directory;
  int get recorded => phrases.where((p) => p.exists).length;

  Chapter({
    required this.id,
    required this.title,
    required this.subtitle,
    required String root,
  }) {
    directory = Directory('$root/$id');
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
          root: root,
        );

  Map<String, dynamic> toJson() {
    final data = {};
    data['title'] = title;
    data['subtitle'] = subtitle;
    return data as Map<String, dynamic>;
  }
}
