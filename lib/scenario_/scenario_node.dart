import 'node_choice.dart';

enum ScenarioEnding { win, loss }

class ScenarioNode {
  String id;
  String? text;
  String? imageUrl;
  String? audioUrl;
  ScenarioEnding? ending;
  List<NodeChoice>? choices;

  ScenarioNode({
    required this.id,
    this.text,
    this.imageUrl,
    this.audioUrl,
    this.ending,
    this.choices,
  });
}
