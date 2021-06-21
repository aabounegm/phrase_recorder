import 'package:phrase_recorder/exercises/scenario_node.dart';
import 'package:phrase_recorder/exercises/transition.dart';

class Scenario {
  int _score = 0;
  int get score => _score;

  late ScenarioNode _node;
  ScenarioNode get node => _node;
  bool get finished => node.outcome != null;

  final _state = <String, Set<String>>{};
  bool get ready {
    if (finished) return false;
    if (node.state == null) return true;
    return _state[node.state]?.isNotEmpty ?? false;
  }

  void setState(Set<String> state) {
    if (node.state != null) _state[node.state!] = state;
  }

  final Map<String, ScenarioNode> nodes;
  final List<ScenarioNode> progress = [];

  void moveNext() {
    final transition = this.node.transitions?.firstWhere(
          (t) => t.evaluate(_state),
          orElse: () => Transition(''),
        );

    final id = transition?.target ?? '';
    if (id.isEmpty) return;

    final node = nodes[transition?.target ?? ''];
    if (node == null) return;

    _node = node;
    progress.add(this.node);
    _score += transition!.score;
  }

  Scenario(this.nodes) {
    _node = nodes['start']!;
    progress.add(node);
  }
}
