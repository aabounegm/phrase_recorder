import 'package:phrase_recorder/exercises/transition.dart';
import 'package:phrase_recorder/utils.dart';

import 'choice_exericise.dart';

class ChoiceNode {
  final String text;
  final String? question;
  final String? state;
  final ChoiceExercise exercise;
  final List<Transition>? transitions;

  ChoiceNode({
    required this.text,
    this.question,
    this.state,
    required this.exercise,
    this.transitions,
  });

  ChoiceNode.fromJSON(
    Map<String, dynamic> json,
  ) : this(
          text: json['text'],
          question: json['question'],
          state: json['state'],
          exercise: ChoiceExercise.fromJSON(
            json['exercise'],
          ),
          transitions: listFromJson(
            json['transitions'],
            (t) => Transition.fromJSON(t),
          ),
        );
}
