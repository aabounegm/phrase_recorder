import 'content_meta_data.dart';

class ScenarioTranslation {
  String? textSetId;
  String? audioSetId;
  ScenarioTranslation({
    this.textSetId,
    this.audioSetId,
  });
}

class ScenarioTranslationSet {
  ContentMetaData metaData;
  Map<String, String> assets;

  ScenarioTranslationSet({
    required this.metaData,
    required this.assets,
  });
}
