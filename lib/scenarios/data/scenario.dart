import 'content_meta_data.dart';
import 'scenario_node.dart';

class Scenario {
  ContentMetaData metaData;
  String title;
  String? description;
  List<ScenarioNode> nodes;
  String startNodeId;
  Map<String, String>? textTranslations;
  Map<String, String>? audioTranslations;

  Scenario({
    required this.metaData,
    required this.title,
    this.description,
    this.textTranslations,
    this.audioTranslations,
    required this.startNodeId,
    required this.nodes,
  });
}
