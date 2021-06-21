import 'package:phrase_recorder/exercises/transition.dart';
import 'package:phrase_recorder/utils.dart';

class ScenarioNode<T> {
  final String text;
  final String? question;
  final String? state;
  final String? type;
  final T? exercise;
  final List<Transition>? transitions;

  ScenarioNode({
    required this.text,
    this.question,
    this.state,
    this.type,
    this.exercise,
    this.transitions,
  });

  ScenarioNode.fromJSON(
    Map<String, dynamic> json, {
    required T exercise,
  }) : this(
          text: json['text'],
          question: json['question'],
          state: json['state'],
          type: json['type'],
          transitions: listFromJson(
            json['transitions'],
            (t) => Transition.fromJSON(t),
          ),
          exercise: exercise,
        );
}
