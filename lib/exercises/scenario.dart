import 'package:phrase_recorder/exercises/scenario_node.dart';

class Scenario {
  String current;
  final Map<String, ScenarioNode> nodes;

  ScenarioNode? get node => nodes[current];

  Scenario(
    this.nodes, {
    this.current = 'start',
  });
}
