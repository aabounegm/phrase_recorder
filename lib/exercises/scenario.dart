import 'package:phrase_recorder/exercises/choice/choice_card_widget.dart';
import 'package:phrase_recorder/exercises/transition.dart';

class ScenarioNode {
  final ChoiceExerciseData exercise;
  final String? result;
  final List<Transition>? transitions;

  const ScenarioNode(
    this.exercise, {
    this.result,
    this.transitions,
  });

  String nextNode(Map<String, Set<String>> state) {
    return transitions
            ?.firstWhere(
              (t) => t.evaluate(state),
              orElse: () => Transition(target: ''),
            )
            .target ??
        '';
  }
}

class Scenario {
  String current;
  final Map<String, ScenarioNode> nodes;

  ScenarioNode? get node => nodes[current];

  Scenario(
    this.nodes, {
    this.current = 'start',
  });
}
