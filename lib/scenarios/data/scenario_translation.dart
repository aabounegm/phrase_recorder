import 'package:phrase_recorder/scenario/scenario_node.dart';

import 'content_meta_data.dart';

class ScenarioTranslation {
  String language;
  Map<String, String> assets;
  ContentMetaData metaData;

  ScenarioTranslation({
    required this.language,
    required this.metaData,
    required this.assets,
  });
}
