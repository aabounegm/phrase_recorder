import 'package:phrase_recorder/scenario/exercises/option.dart';
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

  Node.fromJson(
    Map<String, dynamic> json,
  ) : this(
          text: json['text'],
          question: json['question'],
          state: json['state'],
          type: json['type'],
          outcome: json['outcome'],
          transitions: listFromJson(
            json['transitions'],
            (t) => Transition.fromJSON(t),
          ),
          exercise: json['type'] == 'typing'
              ? json['exercise']
              : listFromJson(
                  json['exercise'],
                  (o) => Option.fromJson(o),
                ),
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['text'] = text;
    if (question != null) {
      data['question'] = question;
    }
    if (state != null) {
      data['state'] = state;
    }
    if (type != null) {
      data['type'] = type;
    }
    if (outcome != null) {
      data['outcome'] = outcome;
    }
    if (transitions != null) {
      data['transitions'] = transitions!.map((v) => v.toJson()).toList();
    }
    if (exercise != null) {
      data['exercise'] = type == 'typing'
          ? exercise
          : (exercise as Iterable).map((v) => v.toJson()).toList();
    }
    return data;
  }
}
