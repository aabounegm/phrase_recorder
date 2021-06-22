import 'package:phrase_recorder/scenario/transition.dart';
import 'node/node.dart';

class Scenario {
  int _score = 0;
  int get score => _score;

  late Node _node;
  Node get node => _node;
  bool get finished => node.outcome != null;

  final state = <String, List<String>>{};

  bool get ready {
    if (finished) return false;
    if (node.state == null) return true;
    return state[node.state]?.isNotEmpty ?? false;
  }

  final Map<String, Node> nodes;
  final List<Node> progress = [];

  void _selectNode(Node node) {
    _node = node;
    progress.add(node);
    if (node.state != null && state[node.state] == null) {
      state[node.state!] = [];
    }
  }

  void moveNext() {
    final transition = this.node.transitions?.firstWhere(
          (t) => t.evaluate(state),
          orElse: () => Transition(''),
        );

    final id = transition?.target ?? '';
    if (id.isEmpty) return;

    _score += transition!.score;

    final node = _score.isNegative ? nodes['loss'] : nodes[transition.target];
    if (node == null) return;

    _selectNode(node);
  }

  Scenario(
    this.nodes, {
    score = 0,
  }) {
    _score = score;
    _selectNode(nodes['start']!);
  }
}
