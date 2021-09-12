import 'scenario_node.dart';

enum ContentStatus { public, unlisted, private }

class Scenario {
  String title;
  String? description;
  int likes;
  ContentStatus status;
  String authorId;
  List<ScenarioNode> nodes;
  String startNodeId;

  Scenario({
    required this.title,
    this.description,
    this.likes = 0,
    this.status = ContentStatus.private,
    required this.authorId,
    required this.startNodeId,
    required this.nodes,
  });
}
