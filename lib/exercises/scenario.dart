import 'package:phrase_recorder/exercises/scenario_node.dart';
import 'package:phrase_recorder/exercises/transition.dart';

class Scenario {
  late ScenarioNode _node;
  ScenarioNode get node => _node;

  final _state = <String, Set<String>>{};
  bool get isReady {
    return _state[node.state ?? '']?.isNotEmpty ?? false;
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
  }

  Scenario(
    this.nodes, {
    starting = 'start',
  }) {
    _node = nodes[starting]!;
    progress.add(node);
  }
}
