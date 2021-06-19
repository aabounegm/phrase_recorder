import 'package:phrase_recorder/utils.dart';

class ChoiceOption {
  final String id;
  final String text;

  ChoiceOption(this.id, this.text);
}

class ChoiceExercise {
  final List<ChoiceOption> options;
  final bool multichoice;

  const ChoiceExercise({
    required this.options,
    this.multichoice = false,
  });

  ChoiceExercise.fromJSON(
    Map<String, dynamic> json,
  ) : this(
          options: listFromJson<ChoiceOption>(
            json['options'],
            (o) => ChoiceOption(o['id'], o['text']),
          ),
          multichoice: json['multichoice'],
        );
}
