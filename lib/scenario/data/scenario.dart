import 'content_meta_data.dart';
import 'scenario_node.dart';
import 'scenario_translation_set.dart';

class Scenario {
  ContentMetaData metaData;
  String title;
  String? description;
  int likes;
  List<ScenarioNode> nodes;
  String startNodeId;
  Map<String, ScenarioTranslation>? translations;

  Scenario({
    required this.metaData,
    required this.title,
    this.translations,
    this.description,
    this.likes = 0,
    required this.startNodeId,
    required this.nodes,
  });
}
