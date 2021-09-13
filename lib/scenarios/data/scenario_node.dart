enum ScenarioEnding { win, loss }

class NodeChoice {
  String id;
  String text;
  String targetNodeId;

  NodeChoice({
    required this.id,
    required this.text,
    required this.targetNodeId,
  });
}

class ScenarioNode {
  String id;
  String note;
  ScenarioEnding? ending;
  List<NodeChoice>? choices;

  ScenarioNode({
    required this.id,
    required this.note,
    this.ending,
    this.choices,
  });
}
