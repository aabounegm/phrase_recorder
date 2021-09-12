import 'node_choice.dart';

enum ScenarioEnding { win, loss }

class ScenarioNode {
  String id;
  String? text;
  String? comment;
  String? imageUrl;
  String? audioUrl;
  bool mediaOnly;
  ScenarioEnding? ending;
  DateTime lastUpdated;
  List<NodeChoice>? choices;

  ScenarioNode({
    required this.id,
    required this.lastUpdated,
    this.comment,
    this.mediaOnly = false,
    this.text,
    this.imageUrl,
    this.audioUrl,
    this.ending,
    this.choices,
  });
}
