import 'scenario_node.dart';

enum ContentStatus { public, unlisted, private }

class ScenarioTranslation {
  String? textSetId;
  String? audioSetId;
  ScenarioTranslation({
    this.textSetId,
    this.audioSetId,
  });
}

class Scenario {
  String title;
  String? description;
  int likes;
  ContentStatus status;
  String authorId;
  List<ScenarioNode> nodes;
  String startNodeId;
  Map<String, ScenarioTranslation>? translations;

  Scenario({
    required this.title,
    this.translations,
    this.description,
    this.likes = 0,
    this.status = ContentStatus.private,
    required this.authorId,
    required this.startNodeId,
    required this.nodes,
  });
}
