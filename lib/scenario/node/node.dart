import 'package:phrase_recorder/scenario/transition.dart';
import 'package:phrase_recorder/utils.dart';

class Node<T> {
  final String text;
  final String? question;
  final String? state;
  final String? type;
  final String? outcome;
  final T? exercise;
  final List<Transition>? transitions;

  Node({
    required this.text,
    this.question,
    this.state,
    this.type,
    this.exercise,
    this.transitions,
    this.outcome,
  });

  Node.fromJSON(
    Map<String, dynamic> json, {
    required T exercise,
  }) : this(
          text: json['text'],
          question: json['question'],
          state: json['state'],
          type: json['type'],
          outcome: json['outcome'],
          transitions: listFromJson(
            json['transitions'],
            (t) => Transition.fromJSON(t),
          ),
          exercise: exercise,
        );
}
