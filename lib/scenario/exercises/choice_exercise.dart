import 'package:phrase_recorder/utils.dart';

class ExerciseOption {
  final String id;
  final String text;

  ExerciseOption(this.id, this.text);
}

class ChoiceExercise {
  final List<ExerciseOption> options;
  final bool multichoice;

  const ChoiceExercise({
    required this.options,
    this.multichoice = false,
  });

  @override
  ChoiceExercise.fromJSON(
    Map<String, dynamic> json,
  ) : this(
          options: listFromJson<ExerciseOption>(
            json['options'],
            (o) => ExerciseOption(o['id'], o['text']),
          ),
          multichoice: json['multichoice'],
        );
}
