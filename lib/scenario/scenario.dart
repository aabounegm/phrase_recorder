import 'package:phrase_recorder/scenario/transition.dart';
import 'node/node.dart';

class Scenario {
  int _score = 0;
  int get score => _score;

  late Node _node;
  Node get node => _node;
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

  final Map<String, Node> nodes;
  final List<Node> progress = [];

  void moveNext() {
    final transition = this.node.transitions?.firstWhere(
          (t) => t.evaluate(_state),
          orElse: () => Transition(''),
        );

    final id = transition?.target ?? '';
    if (id.isEmpty) return;

    _score += transition!.score;

    final node = _score.isNegative ? nodes['loss'] : nodes[transition.target];
    if (node == null) return;

    _node = node;
    progress.add(this.node);
  }

  Scenario(
    this.nodes, {
    score = 0,
  }) {
    _score = score;
    _node = nodes['start']!;
    progress.add(node);
  }
}